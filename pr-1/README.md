# Отчёт по ПР №1. Развёртывание и работа с IDS Snort

## Подготовка к запуску IDS Snort

На рабочей машине уже установлены `Docker` и `Docker Compose`:

![](screenshots/01-docker.png)

Клонирование репозитория с IDS Snort:

![](screenshots/02-clone-repo.png)

Редактирование файла `docker-compose.yml`:

![](screenshots/03-compose.png)

Редактирование инициализационного скрипта `bootloader.sh`:

![](screenshots/04-bootloader.png)

## Запуск Snort в режиме сниффера пакетов

Редактирование конфигурации `supervisord` для запуска Snort в режиме сниффера:

![](screenshots/05-supervisor.png)

Запуск Snort в режиме сниффера:

![](screenshots/06-sniffer.png)

## Запуск Snort в режиме обнаружения вторжений

Перезапись файла `snort.rules` в инициализационном скрипте для установки единственного правила, обнаруживающего вход по SSH не неизвестного IP-адреса (в данном случае домашнего):

![](screenshots/07-custom-rule.png)

Вход по SSH с другого IP:

![](screenshots/08-login.jpg)

Оповещения о срабатывании правила в консоли :

![](screenshots/09-alerts.png)