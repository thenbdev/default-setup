bench new-site --admin-password `erpnext_admin_password` --mariadb-root-username nbNext --mariadb-root-password `mariadb_password` `subdomain`
bench --site `subdomain` install-app payments
bench --site `subdomain` install-app erpnext
bench --site `subdomain` install-app hrms

bench --site `subdomain` migrate

bench --site `subdomain` enable-scheduler
bench --site `subdomain` scheduler enable
bench --site `subdomain` set-maintenance-mode off

`Now you can set shared keys like encrypytion keys (Not recommended) or restore any previous DB.`


sudo supervisorctl restart all
