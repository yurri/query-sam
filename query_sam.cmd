@echo off

set LOGPARSER=%PROGRAMFILES%\Log Parser 2.2\LogParser.exe

rem A quick script allowing to run SQL queries over SAM files
rem SAM format as treated as a tabbed log with parser
rem 
rem Yuriy Akopov (akopov@hotmail.co.uk)

set SAMFILE=%1
if not defined SAMFILE goto :ParameterMissing

set QUERY=%2
if not defined QUERY goto :ParameterMissing

rem let's find out how many header lines should skip to get to the tabbed content
set SKIPLINES=0

rem finding a number of header lines to skip
rem reading file line by line until the header ends
setlocal EnableDelayedExpansion	
set HEADER=^"@.*"$
for /F "usebackq delims=" %%a in (`"findstr /r ^^ %SAMFILE%"`) do (
    set LINE=%%a
	
	echo("!LINE!"|findstr /r /c:"!HEADER!" >nul && (
		rem line read from line matches header line regexp
		set /a "SKIPLINES+=1"
	) || (
		goto :ContentFound
	)
)

:ContentFound
rem capturing own path
set SELFPATH=%~dp0

rem running LogParser
"%LOGPARSER%" -i:TSV -nSkipLines:%SKIPLINES% -headerRow:OFF -iHeaderFile:"%SELFPATH:~0,-1%\sam_headers.txt" %QUERY%
exit /B

:ParameterMissing
echo Parameter missing, unable to proceed.
echo. && echo Usage: query_sam.cmd [filename] [query]
echo     [filename] Path to SAM file
echo     [query] SQL query supported by Microsoft Log Parser, quoted
echo             Use %SAMFILE% in FROM clause to query the file specified in the first parameter
echo             In LIKE masks use double percent character e.g. WHERE QNAME LIKE 'EAS%%' 
echo. && echo Example: query_sam.cmd ex1.sam "SELECT QNAME, SEQ FROM %SAMFILE% WHERE SEQ LIKE '%%GAGGGGTGCAG%%'"
