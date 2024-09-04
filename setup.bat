@echo off
python -m venv venv
call %~dp0venv\Scripts\activate.bat
pip3 install -r %~dp0requirements.txt
call %~dp0venv\Scripts\deactivate.bat
java -jar %~dp0antlr-4.13.1-complete.jar -Dlanguage=Python3 -o %~dp0src\antlr %~dp0src\simple.g4
