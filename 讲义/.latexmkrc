# imakeidx writes one .idx file per index. Let latexmk run xindy so
# failures become build failures instead of being hidden by TeX shell escape.
$makeindex = 'internal lalu_xindy %S %D %O';

sub lalu_xindy {
    my ($source, $destination, @latexmk_options) = @_;

    my @modules = $source =~ m{(?:^|[\\/])sym[.]idx\z}
        ? ('-M', 'numeric-sort',
           '-M', 'latex',
           '-M', 'latex-loc-fmts',
           '-M', 'makeindex')
        : ('-M', 'texindy');

    my $status = system(
        'xindy',
        @latexmk_options,
        @modules,
        '-I', 'xelatex',
        '-C', 'utf8',
        '-o', $destination,
        $source,
    );

    return 127 if $status == -1;
    return 128 + ($status & 127) if $status & 127;
    return $status >> 8;
}
