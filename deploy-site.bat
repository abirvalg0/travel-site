@echo off
chcp 65001 > nul
color 0A
echo ===================================================
echo = АВТОМАТИЧЕСКИЙ ДЕПЛОЙ САЙТА НА GITHUB PAGES =
echo ===================================================
echo.

echo Шаг 1: Проверка системы...
echo.

:: Проверяем наличие Git
where git >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    color 0C
    echo ОШИБКА: Git не установлен!
    echo Пожалуйста, установите Git с https://git-scm.com/download/win
    echo.
    pause
    exit /b 1
)

:: Проверяем, можем ли мы использовать bash напрямую
where bash >nul 2>nul
set USE_BASH=0
if %ERRORLEVEL% EQU 0 (
    set USE_BASH=1
    echo Найден Bash - будем использовать его для деплоя.
) else (
    echo Bash не найден - попробуем использовать Git напрямую.
)

echo.
echo Шаг 2: Создание временной папки...
echo.

:: Создаем временную папку
set "TEMP_FOLDER=%TEMP%\deploy_%RANDOM%"
mkdir "%TEMP_FOLDER%" 2>nul
echo Создана временная папка: %TEMP_FOLDER%

:: Копируем все файлы во временную папку
echo Копирование файлов...
xcopy /E /Y /Q "." "%TEMP_FOLDER%" > nul

:: Переходим во временную папку
cd /d "%TEMP_FOLDER%"

echo.
echo Шаг 3: Настройка Git...
echo.

:: Инициализируем Git репозиторий
git init > nul
if %ERRORLEVEL% NEQ 0 (
    color 0C
    echo ОШИБКА: Не удалось инициализировать Git репозиторий!
    cd /d "%~dp0"
    rmdir /S /Q "%TEMP_FOLDER%" 2>nul
    pause
    exit /b 1
)

:: Создаем ветку gh-pages
git checkout -b gh-pages > nul
if %ERRORLEVEL% NEQ 0 (
    color 0C
    echo ОШИБКА: Не удалось создать ветку gh-pages!
    cd /d "%~dp0"
    rmdir /S /Q "%TEMP_FOLDER%" 2>nul
    pause
    exit /b 1
)

:: Настраиваем пользователя для коммита
git config user.name "GitHub Pages Deployment" > nul
git config user.email "deployment@example.com" > nul

:: Добавляем все файлы
git add . > nul

:: Создаем коммит
git commit -m "Deploy to GitHub Pages - %DATE% %TIME%" > nul
if %ERRORLEVEL% NEQ 0 (
    color 0C
    echo ОШИБКА: Не удалось создать коммит!
    cd /d "%~dp0"
    rmdir /S /Q "%TEMP_FOLDER%" 2>nul
    pause
    exit /b 1
)

echo.
echo Шаг 4: Отправка файлов на GitHub...
echo.

:: Добавляем удаленный репозиторий с токеном доступа
git remote add origin https://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@github.com/abirvalg0/travel-site.git > nul
if %ERRORLEVEL% NEQ 0 (
    color 0C
    echo ОШИБКА: Не удалось добавить удаленный репозиторий!
    cd /d "%~dp0"
    rmdir /S /Q "%TEMP_FOLDER%" 2>nul
    pause
    exit /b 1
)

:: Принудительно пушим в ветку gh-pages
git push -f origin gh-pages
if %ERRORLEVEL% NEQ 0 (
    color 0C
    echo ОШИБКА: Не удалось отправить файлы на GitHub!
    cd /d "%~dp0"
    rmdir /S /Q "%TEMP_FOLDER%" 2>nul
    pause
    exit /b 1
)

echo.
echo Шаг 5: Активация GitHub Pages...
echo.

:: Возвращаемся в исходную папку
cd /d "%~dp0"

:: Удаляем временную папку
rmdir /S /Q "%TEMP_FOLDER%" 2>nul

:: Проверяем наличие curl
where curl >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ВНИМАНИЕ: curl не найден. Пожалуйста, активируйте GitHub Pages вручную:
    echo 1. Перейдите на https://github.com/abirvalg0/travel-site/settings/pages
    echo 2. В разделе "Build and deployment" выберите "Deploy from a branch"
    echo 3. В выпадающем списке выберите "gh-pages" и нажмите "Save"
) else (
    :: Активируем GitHub Pages через GitHub API
    curl -s -X PATCH ^
      -H "Accept: application/vnd.github+json" ^
      -H "Authorization: Bearer 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" ^
      https://api.github.com/repos/abirvalg0/travel-site/pages ^
      -d "{\"source\":{\"branch\":\"gh-pages\",\"path\":\"/\"}}" > nul
    
    if %ERRORLEVEL% NEQ 0 (
        echo ВНИМАНИЕ: Не удалось автоматически активировать GitHub Pages.
        echo Пожалуйста, активируйте вручную:
        echo 1. Перейдите на https://github.com/abirvalg0/travel-site/settings/pages
        echo 2. В разделе "Build and deployment" выберите "Deploy from a branch"
        echo 3. В выпадающем списке выберите "gh-pages" и нажмите "Save"
    ) else (
        echo GitHub Pages успешно активированы!
    )
)

echo.
echo ===================================================
echo = ДЕПЛОЙ УСПЕШНО ЗАВЕРШЕН! =
echo ===================================================
echo.
echo Ваш сайт будет доступен через несколько минут по адресу:
echo https://abirvalg0.github.io/travel-site/
echo.
echo Примечание: при первом деплое активация может занять до 10 минут.
echo При последующих обновлениях - около 1-2 минут.
echo.
pause