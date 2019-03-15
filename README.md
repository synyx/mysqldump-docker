# mysqldump-docker

## DUMP MYSQL in k8s

###Configuration:

Deploy examples/k8s/configmap-database-dump.yml 
be sure to add credentials via secrets and configure your db-access


###Oneshot:
** examples/k8s/mysqldump.yml 

After a successful backup this container will be `Completed`

###Scheduled 

Deploy your version of examples/k8s/scheduled-database-dump.yml


## @TODO@
### Restore / import

