#!/bin/bash
# Скрипт для деплоя сайта на GitHub Pages

# НАСТРОЙКИ - уже настроены под ваш репозиторий
GITHUB_USERNAME="abirvalg0"
REPO_NAME="travel-site"
BRANCH="gh-pages"  
SOURCE_FOLDER="."  # Текущая папка

# Ваш токен доступа
ACCESS_TOKEN="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"

# Цвета для вывода
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Начинаем деплой сайта с виджетом экскурсий на GitHub Pages...${NC}"

# Создаем временную папку для деплоя
TEMP_DIR=$(mktemp -d)
echo -e "Создана временная папка: ${TEMP_DIR}"

# Копируем файлы в временную папку
echo -e "Копирование файлов из ${SOURCE_FOLDER}..."
cp -R $SOURCE_FOLDER/* $TEMP_DIR/ 2>/dev/null || :
# Примечание: игнорируем ошибки, если будут скрытые файлы или другие проблемы

# Переходим во временную папку
cd $TEMP_DIR

# Инициализируем git репозиторий
echo -e "${YELLOW}Инициализация Git репозитория...${NC}"
git init
git checkout -b $BRANCH

# Добавляем все файлы
echo -e "Добавление файлов в репозиторий..."
git add .

# Настраиваем пользователя для коммита
git config user.name "GitHub Pages Deployment"
git config user.email "deployment@example.com"

# Создаем коммит
echo -e "Создание коммита..."
git commit -m "Deploy to GitHub Pages - $(date)"

# Добавляем удаленный репозиторий с токеном доступа
echo -e "${YELLOW}Настройка удаленного репозитория...${NC}"
git remote add origin https://$ACCESS_TOKEN@github.com/$GITHUB_USERNAME/$REPO_NAME.git

# Принудительно пушим в ветку gh-pages
echo -e "${YELLOW}Отправка на GitHub...${NC}"
git push -f origin $BRANCH

# Результат операции
push_result=$?
if [ $push_result -eq 0 ]; then
    echo -e "${GREEN}Деплой успешно завершен!${NC}"
    echo -e "Ваш сайт будет доступен по адресу: https://$GITHUB_USERNAME.github.io/$REPO_NAME/"
    echo -e "Если это первый деплой, может потребоваться до 10 минут для активации GitHub Pages."
    echo -e "Проверьте настройки репозитория: https://github.com/$GITHUB_USERNAME/$REPO_NAME/settings/pages"
else
    echo -e "${RED}Ошибка при отправке в репозиторий. Проверьте имя пользователя, название репозитория и токен.${NC}"
fi

# Удаляем временную папку
echo -e "Удаление временных файлов..."
cd ..
rm -rf $TEMP_DIR

echo -e "${YELLOW}Не забудьте активировать GitHub Pages в настройках репозитория!${NC}"
echo -e "1. Перейдите в раздел Settings -> Pages"
echo -e "2. В разделе Build and deployment -> Source выберите 'Deploy from a branch'"
echo -e "3. В выпадающем списке Branch выберите 'gh-pages' и нажмите Save"