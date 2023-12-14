
bench --site freight clear-website-cache
bench --site demo uninstall-app thenb_customization -y && bench --site demo install-app thenb_customization && bench --site demo clear-website-cache
bench --site freight uninstall-app freight_management -y && bench --site freight install-app freight_management && bench --site freight clear-website-cache
bench start



bench --site localhost uninstall-app freight_management -y && bench --site localhost install-app freight_management && bench start


bench --site freight --force restore freight/private/backups/20230425_144518-freight-database.sql.gz  --mariadb-root-username nbNext --mariadb-root-password `mariadb_password` 


cd .. && ./gitPull.sh && cd frappe-bench && bench --site freight uninstall-app freight_management -y && bench --site freight install-app freight_management && exit
