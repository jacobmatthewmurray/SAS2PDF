@ECHO OFF

REM SAS2TexPDF Project Initializer

SET name=
SET path=.
SET type=blank

:loop
IF NOT "%1"=="" (
    IF "%1"=="-name" (
        SET name=%2
        SHIFT
    )
    IF "%1"=="-path" (
		SET path=%2
        SHIFT
    )
	IF "%1"=="-type" (
		SET type=%2
		SHIFT
    )
    SHIFT
    GOTO loop
) 

REM At least name of project must be provided.
REM If no path is provided, project will be started in S2T Folder.

IF [%name%]==[] (
	ECHO A project name is required to initialize project. If no path was given, project will be initialized in current folder.
	SET /P name=Enter project name, leave blank and press enter to cancel:
)

REM Quit bat script, if no project name is provided.

IF [%name%]==[] (
		GOTO :EOF
)

REM Generate new reporting project. 

MKDIR %path%\%name%
MKDIR %path%\%name%\code\include
MKDIR %path%\%name%\report\backup
MKDIR %path%\%name%\data\media
copy .\t.sas %path%\%name%\code\include 





