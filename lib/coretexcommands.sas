/*Plain Feed Code to Tex*/
%macro t(_text);

	options nosource nonotes;

	data _null_;
		length _text $5000.; 

		_text = SYMGET('_text');
		_text = COMPRESS(_text, "'");
		_text = TRANSLATE(_text, "'", '¢');

		file "&backuppath.\&pdfname..tex" mod; 

		put _text; 

	run;

	options source notes; 

%mend;


%macro s2p_text(_text);
	%t(&_text.); 
%mend;



%macro s2p_begindoc;
	%t('\begin{document}');
%mend; 

%macro s2p_enddoc;
	%t('\end{document}');
%mend; 

%macro s2p_section(_section);
	%t(\section{&_section.});
%mend;

%macro s2p_subsection(_subsection);
	%t(\subsection{&_subsection.});
%mend;

%macro s2p_tableofcontents;
	%t('\tableofcontents');
%mend; 

%macro s2p_maketitle;
	%t('\maketitle');
%mend; 


%macro s2p_author(_author);
	%t(\author{&_author.});
%mend; 

%macro s2p_title(_title);
	%t(\title{&_title.});
%mend; 

%macro s2p_usepackage(_package);
	%t(\usepackage{&_package.}); 
%mend;


%macro s2p_headerfooter(header_icon);
	%t('\usepackage{fancyhdr}');
	%t('\usepackage{lastpage}');
	%t('\makeatletter');
	%t('\let\inserttitle\@title');
	%t('\makeatother');
	%t('\setlength{\headheight}{15pt}');
	%t('\pagestyle{fancyplain}');
	%t('\fancyhf{}');
	%IF &header_icon. ne None %THEN %DO;
		%t('\rhead{ \fancyplain{}{\includegraphics[width=1cm]{'&header_icon.'}} }');
		%END; 
	%t('\chead{ \fancyplain{}{\inserttitle} }');
	%t('\lhead{ \fancyplain{}{\today} }');
	%t('\cfoot{ \fancyplain{}{\thepage\ of \pageref{LastPage}} }');
%mend;

%macro s2p_standard_preprocessing(
	project=DefaultProjectName,
	title=DefaultTitle,
	header_icon=None,
	author=DefaultAuthor,
	titlepage=None, 
	outdir=None);

	%s2p_preprocessing(&project., &outdir.);

	%t('\documentclass[11pt,a4paper]{article}');

	%t('\usepackage{fullpage}');
	%t('\usepackage{graphicx}');
	%t('\usepackage[T1]{fontenc}');
	%t('\usepackage{longtable}');
	%t('\usepackage{times}');

	%listingssastex;

	%s2p_title(&title.);
	%s2p_author(&author.);

	%s2p_headerfooter(&header_icon.);

	%s2p_begindoc;

	%if &titlepage. ne None %then %do;
		%t('\input{'&titlepage.'}');
		%end; 

	%s2p_maketitle;
	%s2p_tableofcontents;

%mend;

%macro s2p_standard_postprocessing;
	%s2p_enddoc;
	%s2p_postprocessing;
%mend;
