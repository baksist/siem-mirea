# Отчёт по ПР №4. Создание виртуального полигона в среде EVE-NG

Выполнил Сердюков Матвей, ББМО-01-23

## Развёртывание среды EVE-NG

Был скачан образ виртуальной машины EVE-NG Community Edition и импортирован в гипервизор VMWare Workstation:

![](screenshots/01-eve-started.png)

После запуска, была произведена первичная конфигурация: установлены пароль учётной записи `root` и различные сетевые настройки.

![](screenshots/02-password.png)
![](screenshots/03-hostname.png)
![](screenshots/04-dns.png)
![](screenshots/05-dhcp.png)
![](screenshots/06-ntp.png)
![](screenshots/07-proxy.png)

После перезапуска машины, по её IP-адресу открывается веб-клиент, в который можно зайти учётными данными по умолчанию `admin:eve`.

![](screenshots/08-login.png)

После аутентификации открывается домашняя страница, на которой можно приступать к работе.

![](screenshots/09-home.png)

## Создание лаборатории и образов узлов

Создание лаборатории:

![](screenshots/10-new-lab.png)

Загрузка образов ОС Windows 10, Debian GNU/Linux и Cisco IOL (IOS on Linux) на машину EVE-NG:

![](screenshots/11-upload-images.png)

### Создание образа коммутатора Cisco

Сначала необходимо поместить бинарный файл с образом системы в директорию `/opt/unetlab/addons/iol/bin` и запустить скрипт для установки корректных прав доступа к файлам:

![](screenshots/12-put-switch.png)

После этого требуется создать файл лицензии, без которого ВМ не запустится. Это можно сделать с помощью следующего скрипта на Python:

```python
#!/usr/bin/python3

print("*")
print("Cisco IOU License Generator - Kal 2011, python port of 2006 C version")

import os
import socket
import hashlib
import struct

# get the host id and host name to calculate the hostkey
hostid=os.popen("hostid").read().strip()
hostname = socket.gethostname()

ioukey=int(hostid,16)

for x in hostname:
    ioukey = ioukey + ord(x)

print("hostid=" + hostid +", hostname="+ hostname + ", ioukey=" + hex(ioukey)[2:])
#create the license using md5sum

iouPad1 = b'\x4B\x58\x21\x81\x56\x7B\x0D\xF3\x21\x43\x9B\x7E\xAC\x1D\xE6\x8A'
iouPad2 = b'\x80' + 39*b'\0'
md5input=iouPad1 + iouPad2 + struct.pack('!i', ioukey) + iouPad1
iouLicense=hashlib.md5(md5input).hexdigest()[:16]

print("\nAdd the following text to ~/.iourc:")
print("[license]\n" + hostname + " = " + iouLicense + ";\n")

with open("iourc.txt", "wt") as out_file:
    out_file.write("[license]\n" + hostname + " = " + iouLicense + ";\n")

print("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\nAlready copy to the file iourc.txt\n ")
print("You can disable the phone home feature with something like:")
print(" echo '127.0.0.127 xml.cisco.com' >> /etc/hosts\n")

```

После запуска скрипта, в текущей директории появляется файл `iourc.txt`, который нужно поместить в одну директорию с образом системы:

![](screenshots/13-generate-license.png)

И на этом процесс создания образа завершён, можно проверить его работоспособность в лаборатории. Создадим узел:

![](screenshots/14-test-switch.png)

Также подключим два виртуальных ПК для проверки связности (ping)

![](screenshots/15-test-config.png)

После установки IP-адресов компьютеры видят друг друга, коммутатор работает.

![](screenshots/16-works.png)

### Создание образа Windows 10

Для создания виртуальной машины с ОС Windows необходимо сначала создать директорию `/opt/unetlab/addons/qemu/win-10x64-PRO`, поместить туда ISO-образ установщика ОС и переименовать его как `cdrom.iso`. Также требуется создать виртуальный диск в формате `qcow2`, как показано на скриншоте.

![](screenshots/17-start-win.png)

После этого можно создать узел в лаборатории:

![](screenshots/18-node.png)

Также подключим узел к сети на время установки:

![](screenshots/19-net.png)

После старта узла, запускается установщик Windows. Необходимо произвести установку ОС, как это обычно делается на других компьютерах и виртуальных машинах.

> Но есть нюанс: для того, чтобы установщик увидел виртуальный диск, необходимо установить драйвер, который можно найти в директории `B:/storage/2003R2/AMD64`. Это можно сделать средствами установщика на этапе выбора диска.

![](screenshots/20-install.png)

После завершения установки, ВМ перезапускается и нам становится доступна ОС Windows 10:

![](screenshots/21-win-installed.png)

Теперь необходимо сохранить текущее состояния образа с установленной ОС. Сперва узнаем ID лаборатории и узла:

![](screenshots/22-lab-id.png)

![](screenshots/23-node-id.png)

Теперь на сервере с EVE-NG можно перейти в директорию `/opt/unetlab/tmp/0/<LAB_ID>/<NODE_ID>/` и выполнить команду `qemu-img commit`, как показано на скриншоте:

![](screenshots/24-commit-image.png)

Теперь образ со свежеустановленной системой считается базовым, а образ установщика можно удалить из папки образа.

Также осуществим сжатие образа, чтобы он занимал меньше места на диске:

![](screenshots/25-compress.png)

Как можно заметить, сжатый образ занимает почти в 2 раза меньше места:

![](screenshots/26-replace.png)

### Создание образа Debian

Как выяснилось в процессе выполнения работы, для Linux-систем необязательно создавать собственный образ, как это было с Windows, поскольку разработчиками предоставляются заранее подготовленные образы с различными дистрибутивами Linux. Был скачан такой образ с Debian 10, после чего загружен на сервер EVE-NG.

![](screenshots/27-upload-linux.png)

Для установки образа достаточно распаковать содержимое архива в директорию `/opt/unetlab/addons/qemu` и запустить скрипт для установки корректных прав доступа к файлам (аналогично установке образа Cisco IOL):

![](screenshots/28-unpack-linux.png)

Создадим тестовый узел с этим образом и подключим его к сети:

![](screenshots/29-test-node.png)

![](screenshots/30-net.png)

Узел успешно запускается и подключается к сети:

![](screenshots/31-linux-works.png)

## Создание простой сети

### Правки в сетевой конфигурации

Чтобы не подключать все узлы к собственной локальной сети по сетевому мосту, в гипервизоре была создана новая Host-only сеть с поддержкой DHCP:

![](screenshots/32-create-net.png)

Также к виртуальной машине EVE-NG был добавлен сетевой интерфейс, подключенный к этой сети.

![](screenshots/33-add-adapter.png)

Чтобы эта сеть была доступна для узлов лаборатории, также требуется внести небольшие изменения в сетевую конфигурацию (файл `/etc/network/interfaces`)

![](screenshots/34-update-config.png)

После перезапуска сетевой службы, адаптер `pnet1` получает адрес в ранее созданной сети `10.42.69.0/24`:

![](screenshots/35-restart.png)

### Создание сети в лаборатории

Добавим в лабораторию сеть типа `Cloud1` (т.е. подключенные к ней узлы будут использовать адаптер `pnet1`)

![](screenshots/36-my-net.png)

Добавим коммутатор:

![](screenshots/37-add-switch.png)

Создадим два Windows-хоста:

![](screenshots/38-win-hosts.png)

И один хост под управлением Linux:

![](screenshots/39-linux.png)

После соединения всех узлов между собой между собой получается такая сеть:

![](screenshots/40-network.png)

Запустим её:

![](screenshots/41-net-start.png)

Зайдя на каждый ПК можно убедиться, что каждый из них получил IP-адрес по DHCP:

![](screenshots/42-win1.png)

![](screenshots/43-win2.png)

![](screenshots/44-lin.png)

Так как узлы лаборатории находятся в Host-only сети, то можно проверить их доступность напрямую с хостовой системы:

![](screenshots/45-ping.png)

Все узлы отвечают на ICMP-запросы, сеть работает.