# dedev for CentOS

Vagrant + Ansibleによる個人開発環境セット。CentOS版

---

## 実施環境
* OSX El Capitan Version 10.11

## 必要ソフトウェア
* VirtualBox 5.0.8
* Vagrant 1.7.4
* Ansible 1.9.2
* Packer 0.8.6

# ソフトウェアをインストールする
## 1. VirtualBoxをインストール

* https://www.virtualbox.org/

## 2. Vagrantをインストール

* https://www.vagrantup.com/

### 2.1 Vagrantプラグインをインストール

```bash
$ vagrant plugin install vagrant-vbguest
$ vagrant plugin install dotenv
```

## 3. Ansibleをインストール

```bash
$ pip install ansible
```

## 4. Packerをインストール

```bash
$ brew install packer
```

# イメージファイルを用意する
## 1. Packerでboxファイルを生成する

下記を実行すると、`packer/box`以下にboxファイルが生成される。
`packer/iso`にisoファイルを配置し、packerのテンプレート内の`iso_path`にpathを記載するとダウンロードを省略可能。

```bash
$ cd packer
$ packer build centos65.json # CentOS 6.5
$ packer build centos67.json # CentOS 6.7
```

# Vagrantを起動する
## 1. 初期設定

```bash
$ cp .env.example .env
$ vi .env
# Vagrant
DEFAULT_BOX             = 'packer/box/centos67-0.1.0.box'
DEFAULT_PRIVATE_IP      = '192.168.33.10'
DEFAULT_PRIVATE_INTNET  = 'intnet'
#DEFAULT_PUBLIC_BRIDGE   = 'en0: Wi-Fi (AirPort)'
DEFAULT_PUBLIC_BRIDGE   = 'en0: Ethernet'
DEFAULT_PUBLIC_IP       = '192.168.0.1'
DEFAULT_PUBLIC_NETMASK  = '255.255.0.0'
DEFAULT_SYNCED_DISABLED = false
DEFAULT_SYNCED_HOST     = '.'
DEFAULT_SYNCED_GUEST    = '/vagrant'
DEFAULT_SYNCED_OWNER    = 'vagrant'
DEFAULT_SYNCED_GROUP    = 'apache'
DEFAULT_SYNCED_OPTIONS  = 'dmode=775,fmode=664'
```

## 2. 起動

```bash
$ vagrant up
$ vagrant ssh-config >> $HOME/.ssh/config
```

# Ansibleで構築
## 実行場所へ移動

```bash
$ cd ansible
```

---

## Hubot
```bash
$ ansible-playbook hubot.yml
```

### Hubot生成
```bash
$ mkdir dedevbot
$ cd dedevbot
$ yo hubot
```

### Access & URL
* なし

---

## LAMP
```bash
$ ansible-playbook lamp.yml
```

### VirtualHost
#### Apache Settings on Guest
```bash
$ vi dedev.yml
---
vhosts:
  dedev:
    domain: dedev.vm
    basedir: /var/www/html
    docroot: /var/www/html
```
* domain: バーチャルドメイン名
* basedir: アプリケーションのソースコード置き場
* docroot: DocumentRoot
    * basedirからdocrootへシンボリックリンクが必要な場合は手動で

#### /etc/hosts Settings on Host
```bash
$ sudo vi /private/etc/hosts
192.168.33.10 dedev.vm
```

### Access & URL

* http://192.168.33.10/
* http://dedev.vm/
* http://dedev.vm/phpinfo.php
* http://dedev.vm/phpmyadmin
    * root@MySQLのパスワード設定を先に行うこと

---

## WebMail
* Postfix/Dovecotで簡易メールサーバを構築
* RainloopでWebメーラー構築
* SMTPがlocalhost:25を指す場合は外部へ送信しない、Webメーラーで受信確認

### Usage
```bash
# バーチャルホスト定義に追加
$ vi dedev.yml
---
vhosts:
  dedev:
    domain: dedev.vm
    basedir: /var/www/html
    docroot: /var/www/html
  rainloop:
    domain: rainloop.dedev.vm
    basedir: /var/www/rainloop.dedev.vm
    docroot: /var/www/rainloop.dedev.vm

# Ansible実行
$ ansible-playbook webmail.yml

# /etc/hostsに追記
$ sudo vi /private/etc/hosts
192.168.33.10 dedev.vm rainloop.dedev.vm
```

### Access & URL
* http://rainloop.dedev.vm/?admin
    * 初期認証: admin / 12345
* http://rainloop.dedev.vm/
    * 初期認証: vagrant / vagrant

### 初期設定
* Domainに`Add Domain`して新規ドメイン登録
* Nameは`localhost`
* IMAP
    * Server: `localhost`
    * Port:   143
    * Secure: `None`
    * `Use short login`にチェック
* SMTP
    * Server: `localhost`
    * Port:   25
    * Secure: `None`
    * `Use short login`にチェック
    * `Use authentication`のチェックを外す　または　`Use php mail() function (beta)`にチェック

---

## Jenkins
```bash
$ ansible-playbook jenkins.yml
```

### Access & URL
* http://192.168.33.10:8080

---

## [WIP] Elasticsearch + Logstash + Kibana
```bash
$ ansible-playbook elk.yml
```

### Access & URL
* なし

---
## Note&Tips
### root@MySQLのパスワード設定

```bash
# Ansibleで設定させるには別途Pythonモジュールが必要なので手動で対応する
$ vagrant ssh
$ mysql -u root mysql
mysql> SET PASSWORD FOR root@localhost=PASSWORD('your_password');
```
