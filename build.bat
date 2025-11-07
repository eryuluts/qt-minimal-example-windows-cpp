@echo off

@REM Configure toolchain
set VCVARS="C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvarsall.bat"
if not defined VCINSTALLDIR (
    call %VCVARS% x64
)

set CXX=cl
set LD=link
set RC=rc

@REM Configure QT
set QT_DIR=.\third_party\qt-6.10.0
set MOC=%QT_DIR%\bin\moc.exe
set UIC=%QT_DIR%\bin\uic.exe
set RCC=%QT_DIR%\bin\rcc.exe
path|find /i "%QT_DIR%\bin" >nul || set path=%QT_DIR%\bin;%path%
set QT_LIBS="%QT_DIR%\lib\Qt6Widgetsd.lib" "%QT_DIR%\lib\Qt6Guid.lib" "%QT_DIR%\lib\Qt6Cored.lib"

@REM BUILD FLAGS
@REM /Zi: Enable creation of separate pdb files.
set CXX_FLAGS=/std:c++20 /EHsc /Zc:__cplusplus /Zi
set DEFINES=/DUNICODE
set INCLUDES=/I%QT_DIR%\include
set LD_FLAGS=/SUBSYSTEM:WINDOWS /INCREMENTAL:NO /DEBUG

@REM Configure output directories
set OUTDIR=build
set OBJDIR=build\obj
if not exist %OUTDIR% mkdir %OUTDIR%
if not exist %OBJDIR% mkdir %OBJDIR%

@REM compile modules
%CXX% %CXX_FLAGS% %DEFINES% %INCLUDES% /Fo%OBJDIR%\ /Fd%OBJDIR%\ ^
    /c src/main.cpp ^
    || exit /b 1

@REM link
%LD% %LD_FLAGS% ^
    /OUT:%OUTDIR%\app.exe ^
    %OBJDIR%\main.obj ^
    %QT_LIBS% ^
    User32.lib Gdi32.lib Shell32.lib Ole32.lib Advapi32.lib Comdlg32.lib Dwmapi.lib Imm32.lib UxTheme.lib Version.lib ^
    || exit /b 1


@echo Built %BINDIR%\app.exe

@REM install


