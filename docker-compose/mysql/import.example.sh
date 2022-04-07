# Import Dumps
cat dumps/database.sql | docker exec -i cpn-db /usr/bin/mysql -u you --password=you database