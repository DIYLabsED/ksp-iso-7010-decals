@echo off
setlocal enabledelayedexpansion

set "inputDir=src-svgs"
set "outputDir=GameData/Flags"
set inkscapePath=C:\Program Files\Inkscape\bin\inkscape.exe

if not exist "%inkscapePath%" (
    echo Inkscape executable not found at specified path. 
    pause
    exit /b
)

if not exist "%inputDir%" (
    echo The folder "%inputDir%" does not exist. 
    pause
    exit /b
)

if not exist "%outputDir%" (
    mkdir "%outputDir%"
)

echo Scanning for SVG files in %inputDir%
set "foundFiles=false"

for /r "%inputDir%" %%F in (*.svg) do (
    echo Found file: %%F
    set "foundFiles=true"
    set "fileName=%%~nF"
    set "tempFile=%outputDir%\%%~nF-temp.png"
    set "outputFile=%outputDir%\%%~nF.png"
    
    REM Use delayed expansion to properly reference tempFile and outputFile
    echo Temporary file path: "!tempFile!"
    
    REM Convert SVG to PNG using Inkscape
    echo Running Inkscape command: "%inkscapePath%" "%%F" --export-width=1024 --export-height=1024 --export-filename="!tempFile!"
    "%inkscapePath%" "%%F" --export-width=1024 --export-height=1024 --export-filename="!tempFile!"
    
    if exist "!tempFile!" (
        echo Temp PNG file created: "!tempFile!"
    ) else (
        echo Temp PNG file not created.
        pause
        exit /b
    )
    
    REM Center image onto 2048x1024 canvas using ImageMagick
    echo Centering image "%%~nF" onto 2048x1024 canvas
    magick "!tempFile!" -gravity center -background none -extent 2048x1024 "!outputFile!"
    
    if exist "!outputFile!" (
        echo Flag created: "!outputFile!"
    ) else (
        echo Unable to create flag
        pause
        exit /b
    )
    
    REM Clean up temporary file
    echo Deleting up temp file: "!tempFile!"...
    del "!tempFile!"
)

if "%foundFiles%"=="false" (
    echo No SVG files found in "%inputDir%".
)

echo Flag processing complete!
pause
