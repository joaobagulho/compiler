@echo off
call %~dp0venv\Scripts\activate.bat
python %~dp0src\main.py %*
call %~dp0venv\Scripts\deactivate.bat
