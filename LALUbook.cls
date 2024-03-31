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
\DeclareBoolOption[false]{draft} % 是否打上未定稿标记
\DeclareBoolOption[true]{colors} % 是否让链接带颜色
\DeclareBoolOption[false]{CJKthechapter} % 是否让天眉的各章编号使用中文数字
\DeclareStringOption{coverpage} % 封面档档名, 默认为空
\DeclareStringOption{fontsetup} % 字体设定档档名
\DeclareStringOption{titlesetup} % 章节标题设定档档名
\DeclareStringOption[16k]{geometry} % 版面（默认 16k）

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

% 加入字串处理功能
\RequirePackage{xstring}

% 设置天眉所需
\RequirePackage{fancyhdr}

\RequirePackage{graphicx}
\RequirePackage{float}
\RequirePackage{enumitem}
\RequirePackage{multicol}
\RequirePackage{pdfpages}
\RequirePackage{indentfirst}
\RequirePackage{ntheorem}
\RequirePackage{titlesec}
\RequirePackage{mismath} % 包含 rank, span 等运算符
\RequirePackage{zhnumber}
\RequirePackage{array}
\RequirePackage{arydshln}
\RequirePackage{tikz}

\RequirePackage[many]{tcolorbox}

% Package settings
% ----------------
\titleformat{\section}{\centering\Large\bfseries}{\thesection}{1em}{}

\renewcommand{\vec}[1]{\boldsymbol{#1}} % 生成粗体向量，而非带箭头的向量

% 首行缩进 2 字符
\setlength{\parindent}{2em}

% 定理字体
\theoremheaderfont{\bfseries\heiti}
\theorembodyfont{\fangsong}

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
        textwidth = 132mm,
        textheight = 198mm,
        twoside,
        asymmetric, % 单双数页不分
        % bindingoffset = 18pt,
    }}{}

\IfStrEq{\@LALU@geometry}{a4}{% 载入 a4 版面设置
    \geometry{
        a4paper,
        twoside,
        asymmetric,
    }}{}

% 使空页恒空
\fancypagestyle{plain}{
    \fancyhead{}
    \renewcommand{\headrulewidth}{0pt}
}

% 嵌套 enumerate 环境的 label
\setlist[enumerate,2]{label=(\arabic*)}
\setlist[enumerate,3]{label=\roman*.}

\titleformat{\section}{\centering\Large\bfseries}{\thesection}{1em}{}

\DeclareMathOperator{\diag}{diag}

\tcbset{commonstyle/.style={
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
    commonstyle={teal},
    colframe=teal!80!black,
    title=#1\IfBlankF{#2}{\quad#2},
    #3,
}

\NewDocumentEnvironment{proof}{O{}O{}}{\begin{tcblaluthmbox}{{\heiti 证明}}{#1}{#2}\fangsong}{\hspace*{\fill}$\square$\end{tcblaluthmbox}}
\NewDocumentEnvironment{solution}{O{}O{}}{\begin{tcblaluthmbox}{{\heiti 解}}{#1}{#2}\fangsong}{\end{tcblaluthmbox}}

\newcommand{\Ob}{\mathop\mathrm{Ob}}
\newcommand{\cC}{\mathcal{C}}
\newcommand{\cD}{\mathcal{D}}
\newcommand{\Hom}{\mathop\mathrm{Hom}}
\newcommand{\FVect}{\mathsf{FVect}}
\newcommand{\Set}{\mathsf{Set}}
\newcommand{\FSet}{\mathsf{FSet}}

\AtEndPreamble{
    \RequirePackage[Bjornstrup]{fncychap} % found on Internet

    % hyperref 与 cleveref 需要最后引入
    \RequirePackage{hyperref}
    \RequirePackage{bookmark}
    \RequirePackage{cleveref}

    \newtcbtheorem[number within=chapter]{definition}{定义}{commonstyle={red}}{def}
    \newtcbtheorem[number within=chapter]{example}{例}{commonstyle={blue}}{ex}
    \newtcbtheorem[number within=chapter]{lemma}{引理}{commonstyle={orange}}{lem}
    \newtcbtheorem[number within=chapter]{theorem}{定理}{commonstyle={violet}}{thm}
    \newtcbtheorem[number within=chapter]{corollary}{推论}{commonstyle={green}}{cor}
    \newtcbtheorem[number within=chapter]{axiom}{公理}{commonstyle={olive}}{axm}

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
    \makeatletter
    \newcommand{\tcb@cnt@theoremautorefname}{定理}
    \newcommand{\tcb@cnt@lemmaautorefname}{引理}
    \newcommand{\tcb@cnt@corollaryautorefname}{推论}
    \newcommand{\tcb@cnt@exampleautorefname}{例}
    \newcommand{\tcb@cnt@definitionautorefname}{定义}
    \newcommand{\tcb@cnt@axiomautorefname}{公理}
    \makeatother

    \crefrangeformat{equation}{式~#3#1#4--#5#2#6}
    \crefrangeformat{example}{例~#3#1#4--#5#2#6}
}
