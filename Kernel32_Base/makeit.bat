@echo off

    if exist "Kernel32Base.obj" del "Kernel32Base.obj"
    if exist "Kernel32Base.exe" del "Kernel32Base.exe"

    \masm32\bin\ml /c /coff "Kernel32Base.asm"
    if errorlevel 1 goto errasm

    \masm32\bin\PoLink /SUBSYSTEM:CONSOLE "Kernel32Base.obj"
    if errorlevel 1 goto errlink
    dir "Kernel32Base.*"
    goto TheEnd

  :errlink
    echo _
    echo Link error
    goto TheEnd

  :errasm
    echo _
    echo Assembly Error
    goto TheEnd
    
  :TheEnd

pause
