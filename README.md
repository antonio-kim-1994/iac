# Infrastructure as a Code
![Static Badge](https://img.shields.io/badge/Terraform_1.8.3-grey?stype=flat&logo=terraform&labelColor=2b2d42)
![Static Badge](https://img.shields.io/badge/Ansible_2.16.6-grey?stype=flat&logo=ansible&labelColor=2b2d42)
![Static Badge](https://img.shields.io/badge/Python_3.11.2-grey?stype=flat&logo=python&labelColor=2b2d42)

## 개요
> 인프라 프로비저닝을 위한 코드 샘플들입니다.  
> 각 프로비저닝 툴 폴더 내부에 기본 가이드가 작성되어 있습니다.

### 서비스 기본 가이드라인
- [Terraform 기본 가이드](./terraform/Guide.md)
- [Ansible 기본 가이드](./ansible/Guide.md)

### 버전 정보
- **`Terraform >= 1.8.3`**
- **`Ansible >= 2.16.6`**
- **`Python >= 3.11.2`**

## 적용 내용
### Ansible
- CentOS, Rockylinux, Ubuntu 시스템 패키지 최신 업데이트

### Terraform
- 네이버 금융클라우드(Fin Ncloud) VPC 환경 구성
- 네이버 금융클라우드(Fin Ncloud) NKS 클러스터 및 노드풀 구성   

**주의 사항**
> *금융클라우드의 경우 금융망 내 서버 환경에서만 Terraform API 통신이 동작합니다.*  
> *SSLVPN을 통한 Terraform 요청은 불가합니다.*

## 참조
- [Ansible 공식 가이드 문서](https://docs.ansible.com/ansible/latest/installation_guide/intro_configuration.html)
- [Ansible built-in module](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/index.html)
- [Terraform 공식 가이드 문서](https://developer.hashicorp.com/terraform?product_intent=terraform)
- [Terraform - Ncloud provider](https://github.com/NaverCloudPlatform/terraform-provider-ncloud)
- [Ncloud provider - NKS 배포 가이드 영상](https://d2.naver.com/helloworld/3612055)