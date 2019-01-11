# SAS2PDF

SAS2PDF is a package of SAS macros that enables immediate pdf creation via a Latex intermediate directly from the SAS-Editor at the time of SAS code execution. PDF creation does not interfer with SAS code execution and SAS code outputs can be selectively added to the PDF. SAS outputs that are currently supported for PDF inclusion are tables, images, code snippets. 

SAS2PDF was created at IMBI Heidelberg, Germany and builds on work by Perttola, J ("SAS and Latex - a Perfect Match?") and syntax highlighting by mcaceresb (see [References](#references)).

## Table of Contents
* [Installation](#installation)
* [Basic Use](#basic-use)
* [Advanced Use](#advanced-use)
* [FAQ](#faq)
* [References](#references)

## Installation

*First*, before beginning with the SAS2PDF installation, ensure that the following software is installed:
* Up-to-date installation of MikTex or similar Tex distribution.
* SAS 9.4 or newer.

*Second*, to install SAS2PDF either clone the directory to your preferred location

```
git clone https://github.com/jacobmatthewmurray/SAS2PDF.git
```

or download the .zip file of the directory (green 'Clone or download' button) and unzip the directroy to your preferred location.

*Third*, the S2P system variable must be set for your windows user. The S2P system variable lets SAS know where the necessary macro files for the S2P module are saved.  To load the S2P module, a call to `%include %sysget(S2P);`  is required at the beginning of the relevant file. This call loads the file `/lib/collector.sas`, which in turn loads all the required macros for the S2P module. 

The S2P system variable can be loaded in one of two ways. 

1. The preferred way is to set the path to `\lib\collector.sas` in the `autoexec.sas` that is loaded at SAS program start-up by adding the following line to `autoexec.sas`:

```
x 'setx S2P ''\your\path\to\sas2pdf\lib\collector.sas''';
```
Note: If the S2P system variable is set via `autoexec.sas` for the first time, it might be necessary to re-start SAS once, so that the S2P variable is properly registered. 

2. If `autoexec.sas`  does not work or is not defined, the S2P system variable may be initialized by running `regenv.bat`, which is included in the top level folder of the SAS2PDF module. 

## Basic Use

A basic .sas editor file that includes SAS2PDF functionality takes the form of the following basic example:

```sas
%INCLUDE %sysget(S2P);

%s2p_standard_preprocessing(project=Test);

%s2p_section('TestSection');

%s2p_text('Lorem ipsum dolor sit amet, consetetur sadipscing elitr.');

%s2p_preoutreg(procmeansclass);
	proc corr data=sashelp.class  plots=matrix(histogram);
	var height weight; 
	run; 
%s2p_postoutreg(procmeansclass);

%s2p_includeoutput(procmeansclass, 2, 'My first SAS Table');
%%s2p_text('Lorem ipsum dolor sit amet.');
%s2p_includeoutput(procmeansclass, 4, 'My first SAS Image');

%s2p_includeoutput(procmeansclass, 0, 'My first SAS Code');


%s2p_standard_postprocessing;
```

1. `%include %sysget(S2P);` enables the .sas file to use the SAS2PDF package.
2. `%s2p_standard_preprocessing();` and `%s2p_standard_postprocessing;` wrap the entire .sas file. They must be the first and last macro call respectively. `%s2p_standard_preprocessing();` takes the following arguments:
   * project (Default=DefaultProjectName): This will be the name of the final .pdf file.
   * title (Default=DefaultTitle): This will be the title of the final .pdf file.
   * header_icon (Default=None): This icon will appear in the top right-hand corner of the header starting on page 2. Provide the argument as header_icon=/path/to/icon.png.
   * author (Default=DefaultAuthor): This will be the author of the .pdf.
   * titlepage (Default=None): This title page will be added if /path/to/title is provided. 
   * outdir (Default=None): If outdir is not set as /path/to/outdir then an output folder is created in the directory of the exectued .sas file. 
3. `%s2p_text();`, `%s2p_section();`, and similar tags provide for a way for inserting text as well as for basic wrapping of standard Latex commands. All text inserted via `%s2p_text();` should be wrapped in single quotations. Macro variables should be placed outside of quotations. 
4. `%s2p_preoutreg(procmeansclass);` and `%s2p_postoutreg(procmeansclass);` are used to wrap a SAS statement that should be registered with the SAS2PDF module and whose output should be available for subsequent inclusion in the PDF. Each SAS statement that is registered with SAS2PDF in this way should be given a unique identifier, which is passed as a parameter, in this example `procmeansclass`.  
5. `%s2p_includeoutput(procmeansclass, 0, 'My first SAS Code');` includes previously registered output in the final PDF. It takes three arguments. 
   1. The first argument (in this example `procmeansclass`) defines from which SAS statement output should be included.
   2. The second argument (in this example `0`) defines which component of the output of the registered SAS statement should be included. For instance, in the SAS Results Viewer the outputs of the above program are listed as 'Variable Information', 'Simple Statistics', 'Pearson Correlation', and 'Scatter Plot Matrix'. To include one of these output tables or graphs, replace the second argument by 1,2,3, or 4 respectively. The number 0, as shown in this example is a special number and refers to inclusion of the SAS code.
   3. The third argument (in this example `My first SAS Code`) gives the caption that is to be included with the output. 
  
## Advanced Use
## FAQ
Q. Why am I not seeing any output for my S2P script? 

A. 1. Check that the file you are running has been saved. Only saved files can access their relative location and generate the necessary directory structures that will contain the SAS and TEX back-up files. 


## References
* Perttola, J. (F. Hoffmann-La Roche AG, Basel, Switzerland): "SAS and Latex - a Perfect Match?", PhUSE 2008, Paper TS06
* listing-sas.tex at github.com/mcaceresb (for SAS code highlighting in Tex)
