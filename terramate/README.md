# Terramate 프로젝트
이 프로젝트는 AWS 인프라와 Kubernetes 애플리케이션을 코드로 관리하는 통합 환경을 제공합니다.   
Terramate를 사용하여 Terraform 모듈과 Helm 차트를 조직화하고, 리소스 간 의존성을 관리합니다.  

## 프로젝트 정보
- **클라우드**: AWS
- **환경**: Develop

## 주요 구성요소
1. **EKS 클러스터**: AWS EKS를 활용한 관리형 쿠버네티스 환경
2. **핵심 인프라 서비스**: Istio, ArgoCD, Datadog 등을 통한 서비스 메시, CI/CD, 모니터링 구성
3. **네트워크 레이어**: VPC, 서브넷, 보안그룹 등의 네트워크 인프라 구성
4. **스토리지**: S3를 활용한 영구 스토리지 관리


## 📁 프로젝트 디렉터리 구조

```markdown
.
├── modules                      # 재사용 가능한 Terraform 모듈 모음
├── stacks                       # 환경별 인프라 스택 정의
│   └── dev                      # 운영 환경 스택
│       ├── config.tm.hcl         # Prod 스택 환경 전역 변수 파일
│       ├── eks                  # Kubernetes 클러스터 관련 리소스
│       ├── helm                 # Kubernetes 애플리케이션 배포
│       │   ├── infra            # 인프라 관련 Helm 차트 (Istio, Datadog 등)
│       │   │   └── helm         # Helm 값 파일 모음
│       │   └── services         # 애플리케이션 서비스 관련 Helm 차트
│       │       └── helm         # 서비스 Helm 값 파일 모음
│       ├── iam                  # 권한 관리 리소스
│       │   └── policy           # IAM 정책 정의
│       ├── network              # 네트워크 관련 리소스
│       │   ├── route            # 라우팅 테이블 설정
│       │   ├── security_group   # 보안 그룹 설정
│       │   ├── subnet           # 서브넷 구성
│       │   ├── vpc              # VPC 구성
│       │   └── vpce             # VPC 엔드포인트 설정
│       └── storage              # 저장소 관련 리소스
│           └── s3               # S3 버킷 구성 정보
├── globals.tm.hcl               # 프로젝트 전역 변수
└── terramate.tm.hcl             # Terramate 프로젝트 설정
```

### 주요 파일 명세
- `/terramate.tm.hcl`: terramate 설정
- `/globals.tm.hcl`: 프로젝트 공통 변수
- `/dev/config.tm.hcl`: `dev` 환경 전용 변수
  - 상위 디렉토리에서 선언한 전역 변수를 하위 stack에서 오버라이드가 가능하다.

## 🛠 사전 요구사항 (Prerequisites)
- Terraform CLI (>= 1.5)
- Terramate CLI (>= 0.13.0)

## 명령어
### 명령어 구조
`terramate run --tags "prod" --enable-sharing -- ${Terraform Command}`
- **--tags "`:`" 연산자**: 계층 구조 지정 (부모:자식 관계)
    - `terramate run --tags=network:vpc -- terraform plan`: network 카테고리 내의 vpc 스택만 실행
- **--tags "`,`" 연산자**: OR 조건 (여러 태그 중 하나라도 일치)
    - `terramate run --tags=network,storage -- terraform plan`: # network 또는 storage 태그를 가진 스택 실행

### terramate 기본 명령어
- `terramate fmt`: **\*.tm.hcl** 코드 각격 및 여백 자동 정리
- `terramate generate`: **\*.tm.hcl** 파일로부터 **\*.tf** 파일 생성
- `terramate create --ensure-id `: 생성한 stack 폴더 혹은 stack 내 **stack.tm.hcl** 파일에 id (UUIDv4) tag 생성

### Terramate stak 초기화
`terramate run --tags "prod" --enable-sharing -- terraform init`
- tfstate 저장소를 S3로 사용 할 경우 init 명령어 끝에 `-reconfigure` 옵션이 필요하다.
  - `terramate run --tags "prod" --enable-sharing -- terraform init -reconfigure`

### 리소스 프로비저닝
`terramate run --tags "prod" --enable-sharing -- terraform plan`  
`terramate run --tags "prod" --enable-sharing -- terraform apply`


## 참고
- [terramate 공식 문서](https://terramate.io/docs/)