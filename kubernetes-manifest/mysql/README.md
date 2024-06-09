## MySQL 데이터 복구 다운로드 관련
- **Object Storage 백업 파일 다운로드 명령어**
    - Cloud DB for MySQL에서 Bakcup 내보내기 완료 후 진행
    ```bash
    # aws cli 설치
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install

    # aws 자격증명 등록
    aws configure --profile ncloud
    AWS Access Key ID : <Subaccount Access Key>
    AWS Secret Access Key : <Subaccount Secret Key>
    Default region name : FKR
    Default ouput format : json

    # ncloud object storage 다운로드
    aws s3 --endpoint-url https://kr.object.fin-ncloudstorage.com cp s3://bucket/object /local/dir --profile ncloud
    ```

- **MySQL Dump**
    ```bash
    USER=username
    PASSWORD=password
    HOST=host
    PORT=port
    SCHEMA=schema
    OUTPUT=/local/dir/schema.sql

    mysqldump --set-gtid-purged=OFF --skip-lock-tables -u ${USER} -p{PASSWORD} -h ${HOST} -P ${PORT} --databases ${SCHEMA} > ${OUTPUT}
    ```