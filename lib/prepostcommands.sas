/* File to Set-Up Pre and Post Processing for SAS2PDF*/

/* Jacob M Murray, 20180912 */
/* questions at jacobmatthewmurray at gmail dot com */


/* PreProcessing */ 

%macro s2p_preprocessing(_pdfname, _outdir);
	%GLOBAL pdfname; 
	%GLOBAL quoterep;
	%GLOBAL fp; 
	%GLOBAL backuppath;
	%GLOBAL SC;
 
	%LET pdfname=&_pdfname.; 
	
	%LET SC=SYSTASK COMMAND;
	%LET quoterep='¢';

	%LET f=%sysget(SAS_EXECFILENAME);
	%LET p=%sysget(SAS_EXECFILEPATH);
	%LET fp=%sysfunc(tranwrd(&p,&f, ));
	
	%IF &_outdir.=None %THEN %DO;
			%LET backuppath=&fp.&_pdfname._texbackup;
		%END; 
		%ELSE %DO;
			%LET backuppath=&_outdir.; 
		%END; 

	/* Clear and Rebuild Reporting File and Folder Structure*/

	&SC "del /q &fp.&_pdfname..pdf;" SHELL WAIT;
	&SC "rmdir /q /s ""&backuppath.""" SHELL WAIT;
	&SC "mkdir ""&backuppath.""" SHELL WAIT;
	&SC "mkdir ""&backuppath.\sasoutput""" SHELL WAIT;

%mend;


/* PostProcessing */ 

/* 

Issues here are bounding box problems on latex to dvips.


%macro s2p_postprocessing;
	X CD &backuppath;
	&SC "latex ""&backuppath\&pdfname..tex""" SHELL WAIT;
	&SC "latex ""&backuppath\&pdfname..tex""" SHELL WAIT;
	&SC "dvips ""&backuppath\&pdfname..dvi""" SHELL WAIT;
	&SC "ps2pdf14 ""&backuppath\&pdfname..ps"" ""&fp\&pdfname..pdf""" SHELL WAIT;
%mend; 
*/

%macro s2p_postprocessing;
	X CD &backuppath;
	&SC "pdflatex ""&backuppath\&pdfname..tex""" SHELL WAIT;
	&SC "pdflatex ""&backuppath\&pdfname..tex""" SHELL WAIT;
%mend; 
