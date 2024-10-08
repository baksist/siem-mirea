# Отчёт по ПР №7. Изучение платформ Threat Intelligence

Выполнил Сердюков Матвей, ББМО-01-23

## Платформа для Threat Intelligence, изучение фидов

В качестве платформы используется TrendMicro Vision One, настройка этой платформы описана в отчёте по ПР №6.

Данная платформа имеет множество различных модулей, в том числе и для Threat Intelligence:

![](./screenshots/01-trendmicro-ti.png)

В платформе доступны отчёты из большого количества источников, таких как государственные агентсва по безопасности, исследователи безопасности, команды ИБ организаций, вендоры ИБ-продуктов и т.д.

![](./screenshots/02-feeds.png)

Для некоторых отчётов прилагается ссылка на внешний источник, позволяющая подробно ознакомиться с исследованием, раскрывающим ту или иную угрозу.

![](./screenshots/03-external.png)

Также платформа позволяет осуществлять сканирование (sweeping) на поиск индикаторов реализации угроз, описанных в отчётах. Помимо этого присутствует функция автоматического сканирования раз в день, при использовании которой производится поиск по всем угрозам из указанных источников.

![](./screenshots/04-sweeping.png)

![](./screenshots/05-autosweep.png)

## Моделирование аномальной активности

Для осуществления аномальной активности воспользуемся одним из скриптов, реализующих тактики злоумышленников.

![](./screenshots/06-simulation.png)

![](./screenshots/07-script.png)

После проведения атаки в платформе появляется оповещение с подробной информацией об инциденте. В том числе указываются тактики и техники, использованные злоумышленником, запущенные процессы и использованные файлы, их хеши. Эта информация может быть использована для определения атрибуции по фидам TI, однако в данной демо-атаке её слишком мало, чтобы можно было выявить источник угрозы.

![](./screenshots/08-alert.png)

В более подробном представлении инцидента можно наглядно увидеть, как именно атака разворачивалась в инфраструктуре:

![](./screenshots/09-details.png)

Также в этом компоненте есть возможность осуществить действия над рабочей станцией: изолировать её, запустить удалённую терминальную сессию для анализа, запустить сканирование на вредоносное ПО и др. 

![](./screenshots/10-endpoint.png)

Для файлов, использованных в атаке, тоже можно принять меры: внести его в чёрный список, чтобы не допустить его выполнения или загрузки в дальнейшем, выкачать его с машины для последующего анализа, или отправить его в песочницу для автоматизированного анализа.

![](./screenshots/11-file.png)