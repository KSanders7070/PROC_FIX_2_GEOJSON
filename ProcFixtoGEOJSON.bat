@echo off
setlocal enabledelayedexpansion

set /A COUNT=0

REM Define the CSV file path
set FILE=FAA_NASR_WAYPOINTS.csv

REM Prompt the user for the FILTER NUMBER VALUE
set /p FILTER_VALUE=Enter The FILTER NUMBER VALUE (1-40): 

REM Prompt the user for the Procedure ID
set /p BCG_VALUE=Enter The BRIGHTNESS CONTROL GROUP VALUE (1-40): 

REM Prompt the user for the Procedure ID
set /p PROCEDURE_ID=Enter The procedure ID: 

(
	ECHO ^{
	ECHO 	"type": "FeatureCollection",
	ECHO 	"features": ^[^{"type":"Feature","geometry":^{"type":"Point","coordinates":^[90.0,180.0^]^},"properties":^{"isTextDefaults":true,"bcg":!BCG_VALUE!,"filters":^[!FILTER_VALUE!^],"size":1,"underline":false,"opaque":false,"xOffset":12,"yOffset":0^}^},
)>!PROCEDURE_ID!_Text.geojson
(
	ECHO ^{
	ECHO 	"type": "FeatureCollection",
	ECHO 	"features": ^[^{"type":"Feature","geometry":^{"type":"Point","coordinates":^[90.0,180.0^]^},"properties":^{"isSymbolDefaults":true,"bcg":!BCG_VALUE!,"filters":^[!FILTER_VALUE!^],"style":"otherWaypoints","size":1^}^},
)>!PROCEDURE_ID!_Symbols.geojson

:FIX_ID_INPUT
REM Prompt the user for the FIX_ID
set /p user_FIX_ID=Enter FIX_ID or type DONE to close out the GEOJSON: 
	set /A COUNT=!COUNT!+1
	if /i "!user_FIX_ID!"=="DONE" goto DONE
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
	if not "!COUNT!"=="1" (
		ECHO 		^},>>!PROCEDURE_ID!_Text.geojson
		ECHO 		^},>>!PROCEDURE_ID!_Symbols.geojson
	)
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
	)>>!PROCEDURE_ID!_Symbols.geojson
)

goto FIX_ID_INPUT

:DONE
(
	ECHO 		^}
	ECHO 	^]
	ECHO ^}
)>>!PROCEDURE_ID!_Text.geojson
(
	ECHO 		^}
	ECHO 	^]
	ECHO ^}
)>>!PROCEDURE_ID!_Symbols.geojson

echo DONE with:
ECHO      !PROCEDURE_ID!_Text.geojson 
ECHO      !PROCEDURE_ID!_Symbols.geojson 
pause

endlocal