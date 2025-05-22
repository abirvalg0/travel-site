@echo off
chcp 65001 > nul
color 0A
echo ===================================================
echo = �������������� ������ ����� �� GITHUB PAGES =
echo ===================================================
echo.

echo ��� 1: �������� �������...
echo.

:: ��������� ������� Git
where git >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    color 0C
    echo ������: Git �� ����������!
    echo ����������, ���������� Git � https://git-scm.com/download/win
    echo.
    pause
    exit /b 1
)

:: ���������, ����� �� �� ������������ bash ��������
where bash >nul 2>nul
set USE_BASH=0
if %ERRORLEVEL% EQU 0 (
    set USE_BASH=1
    echo ������ Bash - ����� ������������ ��� ��� ������.
) else (
    echo Bash �� ������ - ��������� ������������ Git ��������.
)

echo.
echo ��� 2: �������� ��������� �����...
echo.

:: ������� ��������� �����
set "TEMP_FOLDER=%TEMP%\deploy_%RANDOM%"
mkdir "%TEMP_FOLDER%" 2>nul
echo ������� ��������� �����: %TEMP_FOLDER%

:: �������� ��� ����� �� ��������� �����
echo ����������� ������...
xcopy /E /Y /Q "." "%TEMP_FOLDER%" > nul

:: ��������� �� ��������� �����
cd /d "%TEMP_FOLDER%"

echo.
echo ��� 3: ��������� Git...
echo.

:: �������������� Git �����������
git init > nul
if %ERRORLEVEL% NEQ 0 (
    color 0C
    echo ������: �� ������� ���������������� Git �����������!
    cd /d "%~dp0"
    rmdir /S /Q "%TEMP_FOLDER%" 2>nul
    pause
    exit /b 1
)

:: ������� ����� gh-pages
git checkout -b gh-pages > nul
if %ERRORLEVEL% NEQ 0 (
    color 0C
    echo ������: �� ������� ������� ����� gh-pages!
    cd /d "%~dp0"
    rmdir /S /Q "%TEMP_FOLDER%" 2>nul
    pause
    exit /b 1
)

:: ����������� ������������ ��� �������
git config user.name "GitHub Pages Deployment" > nul
git config user.email "deployment@example.com" > nul

:: ��������� ��� �����
git add . > nul

:: ������� ������
git commit -m "Deploy to GitHub Pages - %DATE% %TIME%" > nul
if %ERRORLEVEL% NEQ 0 (
    color 0C
    echo ������: �� ������� ������� ������!
    cd /d "%~dp0"
    rmdir /S /Q "%TEMP_FOLDER%" 2>nul
    pause
    exit /b 1
)

echo.
echo ��� 4: �������� ������ �� GitHub...
echo.

:: ��������� ��������� ����������� � ������� �������
git remote add origin https://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@github.com/abirvalg0/travel-site.git > nul
if %ERRORLEVEL% NEQ 0 (
    color 0C
    echo ������: �� ������� �������� ��������� �����������!
    cd /d "%~dp0"
    rmdir /S /Q "%TEMP_FOLDER%" 2>nul
    pause
    exit /b 1
)

:: ������������� ����� � ����� gh-pages
git push -f origin gh-pages
if %ERRORLEVEL% NEQ 0 (
    color 0C
    echo ������: �� ������� ��������� ����� �� GitHub!
    cd /d "%~dp0"
    rmdir /S /Q "%TEMP_FOLDER%" 2>nul
    pause
    exit /b 1
)

echo.
echo ��� 5: ��������� GitHub Pages...
echo.

:: ������������ � �������� �����
cd /d "%~dp0"

:: ������� ��������� �����
rmdir /S /Q "%TEMP_FOLDER%" 2>nul

:: ��������� ������� curl
where curl >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ��������: curl �� ������. ����������, ����������� GitHub Pages �������:
    echo 1. ��������� �� https://github.com/abirvalg0/travel-site/settings/pages
    echo 2. � ������� "Build and deployment" �������� "Deploy from a branch"
    echo 3. � ���������� ������ �������� "gh-pages" � ������� "Save"
) else (
    :: ���������� GitHub Pages ����� GitHub API
    curl -s -X PATCH ^
      -H "Accept: application/vnd.github+json" ^
      -H "Authorization: Bearer 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" ^
      https://api.github.com/repos/abirvalg0/travel-site/pages ^
      -d "{\"source\":{\"branch\":\"gh-pages\",\"path\":\"/\"}}" > nul
    
    if %ERRORLEVEL% NEQ 0 (
        echo ��������: �� ������� ������������� ������������ GitHub Pages.
        echo ����������, ����������� �������:
        echo 1. ��������� �� https://github.com/abirvalg0/travel-site/settings/pages
        echo 2. � ������� "Build and deployment" �������� "Deploy from a branch"
        echo 3. � ���������� ������ �������� "gh-pages" � ������� "Save"
    ) else (
        echo GitHub Pages ������� ������������!
    )
)

echo.
echo ===================================================
echo = ������ ������� ��������! =
echo ===================================================
echo.
echo ��� ���� ����� �������� ����� ��������� ����� �� ������:
echo https://abirvalg0.github.io/travel-site/
echo.
echo ����������: ��� ������ ������ ��������� ����� ������ �� 10 �����.
echo ��� ����������� ����������� - ����� 1-2 �����.
echo.
pause