@echo off
REM Enable ANSI escape sequences
set "ESC="

REM Define colors
set "GREEN=%ESC%[32m"
set "RED=%ESC%[31m"
set "YELLOW=%ESC%[33m"
set "RESET=%ESC%[0m"

REM Check if Python is installed
python --version >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo %RED%Python is not installed or not added to PATH.%RESET%
    exit /b 1
)

REM Check if venv folder already exists
if exist venv (
    echo %YELLOW%The 'venv' folder already exists. Proceeding with package installation...%RESET%
) else (
    REM Create a virtual environment
    echo %GREEN%Creating virtual environment...%RESET%
    python -m venv venv
)

REM Activate the virtual environment
echo %GREEN%Activating virtual environment...%RESET%
call venv\Scripts\activate

@REM REM Upgrade pip
@REM echo %GREEN%Upgrading pip...%RESET%
@REM python -m pip install -U pip

REM Install packages
echo %GREEN%Installing required packages...%RESET%
pip install jupyterlab
python -m ipykernel install --user --name venv --display-name "mythai"
pip install matplotlib
pip install pandas
pip install gsutil
pip install ndjson
pip install pillow
pip3 install torch torchvision torchaudio
pip install diffusers["torch"] transformers
pip install -U scikit-learn
pip install -U scikit-image

echo %GREEN%All packages installed successfully.%RESET%
echo %GREEN%Virtual environment setup complete.%RESET%

REM Create folders
if not exist data (
    mkdir data
    echo %GREEN%Data folder was created successfully.%RESET%
    )

REM Download data
echo %GREEN%Downloading cat data...%RESET%
gsutil -m cp "gs://quickdraw_dataset/full/simplified/cat.ndjson" ./data
echo %GREEN%Downloading bus data...%RESET%
gsutil -m cp "gs://quickdraw_dataset/full/simplified/bus.ndjson" ./data
echo %GREEN%Downloading rabbit data...%RESET%
gsutil -m cp "gs://quickdraw_dataset/full/simplified/rabbit.ndjson" ./data
echo %GREEN%Download complete!%RESET%
jupyter-lab
