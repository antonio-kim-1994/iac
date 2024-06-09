#!/bin/bash

# 설정 변수
DB_USER="root"
DB_PASSWORD="rootpasswd"

# autocommit을 끄는 SQL 명령어
SET_AUTOCOMMIT_OFF="SET autocommit=0;"

# 변경 사항을 커밋하는 명령어
COMMIT="COMMIT;"

# autocommit을 원래대로 복원하는 명령어
SET_AUTOCOMMIT_ON="SET autocommit=1;"

# MySQL 명령어를 실행하는 함수
execute_mysql() {
    local sql="$1"
    mysql -u ${DB_USER} -p${DB_PASSWORD} -e "${sql}"
}

# autocommit 끄기
execute_mysql "${SET_AUTOCOMMIT_OFF}"

# 덤프 파일 복원하기
echo "File : /dump/dump-engine-240522.sql"
mysql -u ${DB_USER} -p${DB_PASSWORD} < /dump/dump-engine-240522.sql

echo "File : /dump/dump-240522.sql"
mysql -u ${DB_USER} -p${DB_PASSWORD} < /dump/dump-aijinet-240522.sql

echo "File : /dump/dump-api_debug-240522.sql"
mysql -u ${DB_USER} -p${DB_PASSWORD} < /dump/dump-api_debug-240522.sql

echo "File : /dump/dump-mediage-240522.sql"
mysql -u ${DB_USER} -p${DB_PASSWORD} < /dump/dump-mediage-240522.sql

echo "File : /dump/dump-mydata-240522.sql"
mysql -u ${DB_USER} -p${DB_PASSWORD} < /dump/dump-mydata-240522.sql
~
echo "File : /dump/dump-mzs-240522.sql"
mysql -u ${DB_USER} -p${DB_PASSWORD} < /dump/dump-mzs-240522.sql

echo "File : /dump/dump-quartz-240522.sql"
mysql -u ${DB_USER} -p${DB_PASSWORD} < /dump/dump-quartz-240522.sql

echo "File : /dump/dump-raon-240522.sql"
mysql -u ${DB_USER} -p${DB_PASSWORD} < /dump/dump-raon-240522.sql

# 커밋하기
execute_mysql "${COMMIT}"

# autocommit 원복하기
execute_mysql "${SET_AUTOCOMMIT_ON}"

echo "Database restore completed and autocommit setting reverted."