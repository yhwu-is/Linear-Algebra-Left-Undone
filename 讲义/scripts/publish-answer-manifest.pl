#!/usr/bin/env perl

use strict;
use warnings;
use File::Basename qw(dirname);
use File::Spec;

sub usage {
    die "usage: $0 --check TEMP_MANIFEST\n"
      . "       $0 --publish TEMP_MANIFEST PUBLISHED_MANIFEST\n";
}

sub read_manifest {
    my ($path) = @_;

    -f $path or die "answer manifest was not generated: $path\n";
    open my $input, '<:raw', $path
        or die "cannot read answer manifest '$path': $!\n";
    local $/;
    my $contents = <$input>;
    close $input or die "cannot close answer manifest '$path': $!\n";

    defined $contents && length $contents
        or die "answer manifest is empty: $path\n";
    $contents !~ /\0/
        or die "answer manifest contains a NUL byte: $path\n";
    return $contents;
}

sub parse_reader_command {
    my ($line, $name, $arity, $line_number) = @_;
    my $prefix = "\\$name";

    index($line, $prefix) == 0
        or die "expected $prefix at line $line_number\n";

    my $length = length $line;
    my $position = length $prefix;
    if ($position < $length) {
        my $next = substr($line, $position, 1);
        $next =~ /[ \t{]/
            or die "invalid reader command name at line $line_number\n";
    }

    my @arguments;
    for (1 .. $arity) {
        ++$position while $position < $length
            && substr($line, $position, 1) =~ /[ \t]/;
        $position < $length && substr($line, $position, 1) eq '{'
            or die "reader command '$name' has no argument $_ at line $line_number\n";

        my $start = ++$position;
        my $depth = 1;
        while ($position < $length) {
            my $character = substr($line, $position, 1);

            # A control symbol such as \{ does not contribute a grouping brace.
            # Skipping the next byte is also sufficient for control words: the
            # remaining letters cannot affect brace depth.
            if ($character eq '\\') {
                $position + 1 < $length
                    or die "reader command '$name' ends in a bare backslash at line $line_number\n";
                $position += 2;
                next;
            }
            $character ne '%'
                or die "reader command '$name' contains an unescaped comment at line $line_number\n";
            if ($character eq '{') {
                ++$depth;
            }
            elsif ($character eq '}') {
                --$depth;
                if ($depth == 0) {
                    push @arguments, substr($line, $start, $position - $start);
                    ++$position;
                    last;
                }
            }
            ++$position;
        }
        $depth == 0
            or die "reader command '$name' has an unclosed argument $_ at line $line_number\n";
    }

    ++$position while $position < $length
        && substr($line, $position, 1) =~ /[ \t]/;
    $position == $length
        or die "reader command '$name' has trailing input at line $line_number\n";

    return @arguments;
}

sub is_uint {
    my ($value) = @_;
    return $value =~ /\A(?:0|[1-9]\d*)\z/;
}

sub validate_manifest {
    my ($path) = @_;
    my $contents = read_manifest($path);

    # The manifest is read as raw UTF-8 bytes.  Perl's \R also matches byte
    # 0x85, which commonly occurs as a UTF-8 continuation byte in Chinese
    # text, so only actual TeX input line endings may delimit records here.
    my @lines = split /\r\n|\n|\r/, $contents, -1;
    pop @lines if @lines && $lines[-1] eq '';
    @lines >= 3
        or die "answer manifest is incomplete: $path\n";

    my $line_index = 0;
    my $header = $lines[$line_index++];
    $header =~ /\A% LALU-ANSWER-MANIFEST schema=2 job=([A-Za-z0-9_.-]+)\z/
        or die "answer manifest has no valid schema header: $path\n";
    my $job = $1;

    my @reader_begin = parse_reader_command(
        $lines[$line_index], 'LALUAnswerManifestBegin', 2, $line_index + 1
    );
    ++$line_index;
    $reader_begin[0] eq '2'
        or die "answer manifest reader has unsupported schema '$reader_begin[0]'\n";
    $reader_begin[1] =~ /\A[A-Za-z0-9_.-]+\z/
        or die "answer manifest reader has an invalid job name\n";
    $reader_begin[1] eq $job
        or die "answer manifest header job '$job' does not match reader job '$reader_begin[1]'\n";

    my (%unit_ids, %group_ids, %item_ids);
    my ($current_unit, $current_group);
    my ($expected_group_items, $seen_group_items) = (0, 0);
    my ($unit_events, $group_events, $item_events) = (0, 0, 0);
    my %status_events = (answered => 0, todo => 0, omitted => 0);

    my @reader_end;
    while ($line_index < @lines) {
        my $line = $lines[$line_index];
        if (index($line, '\\LALUAnswerManifestEnd') == 0) {
            defined $current_group
                and die "answer manifest ends inside group '$current_group'\n";
            @reader_end = parse_reader_command(
                $line, 'LALUAnswerManifestEnd', 7, $line_index + 1
            );
            for my $value (@reader_end) {
                is_uint($value)
                    or die "answer manifest reader end contains a non-canonical count at line "
                        . ($line_index + 1) . "\n";
            }
            ++$line_index;
            last;
        }

        $line =~ /\A% LALU-MANIFEST-EVENT (.+)\z/
            or die "unexpected top-level input at line " . ($line_index + 1) . "\n";
        my $event = $1;
        my $human_line = $line_index + 1;
        ++$line_index;
        $line_index < @lines
            or die "event at line $human_line has no reader command\n";
        my $command = $lines[$line_index++];

        if ($event =~ /\Aunit id=(answer-unit:([1-9]\d*))\z/) {
            my ($id, $sequence) = ($1, $2);
            defined $current_group
                and die "unit '$id' begins before group '$current_group' ends\n";
            ++$unit_events;
            $id eq "answer-unit:$unit_events"
                or die "unit ID '$id' is out of sequence at line $human_line\n";
            !$unit_ids{$id}++
                or die "duplicate unit ID '$id' at line $human_line\n";
            my ($kind, $normal, $serial, $slot, $command_id) =
                parse_reader_command($command, 'LALUAnswerUnit', 6, $human_line + 1);
            $kind =~ /\A(?:normal|unfinished)\z/
                && is_uint($normal) && is_uint($serial) && is_uint($slot)
                && $command_id eq $id
                or die "unit marker at line $human_line does not match its reader command\n";
            if ($kind eq 'normal') {
                $normal > 0 && $serial == 0 && $slot == 0
                    or die "invalid normal-unit metadata at line $human_line\n";
            }
            else {
                $normal > 0 && $serial > 0 && $slot >= 1 && $slot <= 6
                    or die "invalid unfinished-unit metadata at line $human_line\n";
            }
            $current_unit = $id;
        }
        elsif ($event =~ /\Agroup-begin id=(answer-group:([1-9]\d*)) unit=(answer-unit:[1-9]\d*) number=([1-9]\d*) items=([1-9]\d*)\z/) {
            my ($id, $sequence, $unit, $number, $items) = ($1, $2, $3, $4, $5);
            defined $current_unit
                or die "group '$id' appears before the first unit\n";
            !defined $current_group
                or die "nested group '$id' at line $human_line\n";
            $unit eq $current_unit
                or die "group '$id' belongs to '$unit', not current unit '$current_unit'\n";
            ++$group_events;
            $id eq "answer-group:$group_events"
                or die "group ID '$id' is out of sequence at line $human_line\n";
            !$group_ids{$id}++
                or die "duplicate group ID '$id' at line $human_line\n";
            my @arguments = parse_reader_command(
                $command, 'LALUAnswerGroupBegin', 3, $human_line + 1
            );
            join("\0", @arguments) eq join("\0", $id, $number, $items)
                or die "group-begin marker at line $human_line does not match its reader command\n";
            $current_group = $id;
            $expected_group_items = $items;
            $seen_group_items = 0;
        }
        elsif ($event =~ /\Aitem id=(answer-item:([1-9]\d*)) group=(answer-group:[1-9]\d*) number=([1-9]\d*) status=(answered|todo|omitted)\z/) {
            my ($id, $sequence, $group, $number, $status) = ($1, $2, $3, $4, $5);
            defined $current_group
                or die "item '$id' appears outside a group\n";
            $group eq $current_group
                or die "item '$id' belongs to '$group', not current group '$current_group'\n";
            ++$item_events;
            ++$seen_group_items;
            $id eq "answer-item:$item_events"
                or die "item ID '$id' is out of sequence at line $human_line\n";
            !$item_ids{$id}++
                or die "duplicate item ID '$id' at line $human_line\n";
            ++$status_events{$status};
            my @arguments = parse_reader_command(
                $command, 'LALUAnswerItem', 4, $human_line + 1
            );
            join("\0", @arguments[0 .. 2]) eq join("\0", $id, $number, $status)
                or die "item marker at line $human_line does not match its reader command\n";
        }
        elsif ($event =~ /\Agroup-end id=(answer-group:[1-9]\d*) items=([1-9]\d*)\z/) {
            my ($id, $items) = ($1, $2);
            defined $current_group
                or die "group-end '$id' appears without a group-begin\n";
            $id eq $current_group
                or die "group-end '$id' does not match current group '$current_group'\n";
            $items == $expected_group_items && $seen_group_items == $expected_group_items
                or die "group '$id' item count mismatch\n";
            my @arguments = parse_reader_command(
                $command, 'LALUAnswerGroupEnd', 2, $human_line + 1
            );
            join("\0", @arguments) eq join("\0", $id, $items)
                or die "group-end marker at line $human_line does not match its reader command\n";
            undef $current_group;
            ($expected_group_items, $seen_group_items) = (0, 0);
        }
        else {
            die "unknown answer manifest event at line $human_line: $event\n";
        }
    }

    @reader_end
        or die "answer manifest has no reader end record: $path\n";
    $line_index < @lines
        or die "answer manifest has no end sentinel: $path\n";
    my $footer = $lines[$line_index++];
    my ($total_units, $total_groups, $emitted_groups, $total_items,
        $answered, $todo, $omitted) =
        $footer =~ /\A% LALU-ANSWER-MANIFEST-END total-units=(0|[1-9]\d*) total-groups=(0|[1-9]\d*) emitted-groups=(0|[1-9]\d*) total-items=(0|[1-9]\d*) answered=(0|[1-9]\d*) todo=(0|[1-9]\d*) omitted=(0|[1-9]\d*)\z/;
    defined $omitted
        or die "answer manifest has no valid end sentinel at line $line_index: $path\n";
    $line_index == @lines
        or die "unexpected input after answer manifest footer at line "
            . ($line_index + 1) . "\n";

    my @footer_counts = ($total_units, $total_groups, $emitted_groups,
                         $total_items, $answered, $todo, $omitted);
    join("\0", @reader_end) eq join("\0", @footer_counts)
        or die "answer manifest reader statistics do not match its end sentinel\n";

    $unit_events == $total_units
        or die "answer manifest unit count mismatch: found $unit_events, expected $total_units\n";
    $group_events == $emitted_groups
        or die "answer manifest group count mismatch: found $group_events, expected $emitted_groups\n";
    $emitted_groups <= $total_groups
        or die "answer manifest emitted more groups than it observed\n";
    $item_events == $total_items
        or die "answer manifest item count mismatch: found $item_events, expected $total_items\n";
    $answered + $todo + $omitted == $total_items
        or die "answer manifest status counts do not add up\n";
    $status_events{answered} == $answered
        or die "answered item count mismatch\n";
    $status_events{todo} == $todo
        or die "todo item count mismatch\n";
    $status_events{omitted} == $omitted
        or die "omitted item count mismatch\n";

    return {
        job            => $job,
        units          => $total_units,
        total_groups   => $total_groups,
        emitted_groups => $emitted_groups,
        answered       => $answered,
        todo           => $todo,
        omitted        => $omitted,
    };
}

my ($mode, $temporary, $published);
if (@ARGV == 2 && $ARGV[0] eq '--check') {
    ($mode, $temporary) = @ARGV;
}
elsif (@ARGV == 3 && $ARGV[0] eq '--publish') {
    ($mode, $temporary, $published) = @ARGV;
}
else {
    usage();
}

my $stats = validate_manifest($temporary);

if ($mode eq '--publish') {
    my $temporary_directory = File::Spec->rel2abs(dirname($temporary));
    my $published_directory = File::Spec->rel2abs(dirname($published));
    -d $published_directory
        or die "published answer manifest directory does not exist: $published_directory\n";
    $temporary_directory eq $published_directory
        or die "temporary and published manifests must be in the same directory\n";
    rename $temporary, $published
        or die "cannot atomically publish '$temporary' as '$published': $!\n";
    print "Published answer manifest: $published\n";
}
else {
    print "Validated answer manifest: $temporary\n";
}

print "  units $stats->{units}, groups $stats->{emitted_groups}/$stats->{total_groups}, "
    . "answers $stats->{answered}, todo $stats->{todo}, omitted $stats->{omitted}\n";
