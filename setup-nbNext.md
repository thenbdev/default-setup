# Hardware setup
## Setup machine
- Spin a droplet - min 4GB 2vCPU
<!-- Should we setup DNS here? -->
<!-- - Setup firewall (Need the following ports)
    - 22/tcp (SSH)
    - 80/tcp (HTTP)
    - 443/tcp (HTTPS)

    - 8000/tcp (for testing your platform before deploying to production) `remove this again after everything is done`
    - 3306/tcp (If want to access MariaDB, better change this port)
    
    - 143/tcp (IMAP) `Is this needed?`
    - 25/tcp `Is this needed?` -->

- SSH into the PC



## Software setup
### Create user
- `ssh root@IP`
- sudo useradd -m nbNext && sudo usermod -aG sudo nbNext
- sudo visudo
    - nbNext ALL=(ALL) NOPASSWD: ALL

- sudo passwd nbNext


### Script based installation
- sudo su - nbNext
- wget https://raw.githubusercontent.com/devthenb/default-setup/main/setup_script.sh && chmod +x setup_script.sh
- ./setup_script.sh  `todo: also store the output`





### Install dependencies
<!-- - sudo apt update -->
<!-- - LC_ALL=en_US.UTF-8
LC_CTYPE=en_US.UTF-8
LANG=en_US.UTF-8
- sudo reboot -->
<!-- - sudo apt install mariadb-server # Might not give the latest/required version -->
#### MariaDB 10.6
<!-- - sudo mysql_secure_installation
    - The first prompt will ask you about the root password, but since there is no password configured yet, press ENTER.
    - Next, you will have to decide on using Unix authentication or not. Answer Y to accept this authentication method.
    - When asked about changing the MariaDB root password, answer N. Using the default password along with Unix authentication is the recommended setup for Ubuntu-based systems because the root account is closely related to automated system maintenance tasks.
    - The remaining questions have to do with removing the anonymous database user, restricting the root account to log in remotely on localhost, removing the test database, and reloading privilege tables. It is safe to answer Y to all those questions.
 -->
- Change default charset, remove the already stored value in 50-server.cnf in /etc/mysql/mariadb.conf.d
- sudo mysql
    - CREATE DATABASE nbNext;
    - SHOW DATABASES;
    - GRANT ALL PRIVILEGES ON *.* TO 'nbNext'@'%' IDENTIFIED BY '`password`' WITH GRANT OPTION;
    - SELECT host, user, Super_priv FROM mysql.user; `Will show new user nbNext over %, super_user Y`
    - FLUSH PRIVILEGES;
    - exit

#### test mariaDB for NBNext
- mysql -unbNext -p`password` --host=localhost --protocol=tcp --port=3306



#### Dependencies
<!-- wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1.bionic_amd64.deb -->
<!-- sudo dpkg -i wkhtmltox_0.12.5-1.bionic_amd64.deb -->
- Install wkhtmltopdf `convert HTML content into PDF using the Qt WebKit rendering engine`
    - sudo cp /usr/local/bin/wkhtmlto* /usr/bin/ `copy all relevant executables to your /usr/bin/`
    - sudo chmod a+x /usr/bin/wk*



## Install NBNext
<!-- - cd ~/frappe-bench -->
- bench new-site --admin-password `erpnext_admin_password` --mariadb-root-username nbNext --mariadb-root-password `mariadb_password` `domain`
- bench --site `domain` install-app erpnext
- bench start


### Setup NBNext for production
```
- Fail2ban provides an extra layer of protection against brute force attempts from malicious users and bots.
- Nginx will be mainly used as a web proxy, redirecting all traffic from port 8000 to port 80 (HTTP) or port 443 (HTTPS)
- Supervisor this service ensures that NBNext key processes are constantly up and running, restarting them as necessary.
```
- cd /home/nbNext/frappe-bench
- bench --site `domain` enable-scheduler
- bench --site `domain` set-maintenance-mode off
- sudo bench setup production nbNext --yes
- bench setup nginx

```
The configuration files created by the bench command are:
    - Two Nginx configuration files located at /etc/nginx/nginx.conf and /etc/nginx/conf.d/frappe-bench.conf
    - One Fail2Ban proxy jail located at /etc/fail2ban/jail.d/nginx-proxy.conf and one filter located at /etc/fail2ban/filter.d/nginx-proxy.conf
```
- sudo supervisorctl restart all
- sudo bench setup production nbNext --yes


### Test NBNext 12 Installation
- systemctl list-unit-files | grep 'fail2ban\|nginx\|supervisor'




## Notes and mentions
- https://www.digitalocean.com/community/tutorials/how-to-install-an-erpnext-stack-on-ubuntu-20-04
- https://codewithkarani.com/2022/08/18/install-erpnext-version-14/
