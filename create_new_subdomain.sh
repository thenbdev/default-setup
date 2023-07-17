cd frappe-bench
bench drop-site $1 --mariadb-root-username nbNext --mariadb-root-password $2
bench new-site --admin-password 3125 --mariadb-root-username nbNext --mariadb-root-password $2 $1
bench --site $1 install-app payments
bench --site $1 install-app erpnext
bench --site $1 migrate

bench --site $1 enable-scheduler
bench --site $1 scheduler enable
bench --site $1 set-maintenance-mode off


# Take DB backup from site config
## Take DB name from site_config.json
freshDbName=$(cat sites/fresh/site_config.json | grep db_name | awk -F'"' '{print $4}')
echo "Fresh DB Backup is $freshDbName"

# Take DB backup
mysqldump -u nbNext -p"$2" "$freshDbName" > "fresh_backup_for_$1.sql"

# Restore the database
db_name=$(cat "sites/$1/site_config.json" | grep db_name | awk -F'"' '{print $4}')
echo "DB Name is $db_name"
mysql -u nbNext -p"$2" "$db_name" < "fresh_backup_for_$1.sql"
