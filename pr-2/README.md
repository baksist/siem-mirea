# Отчёт по ПР №2. Развёртывание и работа с IDS Suricata

Выполнил Сердюков Матвей, ББМО-01-23

## Подготовка к запуску IDS Suricata

На рабочей машине уже установлены `Docker` и `Docker Compose`:

![](screenshots/01-docker.png)

Установка Docker-образа Suricata:

![](screenshots/02-pull.png)

Создание Compose-файла для упрощённого запуска IDS:

![](screenshots/03-compose.png)

## Первый запуск

Успешный запуск Suricata:

![](screenshots/04-start.png)

Обновление правил:

![](screenshots/05-update-rules.png)

## Написание собственного правила и обнаружение вторжений

Установка переменной `HOME_NET` в конфигурации Suricata:

![](screenshots/07-homenet.png)

Указание пути к файлу с собственным правилом для Suricata в конфигурации: 

![](screenshots/06-customrules.png)

Собственное правило, срабатывающие при совершении HTTP-запроса к серверу с юзер-агентом `mserdyukov`:

![](screenshots/08-custom-rule.png)

Запуск HTTP-сервера:

![](screenshots/09-server.png)

Запрос с соответствующим UA:

![](screenshots/10-request.png)

Срабатывание правила в логах:

![](screenshots/11-alert.png)

Запуск сканирования инструментом `nmap`:

![](screenshots/12-nmap.png)

Релевантные срабатывания правил в логах:

![](screenshots/13-nmap-alerts.png)