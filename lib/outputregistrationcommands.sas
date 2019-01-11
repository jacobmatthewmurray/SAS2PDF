 %macro s2p_preoutreg(_name);
 	&SC "mkdir ""&backuppath.\sasoutput\&_name.""" SHELL WAIT;
 	ods graphics on / reset=index imagefmt=png imagename="&_name.";
	ods listing close;
	ods tagsets.tablesonlylatex file="&_name..tex" (notop nobot) path="&backuppath.\sasoutput\&_name." newfile=table style=Journal;
	options nonotes source;
	proc printto log="&backuppath.\sasoutput\&_name.\&_name.0.txt";
	run;
 %mend; 

 %macro s2p_postoutreg(_name);
 	options notes nosource;
	proc printto;
	run;
 	ods tagsets.tablesonlylatex close;
	ods listing;

	data _null_;
		infile 	"&backuppath.\sasoutput\&_name.\&_name.0.txt" length=linelen lrecl=500 pad;
		file "&backuppath.\sasoutput\&_name.\&_name.0.tex";
		input texcode $varying500. linelen;

		tss=find(texcode, '  ');

		if tss=1 then delete;
		if tss>1 and tss<6 then texcode=substr(texcode,6,length(texcode));
		if tss ge 6 then texcode=substr(texcode,tss+1,length(texcode));

		if texcode='' then delete; 
		if texcode=' options notes nosource;' then delete;
		if find(texcode, '%s2p_postoutreg') ge 1 then delete;

		drop tss;

		put texcode $500.;
	run;

 %mend;


 %macro s2p_includeoutput(_outname, _num, _caption);

	%LET outname=&_outname.;

	%IF &_num.=0 %THEN %DO;
	
		%t('\lstset{language=SAS,style=sas-editor}');
		%t('\begin{lstlisting}[frame=single, caption={'&_caption.'}]');
		&SC "type &backuppath.\sasoutput\&outname.\&outname.0.tex >> &backuppath.\&pdfname..tex" SHELL WAIT;
		%t('\end{lstlisting}'); 

	%END;

	%ELSE %DO;
	
		%LET n=%eval(&_num.-1);
		%LET _incltype=table;

		%IF &n.=0 %THEN %LET n=;

		data test;
			infile 	"&backuppath.\sasoutput\&outname.\&outname.&n..tex" truncover;
			file "&backuppath.\sasoutput\&outname.\&outname.&n._converted.tex";
			input texcode $Char2000.;
			if find(texcode,'\includegraphics','i') ge 1 then do;
				call symput('_incltype', 'figure');
				texcode=tranwrd(texcode,'\','/');
				texcode=tranwrd(texcode,'/includegraphics','\includegraphics[width=.9\linewidth]');
			end;
			if find(texcode, byte(160), 'i') ge 1 then do;
				texcode = tranwrd(texcode, byte(160), '~');
			end;
			put texcode $Char2000.;
		run;

		%t('\begin{'&_incltype.'}[h]');
		%t('\caption{'&_caption.'}');
		%t('\centering');

		&SC "type &backuppath.\sasoutput\&outname.\&outname.&n._converted.tex >> &backuppath.\&pdfname..tex" SHELL WAIT;

		%t('\end{'&_incltype.'}');
	
	%END;

 %mend;

