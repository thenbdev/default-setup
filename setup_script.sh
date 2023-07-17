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
curl -sL https://deb.nodesource.com/setup_18.x | sudo bash -
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
sudo wget -O /etc/mysql/conf.d/settings.cnf https://raw.githubusercontent.com/thenbdev/default-setup/main/default-settings.cnf
# todo: remove utf8mb4_general_ci from 50-server.cnf
# sudo wget -O /etc/mysql/mariadb.conf.d/nbnext.cnf https://raw.githubusercontent.com/thenbdev/default-setup/main/default-nbnext.cnf
sudo systemctl start mariadb
sudo systemctl enable mariadb


# Setup wkhtmltopdf for NBNext
sudo DEBIAN_FRONTEND=noninteractive apt -y install xvfb libfontconfig wkhtmltopdf

# Download the appropriate package based on Ubuntu version
# if [[ "$(lsb_release -rs)" == "22.04" ]]; then
#   package_url="https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-2/wkhtmltox_0.12.6.1-2.jammy_amd64.deb"
# elif [[ "$(lsb_release -rs)" == "20.04" ]]; then
#   package_url="https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox_0.12.6-1.focal_amd64.deb"
# elif [[ "$(lsb_release -rs)" == "18.04" ]]; then
#   package_url="https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox_0.12.6-1.bionic_amd64.deb"
# else
#   echo "Unsupported Ubuntu version"
# fi


# # Download the package
# wget "$package_url"
# chmod +r wkhtmltox*.deb

# # Install the package and its dependencies
# sudo apt-get update
# sudo apt-get install -y ./wkhtmltox*.deb


# sudo apt install ttf-mscorefonts-installer
# sudo fc-cache -f -v


# Setup Frappe Bench CLI
git clone https://github.com/thenbdev/bench ~/.bench --depth 1 --branch develop-updated
sudo pip3 uninstall frappe-bench -y
sudo pip3 install -e ~/.bench  # Install bench CLI
bench init ~/thenb-bench --frappe-path https://github.com/thenbdev/frappe --frappe-branch develop-updated --python python3


# Setup NBNext
cd ~/thenb-bench
chmod -R o+rx ~
bench get-app payments https://github.com/thenbdev/payments --branch develop-updated
bench get-app erpnext https://github.com/thenbdev/nbnext --branch develop-updated
bench get-app hrms https://github.com/thenbdev/hrms --branch develop-updated
bench get-app freight_management https://github.com/thenbdev/freight_management --branch develop-updated
bench get-app theNB_customization https://github.com/thenbdev/theNB_customization --branch main
