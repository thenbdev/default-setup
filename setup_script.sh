# export PASSWORD = 


# todo: Check for sudo permissions to the user before running the script
# ## get UID 
# uid=$(id -u)
 
# ## Check for it
# [ $uid -ne 0 ] && { echo "Only root may enable the nginx-chroot environment to the system."; exit 1; }



# Installation may exceed Ubuntu's default file watch limit of 8192
echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p 


# Setup dependencies
# Python already installed, install pip and upgrade stuff
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt -y install python3-pip
python3 -m pip install --upgrade setuptools cryptography psutil
pip3 install --upgrade setuptools
pip3 install --upgrade pip
pip3 install --upgrade distlib
sudo DEBIAN_FRONTEND=noninteractive apt -y install python3.10-venv

# Yarn
curl -sL https://deb.nodesource.com/setup_16.x | sudo bash -
sudo DEBIAN_FRONTEND=noninteractive apt-get -y install nodejs
sudo npm install -g yarn

# Other dependencies
sudo DEBIAN_FRONTEND=noninteractive apt install -y curl build-essential mariadb-client python3-setuptools python3-dev libffi-dev python3-pip libcurl4 fontconfig git htop libcrypto++-dev libfreetype6-dev liblcms2-dev libwebp-dev libxext6 libxrender1 libxslt1-dev libxslt1.1 libffi-dev ntpdate postfix python3-dev python-tk screen vim xfonts-75dpi xfonts-base zlib1g-dev apt-transport-https libsasl2-dev libldap2-dev libcups2-dev pv libjpeg8-dev libtiff5-dev tcl8.6-dev tk8.6-dev python3-mysqldb libdate-manip-perl logwatch
# libssl dnsmasq

# Setup Supervisor for managing services
sudo DEBIAN_FRONTEND=noninteractive apt-get -y install supervisor

# Setup nginx for webserver management
sudo DEBIAN_FRONTEND=noninteractive apt -y install nginx
sudo systemctl enable nginx

# Setup Redis
sudo DEBIAN_FRONTEND=noninteractive apt -y install redis-server
sudo systemctl enable redis-server


# Create mariaDB 10.6
sudo DEBIAN_FRONTEND=noninteractive apt-get -y install apt-transport-https curl
sudo curl -o /etc/apt/trusted.gpg.d/mariadb_release_signing_key.asc 'https://mariadb.org/mariadb_release_signing_key.asc'
sudo sh -c "echo 'deb https://mirrors.aliyun.com/mariadb/repo/10.6/ubuntu jammy main' >>/etc/apt/sources.list"
sudo DEBIAN_FRONTEND=noninteractive apt -y install mariadb-server
sudo DEBIAN_FRONTEND=noninteractive apt -y install python3-mysqldb libmysqlclient-dev


printf "\n y\n n\n y\n y\n y\n y\n" | sudo mysql_secure_installation


# Setup mariaDB for NBNext
sudo systemctl stop mariadb
sudo wget -O /etc/mysql/conf.d/settings.cnf https://raw.githubusercontent.com/devthenb/default-setup/main/default-settings.cnf
# todo: remove utf8mb4_general_ci from 50-server.cnf
# sudo wget -O /etc/mysql/mariadb.conf.d/nbnext.cnf https://raw.githubusercontent.com/devthenb/default-setup/main/default-nbnext.cnf
sudo systemctl start mariadb
sudo systemctl enable mariadb


# Setup wkhtmltopdf for NBNext
sudo apt-get install xvfb libfontconfig wkhtmltopdf


# Setup Frappe Bench CLI
git clone https://github.com/devthenb/bench ~/.bench --depth 1 --branch develop
sudo pip3 install -e ~/.bench  # Install bench CLI
bench init ~/frappe-bench --frappe-path https://github.com/devthenb/frappe --frappe-branch develop --python python3


# Setup NBNext
cd ~/frappe-bench
chmod -R o+rx ~
bench get-app payments https://github.com/devthenb/payments --branch develop-updated
bench get-app erpnext https://github.com/devthenb/nbnext --branch develop-updated
bench get-app hrms https://github.com/devthenb/hrms --branch develop-updated
