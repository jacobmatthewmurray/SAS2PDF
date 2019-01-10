%macro listingssastex;
	%t('\input{'%sysfunc(tranwrd(&s2p.,\,/))'/lib/listings-sas-tex.tex}'); 
%mend;
