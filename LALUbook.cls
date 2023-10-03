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
\DeclareStringOption[]{coverpage} % 封面档档名, 默认为空
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
\RequirePackage[Bjornstrup]{fncychap} % found on Internet

\RequirePackage{bm}
\RequirePackage{mathrsfs}
\RequirePackage{amssymb}
\RequirePackage[intlimits]{mathtools}

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

\RequirePackage{tikz}

\RequirePackage[many]{tcolorbox}
\RequirePackage{mdframed}

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

\newenvironment{proof}{\fangsong}{\hspace*{\fill}$\square$\par}
\newenvironment{solution}{\fangsong}{\par}

\mdfdefinestyle{framestyle}{
    ntheorem=true,
    % roundcorner=10pt,
    innertopmargin=\topskip,
    theoremseparator={},
    theoremspace=\quad,
    frametitlerulewidth=.5pt,
    frametitlerule=true,
    linewidth=.5pt,
    leftline=false,
    rightline=false,
    topline=true,
    bottomline=true,
    frametitlealignment=\raggedright\noindent,
}

\mdtheorem[
    style=framestyle,
    linecolor=red!50!black,
    frametitlebackgroundcolor=red!5,
]{definition}{定义}[chapter]
\mdtheorem[
    style=framestyle,
    linecolor=blue!50!black,
    frametitlebackgroundcolor=blue!5,
]{example}{例}[chapter]
\mdtheorem[
    style=framestyle,
    linecolor=orange!50!black,
    frametitlebackgroundcolor=orange!5,
]{lemma}{引理}[chapter]
\mdtheorem[
    style=framestyle,
    linecolor=violet!50!black,
    frametitlebackgroundcolor=violet!5,
]{theorem}{定理}[chapter]
\mdtheorem[
    style=framestyle,
    linecolor=green!50!black,
    frametitlebackgroundcolor=green!5,
]{corollary}{推论}[chapter]
\mdtheorem[
    style=framestyle,
    linecolor=olive!50!black,
    frametitlebackgroundcolor=olive!5,
]{axiom}{公理}[chapter]
\surroundwithmdframed[
    style=framestyle,
    linecolor=teal!80!black,
    frametitlebackgroundcolor=teal!5,
    frametitle={\noindent\bfseries\heiti 证明},
    % frametitleaboveskip=\topskip,
    % frametitlebelowskip=\topskip,
]{proof}
\surroundwithmdframed[
    style=framestyle,
    linecolor=teal!80!black,
    frametitlebackgroundcolor=teal!5,
    frametitle={\noindent\bfseries\heiti 解},
    % frametitleaboveskip=\topskip,
    % frametitlebelowskip=\topskip,
]{solution}

\AtEndPreamble{
    % hyperref 与 cleveref 需要最后引入
    \RequirePackage{hyperref}
    \RequirePackage{cleveref}

    \hypersetup{
        unicode,
        bookmarksnumbered,
        pdfborder = {0 0 0},
    }

    % 按 colors 的 Bool 值设置链接色彩.
    \if@LALU@colors
        \hypersetup{
            colorlinks,
            % linkcolor = blue,
            % citecolor = red,
            % urlcolor = teal
        }
    \else
        \hypersetup{hidelinks}
    \fi

    \renewcommand{\figureautorefname}{图}
    \renewcommand{\tableautorefname}{表}
    \renewcommand{\equationautorefname}{式}
    \renewcommand{\theoremautorefname}{定理}
    \renewcommand{\sectionautorefname}{节}
    \newcommand{\lemmaautorefname}{引理}
    \newcommand{\corollaryautorefname}{推论}
    \newcommand{\exampleautorefname}{例}
    \newcommand{\definitionautorefname}{定义}
    \newcommand{\axiomautorefname}{公理}
    \crefrangeformat{equation}{式~#3#1#4--#5#2#6}
    \crefrangeformat{example}{例~#3#1#4--#5#2#6}
}
