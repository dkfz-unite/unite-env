#!/bin/bash

usr=root
pwd=$(jq -r .sql.password ../../secrets.json)
dbr=113_37
cor_dbn=homo_sapiens_core_$dbr
cor_dir=/home/mysql/cache/core37
# fun_dbn=homo_sapiens_funcgen_$dbr
# fun_dir=/home/mysql/cache/func37

tput setaf 4; echo "# Creating Ensembl core database"; tput sgr0
docker exec -i mysql mysql -u$usr -p$pwd -e "create database $cor_dbn;"
echo ""

tput setaf 4; echo "# Restoring Ensembl core database schema"; tput sgr0
docker exec -i mysql /bin/bash -c "mysql -u$usr -p$pwd $cor_dbn < $cor_dir/$cor_dbn.sql"
echo ""

tput setaf 4; echo "# Restoring Ensembl core database data"; tput sgr0
docker exec -i mysql /bin/bash -c "mysqlimport -u$usr -p$pwd --fields-terminated-by='\t' --fields-escaped-by='\\' $cor_dbn -L $cor_dir/*.txt"
echo ""

# tput setaf 4; echo "# Creating Ensembl functional genome database"; tput sgr0
# docker exec -i mysql mysql -u$usr -p$pwd -e "create database $fun_dbn;"
# echo ""

# tput setaf 4; echo "# Restoring Ensembl functional genome database schema"; tput sgr0
# docker exec -i mysql /bin/bash -c "mysql -u$usr -p$pwd $fun_dbn < $fun_dir/$fun_dbn.sql"
# echo ""

# tput setaf 4; echo "# Restoring Ensembl functional genome database data"; tput sgr0
# docker exec -i mysql /bin/bash -c "mysqlimport -u$usr -p$pwd --fields-terminated-by='\t' --fields-escaped-by='\\' $fun_dbn -L $fun_dir/*.txt"
# echo ""
