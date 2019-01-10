%GLOBAL s2p;
%LET s2p=%sysfunc(tranwrd(%sysfunc(dequote(%sysget(S2P))),\lib\collector.sas, ));

%include "&s2p.\lib\listingssastex.sas";
%include "&s2p.\lib\prepostcommands.sas";
%include "&s2p.\lib\coretexcommands.sas";
%include "&s2p.\lib\outputregistrationcommands.sas";

