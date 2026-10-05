%!TEX TS-program = xelatex
%!TEX encoding = UTF-8

% This class is based on AJbook by Wen-Wei Li, originally released under CC BY 4.0.
% Linear Algebra Left Undone is released under CC BY-NC-SA 4.0.

% Identification
% --------------
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{LALUbook}[Class for the book Linear Algebra Left Undone]

\RequirePackage{kvoptions}
\RequirePackage{etoolbox}

\SetupKeyvalOptions{
    family = @LALU,
    prefix = @LALU@
}

% Declaration of options
% ----------------------
\DeclareBoolOption[false]{draft} % 预留：尚无自定义未定稿标记；全局 draft 仍会影响支持它的宏包
\DeclareBoolOption[true]{colors} % 是否让链接带颜色
\DeclareBoolOption[false]{CJKthechapter} % 预留：目前尚未实现中文章编号天眉
\DeclareStringOption{coverpage} % 预留：目前尚未使用的封面档档名
\DeclareStringOption{fontsetup} % 预留：目前尚未使用的字体设定档档名
\DeclareStringOption{titlesetup} % 预留：目前尚未使用的章节标题设定档档名
\DeclareStringOption[16k]{geometry} % 版面（默认 16k）

% 将 10pt/11pt/12pt、oneside/twoside、openany/openright 等标准选项
% 交由底层 ctexbook 处理。
\newcommand*{\LALU@rejectpaperoption}{%
    \ClassError{LALUbook}{Class option `\CurrentOption' conflicts with `geometry'}%
        {Use `geometry=a4' for A4 paper. Supported layouts are `geometry=16k' and `geometry=a4'.}%
}
\DeclareVoidOption{a4paper}{\LALU@rejectpaperoption}
\DeclareVoidOption{a5paper}{\LALU@rejectpaperoption}
\DeclareVoidOption{b5paper}{\LALU@rejectpaperoption}
\DeclareVoidOption{letterpaper}{\LALU@rejectpaperoption}
\DeclareVoidOption{legalpaper}{\LALU@rejectpaperoption}
\DeclareVoidOption{executivepaper}{\LALU@rejectpaperoption}
\DeclareVoidOption{landscape}{\LALU@rejectpaperoption}
\DeclareDefaultOption{\PassOptionsToClass{\CurrentOption}{ctexbook}}

\PassOptionsToPackage{dvipsnames}{xcolor} % 让 xcolor 带 dvipsnames 选项; tikz 随后会载入之.

\ProcessKeyvalOptions*
\relax

% Package loading
\LoadClass{ctexbook}

\RequirePackage{ctex}
\RequirePackage{geometry}
\RequirePackage{fontspec}

\RequirePackage{bm}
\RequirePackage{mathrsfs}
\RequirePackage{amssymb}
\RequirePackage{mathtools}
\RequirePackage{amsthm}

% 加入字串处理功能
\RequirePackage{xstring}
\RequirePackage{xspace}

% 设置天眉所需
\RequirePackage{fancyhdr}
\RequirePackage{emptypage}

\RequirePackage{graphicx}
\RequirePackage{float}
\RequirePackage[inline]{enumitem}
\RequirePackage{multicol}
\RequirePackage{pdfpages}
\RequirePackage{indentfirst}
\RequirePackage{titlesec}
\RequirePackage{mismath} % 包含 rank, span 等运算符
\RequirePackage{zhnumber}
\RequirePackage{array}
\RequirePackage{arydshln}
\RequirePackage{tikz}
\RequirePackage{rotating}

\RequirePackage[many]{tcolorbox}

% Package settings
% ----------------
\titleformat{\section}{\centering\Large\bfseries}{\thesection}{1em}{}

\renewcommand{\vec}[1]{\boldsymbol{#1}} % 生成粗体向量，而非带箭头的向量

% 首行缩进 2 字符
\setlength{\parindent}{2em}

\usetikzlibrary{shapes.symbols}

% 设置页面尺寸
\IfStrEq{\@LALU@geometry}{16k}{% 载入 16k 版面设置
    \geometry{
        paperheight = 260mm,
        paperwidth = 185mm,
        top = 23mm,
        bottom = 23mm,
        left = 20mm,
        right = 20mm,
        headheight = 5ex,
        headsep = 5ex,
        % bindingoffset = 18pt,
    }}{% 载入 A4 版面设置或报告不支持的值
    \IfStrEq{\@LALU@geometry}{a4}{
        \geometry{a4paper}
    }{
        \ClassError{LALUbook}{Unknown geometry `\@LALU@geometry'}%
            {Supported geometry values are `16k' and `a4'.}
    }}

% 章首页不显示页眉；由 emptypage 保证双面排版所插入的空页恒空
\fancypagestyle{plain}{
    \fancyhead{}
    \renewcommand{\headrulewidth}{0pt}
}

% 嵌套 enumerate 环境的 label
\setlist[enumerate,2]{label=(\arabic*)}
\setlist[enumerate,3]{label=\roman*.}

\titleformat{\section}{\centering\Large\bfseries}{\thesection}{1em}{}

\DeclareMathOperator{\diag}{diag}

\tcbset{laluthmstyle/.style={
            breakable,
            colframe=#1!50!black,
            coltitle=black,
            colbacktitle=#1!5,
            colback=white,
            fonttitle=\bfseries,
            leftrule=0pt,
            rightrule=0pt,
            enhanced jigsaw,
            sharp corners,
            toptitle=1mm,
            bottomtitle=1mm,
            separator sign={\quad},
            toprule=1pt,
            titlerule=1pt,
            bottomrule=1pt,
            overlay first={
                    \draw[thick,#1!50!black,dashed]
                    (frame.south west) -- (frame.south east);
                },
            overlay middle={
                    \draw[thick,#1!50!black,dashed]
                    (frame.north west) -- (frame.north east)
                    (frame.south west) -- (frame.south east);
                },
            overlay last={
                    \draw[thick,#1!50!black,dashed]
                    (frame.north west) -- (frame.north east);
                },
        }
}

\NewTColorBox{tcblaluthmbox}{mmm}{
    laluthmstyle={teal},
    colframe=teal!80!black,
    title=#1\IfBlankF{#2}{\quad#2},
    #3,
}

% amsthm 负责 QED 栈和 \qedhere，tcolorbox 只负责外观。
\renewcommand*{\qedsymbol}{$\square$}
\RenewDocumentEnvironment{proof}{O{}}{%
    \pushQED{\qed}%
    \begin{tcblaluthmbox}{{\heiti 证明}}{#1}{}%
    \fangsong\ignorespaces
}{%
    \popQED
    \end{tcblaluthmbox}%
}
\NewDocumentEnvironment{solution}{O{}}{%
    \begin{tcblaluthmbox}{{\heiti 解}}{#1}{}%
    \fangsong\ignorespaces
}{%
    \end{tcblaluthmbox}%
}

% 定理环境的名称、颜色、标签前缀与引用名称由同一处声明。
\newcommand*{\LALU@DeclareBoxedTheorem}[4]{%
    \newtcbtheorem[number within=chapter]{#1}{#2}{laluthmstyle={#3}}{#4}%
    \expandafter\def\csname tcb@cnt@#1autorefname\endcsname{#2}%
    \crefname{tcb@cnt@#1}{#2}{#2}%
    \Crefname{tcb@cnt@#1}{#2}{#2}%
}

\NewDocumentCommand{\term}{m}{{\sffamily\heiti\bfseries{#1}}}

\DeclareMathOperator{\Ob}{Ob}
\DeclareMathOperator{\Hom}{Hom}
\DeclareMathOperator{\Gal}{Gal}
\DeclareMathOperator{\cha}{char}
\newcommand{\cC}{\mathcal{C}}
\newcommand{\cD}{\mathcal{D}}
\newcommand{\FVect}{\mathsf{FVect}}
\newcommand{\Set}{\mathsf{Set}}
\newcommand{\FSet}{\mathsf{FSet}}

% 文档入口在自身的宏包和定义之后显式调用此命令，以保持
% hyperref/cleveref 的载入次序，而不依赖隐式的 begin-document 钩子。
\newif\ifLALU@preamble@finalized
\newcommand*{\LALUFinalizePreamble}{%
  \ifLALU@preamble@finalized
    \ClassError{LALUbook}{Preamble already finalized}%
      {Call \string\LALUFinalizePreamble\space exactly once, after document-specific packages and definitions.}%
  \else
    \global\LALU@preamble@finalizedtrue
    \RequirePackage[Bjornstrup]{fncychap} % found on Internet

    % hyperref 与 cleveref 需要最后引入
    \RequirePackage{hyperref}
    \RequirePackage{bookmark}
    \RequirePackage{cleveref}

    % hyperref 在链接组内组装引用文字，XeCJK 因此无法总是从
    % 后继中文字符自动推断边界间距。xspace 在正文前补等价空格，
    % 而在中英文标点和括号前保持紧贴。
    \xspaceaddexceptions{%
        ,.;:!?()[]%
        ，。．、；：？！%
        （）［］〔〕【】〖〗〘〙〚〛%
        〈〉《》「」『』“”‘’%
        …—·%
    }
    \NewCommandCopy{\LALU@hyperref@autoref}{\autoref}
    \RenewDocumentCommand{\autoref}{s m}{%
        \IfBooleanTF{##1}
            {\LALU@hyperref@autoref*{##2}}
            {\LALU@hyperref@autoref{##2}}%
        \xspace
    }

    \LALU@DeclareBoxedTheorem{definition}{定义}{red}{def}
    \LALU@DeclareBoxedTheorem{example}{例}{blue}{ex}
    \LALU@DeclareBoxedTheorem{lemma}{引理}{orange}{lem}
    \LALU@DeclareBoxedTheorem{theorem}{定理}{violet}{thm}
    \LALU@DeclareBoxedTheorem{corollary}{推论}{green}{cor}
    \LALU@DeclareBoxedTheorem{axiom}{公理}{olive}{axm}

    \hypersetup{
        unicode,
        bookmarksnumbered,
        pdfborder={0 0 0},
    }

    % 按 colors 的 Bool 值设置链接色彩.
    \if@LALU@colors
        \hypersetup{
            colorlinks,
            % linkcolor=blue,
            % citecolor=red,
            % urlcolor=teal
        }
    \else
        \hypersetup{hidelinks}
    \fi

    \renewcommand{\figureautorefname}{图}
    \renewcommand{\tableautorefname}{表}
    \renewcommand{\equationautorefname}{式}
    \renewcommand{\chapterautorefname}{章}
    \renewcommand{\sectionautorefname}{节}
    % https://tex.stackexchange.com/a/2244/316373
    \renewcommand*\env@matrix[1][*\c@MaxMatrixCols c]{%
    \hskip -\arraycolsep
    \let\@ifnextchar\new@ifnextchar
    \array{##1}}

    \crefrangeformat{equation}{式~##3##1##4--##5##2##6}
    \crefrangeformat{example}{例~##3##1##4--##5##2##6}
  \fi
}
\@onlypreamble\LALUFinalizePreamble
