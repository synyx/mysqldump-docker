# mysqldump-docker

## Backup

Deploy examples/k8s/mysqldump.yml to your k8s-cluster 

After a successful backup this container will be `Completed`


## Restore

Deploy examples/k8s/mysql_restore.yml to your k8s-cluster

Exec into that container and do a restore:

`mysql -u $DB_USER  -p$DB_PASS -h $DB_HOST $DB_NAME < /mysqldump/mysqldump.sql`

Exec into that container and do a restore:

`mysql -u $DB_USER  -p$DB_PASS -h $DB_HOST $DB_NAME < /mysqldump/mysqldump.sql`
