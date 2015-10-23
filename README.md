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
$ cd packer/centos
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

## MailWall (Inside mail server)
* 簡易メールサーバを仮想マシン内に構築
* From/Toに関わらずすべて閉じ込めたなかで処理する
* WebメーラーにRainloopを採用

```bash
$ ansible-playbook mailwall.yml
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
  rainloop:
    domain: rainloop.vm
    basedir: /var/www/rainloop.vm
    docroot: /var/www/rainloop.vm
```

#### /etc/hosts Settings on Host
```bash
$ sudo vi /private/etc/hosts
192.168.33.10 dedev.vm rainloop.vm
```

### Access & URL
* http://rainloop.vm/?admin
    * 初期認証: admin / 12345
* http://rainloop.vm/
    * 初期認証: mailwall / mailwall

### 初期設定
* Domainに`Add Domain`して新規ドメイン登録
* IMAP/SMTP共に
    * Serverは`localhost`
    * Secureは`None`
    * `Use short login`にチェック
* Portは
    * IMAP 143
    * SMTP 25
* SMTPの`Use authentication`のチェックを外す

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
### AnsibleでCurlが失敗するとき

```bash
# パブリックDNSにして暫定回避
$ vagrant ssh
$ sudo vi /etc/resolv.conf
nameserver 8.8.8.8
nameserver 8.8.4.4
```

### root@MySQLのパスワード設定

```bash
# Ansibleで設定させるには別途Pythonモジュールが必要なので手動で対応する
$ vagrant ssh
$ mysql -u root mysql
mysql> SET PASSWORD FOR root@localhost=PASSWORD('your_password');
```
