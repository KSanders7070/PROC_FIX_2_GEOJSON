@echo off
setlocal enabledelayedexpansion

REM Prompt the user for the Procedure ID
set /p PROCEDURE_ID=Enter The procedure ID: 

(
ECHO ^{
ECHO 	"type": "FeatureCollection",
ECHO 	"features": ^[
)>!PROCEDURE_ID!_Text.geojson
(
ECHO ^{
ECHO 	"type": "FeatureCollection",
ECHO 	"features": ^[
)>!PROCEDURE_ID!_Symbols.geojson

:FIX_ID_INPUT
REM Prompt the user for the FIX_ID
set /p user_FIX_ID=Enter FIX_ID or type DONE to close out the GEOJSON: 
	if /i "!user_FIX_ID!"=="DONE" goto DONE

REM Define the CSV file path
set FILE=FAA_NASR_WAYPOINTS.csv

REM Initialize variables to store coordinates
set LAT_DECIMAL=
set LONG_DECIMAL=

REM Read the file and find the matching FIX_ID
for /f "tokens=1,2,3 delims=," %%a in ('findstr /r "^%user_FIX_ID%," "%FILE%"') do (
    set FIX_ID=%%a
	set LAT_DECIMAL=%%b
    set LONG_DECIMAL=%%c
)

REM Check if coordinates were found
if "%LAT_DECIMAL%"=="" (
    echo user_FIX_ID %user_FIX_ID% not found.
) else (
	REM echo %FIX_ID% %LAT_DECIMAL% %LONG_DECIMAL%
	(
		ECHO 		^{
		ECHO 			"type": "Feature",
		ECHO 			"geometry": ^{
		ECHO 				"type": "Point",
		ECHO 				"coordinates": ^[
		ECHO 					!LONG_DECIMAL!,
		ECHO 					!LAT_DECIMAL!
		ECHO 				^]
		ECHO 			^},
		ECHO 			"properties": ^{
		ECHO 				"text": ^[
		ECHO 					"!FIX_ID!"
		ECHO 				^]
		ECHO 			^}
		ECHO 		^},
	)>>!PROCEDURE_ID!_Text.geojson
	REM echo %FIX_ID% %LAT_DECIMAL% %LONG_DECIMAL%
	(
		ECHO 		^{
		ECHO 			"type": "Feature",
		ECHO 			"geometry": ^{
		ECHO 				"type": "Point",
		ECHO 				"coordinates": ^[
		ECHO 					!LONG_DECIMAL!,
		ECHO 					!LAT_DECIMAL!
		ECHO 				^]
		ECHO 			^},
		ECHO 			"properties": ^{
		ECHO 				"style": "otherWaypoints",
		ECHO 				"waypoint_id": "!FIX_ID!"
		ECHO 			^}
		ECHO 		^},
	)>>!PROCEDURE_ID!_Symbols.geojson
)

goto FIX_ID_INPUT

:DONE
(
ECHO REMOVE THE COMMA IN THE LINE ABOVE THIS ONE
ECHO 	^]
ECHO ^}
)>>!PROCEDURE_ID!_Text.geojson
(
ECHO REMOVE THE COMMA IN THE LINE ABOVE THIS ONE
ECHO 	^]
ECHO ^}
)>>!PROCEDURE_ID!_Symbols.geojson

echo DONE with:
ECHO      !PROCEDURE_ID!_Text.geojson 
ECHO      !PROCEDURE_ID!_Symbols.geojson 
pause

endlocal