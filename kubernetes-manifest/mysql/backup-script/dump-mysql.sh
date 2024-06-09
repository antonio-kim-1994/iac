#!/bin/bash
HOST=""
USER=""
PASSWORD=""
LIMIT=1000
# 스키마 목록을 공백으로 구분하여 지정
DATABASES=("your_database1" "your_database2")
LOCALDIR="/appadmin/db-backup"

# 각 스키마에 대해 작업 수행
for DATABASE in "${DATABASES[@]}"; do
  echo "Processing database $DATABASE..."

  # 데이터베이스의 모든 테이블 목록 가져오기
  TABLES=$(mysql -u $USER -p$PASSWORD -e "SHOW TABLES IN $DATABASE;" | awk '{print $1}' | grep -v "^Tables_in_")

  # 데이터베이스 폴더 생성
  mkdir -p "${LOCALDIR}/${DATABASE}"

  # 각 테이블에 대해 덤프 수행
  for TABLE in $TABLES; do
    echo "Dumping table $TABLE from database $DATABASE with limit $LIMIT rows..."
    mysqldump -u $USER -p$PASSWORD $DATABASE $TABLE --where="1 LIMIT $LIMIT" > "$DATABASE/${TABLE}_backup.sql"
  done

  echo "Dump completed for database $DATABASE."
done

echo "All dumps completed."