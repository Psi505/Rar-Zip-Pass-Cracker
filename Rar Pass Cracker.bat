@Echo off
@Title WinRar Pass cracker ^| By Psi505 ^(c^) 2020 
@mode 78,15
@Setlocal enabledelayedexpansion

::------------ Interface ------------::
color 1e
echo.
echo   :=-----------------------------------------------------------------------=:
echo.
echo         ___                       _____                    __             
echo        / _ \ ___ _  ___  ___     / ___/  ____ ___ _ ____  / /__ ___   ____
echo       / ___// _ `/ ^(_-^< ^(_-^<    / /__   / __// _ `// __/ /  '_// -_^) / __/
echo      /_/    \_,_/ /___//___/    \___/  /_/   \_,_/ \__/ /_/\_\ \__/ /_/   
echo.
echo.
echo.
echo        Author  : Psi505    ^| Description : This is a simple batch program
echo        Version : 1.1       ^| to help you cracking passwords of Rar/Zip/7z
echo.
echo   :=-----------------------------------------------------------------------=:
pause>nul
::-----------------------------------::

::-------------- prog ---------------::
@Mode 62,9
:: Get names
:Get-ArchiveName
    cls & color 07
    echo Enter the archive name : (eg arch.rar / arch.zip / arch.7z)
    set "arch_name="
    set /p "arch_name=> "
    if not defined arch_name (goto Get-ArchiveName)
    if not exist %arch_name% (
        color c
        echo.
        echo.
        echo.
         echo                   Can't find this archive !
        echo.
        echo.
        pathping 127.0.0.1 -n -q 1 -p 2800 >nul
        goto Get-ArchiveName
    )
    (
        (echo %arch_name% | findstr /c:".rar" 1>nul
        ) || (
            echo %arch_name% | findstr /c:".zip" 1>nul
        ) || (
            echo %arch_name% | findstr /c:".7z" 1>nul)
    ) || (goto Get-ArchiveName)

:Get-WordlistName
    cls & color 7
    echo Enter the wordlist name : (eg wordlist.txt)
    set "wl_name="
    set /p "wl_name=> "
    if not defined wl_name (goto Get-WordlistName)
    if not exist %wl_name% (
        color c
        echo.
        echo.
        echo.
        echo                   Can't find this wordlist !
        echo.
        echo.
        pathping 127.0.0.1 -n -q 1 -p 2800 >nul
        goto Get-WordlistName
    )

:: Prepare for the crack
cls & color b
set "arch_name=%arch_name:"=%"
set "wl_name=%wl_name:"=%"

echo %arch_name% | findstr /c:".rar" 1>nul && set "fol_name=%arch_name:.rar=%"
echo %arch_name% | findstr /c:".zip" 1>nul && set "fol_name=%arch_name:.zip=%"
echo %arch_name% | findstr /c:".7z" 1>nul && set "fol_name=%arch_name:.7z=%"

md "%fol_name%"
set /p p=Press enter key to start cracking...

:: Crack the password
for /f usebackq %%i in ("%wl_name%") do (set /a nb0+=1)
echo %arch_name% | findstr /c:".rar" 1>nul && (
    :: crack rar 
    if not exist unrar.exe (certutil -decode unrar unrar.exe 1>nul)
    for /f "tokens=* usebackq" %%i in ("%wl_name%") do (
        cls
        UnRAR.exe x -inul -P"%%i" "%arch_name%" "%fol_name%" && (set passwd=%%i && goto exitfor)
        set /a nb1+=1
        @title Tested passwords : !nb1! / !nb0! 
    )
) || (
    :: crack zip/7z
    if not exist 7z.exe (certutil -decode 7z 7z.exe 1>nul)
    for /f "tokens=* usebackq" %%i in ("%wl_name%") do (
        cls
        7z x "%arch_name%" -o"%fol_name%" -P"%%i" -y >nul 2>&1 && (set passwd=%%i && goto exitfor)
        set /a nb1+=1
        @title Tested passwords : !nb1! / !nb0! 
    )
)
:exitfor

if not defined passwd (
    rd %fol_name%
    color c
    echo Sorry, we can't find the password using the provided wordlist :/
    echo Please try with another wordlist !
    pathping 127.0.0.1 -n -q 1 -p 5000 >nul
    exit
)

cls & color a
@Title Password successfully cracked !!
echo All files in your archive are extracted in "%fol_name%" folder :^)
echo.
echo.
echo     --^> The password: !passwd!
pause>nul
Exit
::-----------------------------------::