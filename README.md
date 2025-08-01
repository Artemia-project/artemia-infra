# Artemia Infrastructure

Azure 기반의 Artemia 프로젝트 인프라스트럭처를 관리하는 Terraform 코드입니다.

환경별(dev, prod) 분리와 모듈화된 아키텍처를 통해 재사용 가능하고 확장 가능한 인프라를 제공합니다.

## 프로젝트 구조

```
artemia-infra/
├── environments/
│   ├── dev/           # 개발 환경
│   │   ├── main.tf
│   │   ├── provider.tf
│   │   ├── backend.tf
│   │   ├── terraform.tf
│   │   ├── locals.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── terraform.tfvars
│   └── prod/          # 프로덕션 환경
│       ├── main.tf
│       ├── provider.tf
│       ├── backend.tf
│       ├── terraform.tf
│       ├── locals.tf
│       ├── variables.tf
│       ├── outputs.tf
│       └── terraform.tfvars
├── modules/           # 재사용 가능한 Terraform 모듈
│   ├── ai-ml/         # Azure OpenAI 서비스
│   ├── compute/       # Virtual Machines
│   ├── database/      # SQL Servers
│   ├── messaging/     # EventHubs (Kafka)
│   ├── monitoring/    # 모니터링 및 알림
│   ├── network/       # VNet, Subnet, NSG
│   ├── services/      # 서비스별 설정
│   └── storage/       # Storage Accounts
├── setup-backend.sh   # 백엔드 스토리지 설정
├── set-arm-key.sh     # Azure 액세스 키 설정
└── stop-vm.sh         # VM 관리 스크립트
```

### 환경별 파일 구조
- `main.tf` - 모듈 호출 및 리소스 그룹 정의
- `provider.tf` - Azure provider 설정
- `backend.tf` - 환경별 원격 상태 저장소 설정
- `terraform.tf` - Terraform 버전 요구사항
- `locals.tf` - 환경별 태그 및 로컬 변수
- `variables.tf` - 입력 변수 정의
- `outputs.tf` - 출력 값 정의
- `terraform.tfvars` - 환경별 변수 값 (gitignore됨)

## Shell Scripts

### `setup-backend.sh`
Azure에서 Terraform 원격 상태 저장소를 설정하는 스크립트입니다.

**기능:**
- Azure 리소스 그룹 생성 (`artemia-rg`)
- 스토리지 계정 생성 (`artemiastatestore`)
- Terraform 상태 파일을 위한 blob 컨테이너 생성 (`tfstate`)

**사용법:**
```bash
./setup-backend.sh
```

### `set-arm-key.sh`
Azure Storage Account의 액세스 키를 환경변수로 설정하는 스크립트입니다.

**기능:**
- Azure Storage Account에서 액세스 키 조회
- `ARM_ACCESS_KEY` 환경변수로 설정하여 Terraform이 백엔드에 액세스할 수 있도록 함

**사용법:**
```bash
source ./set-arm-key.sh
```

### `terraform-import-commands.sh`
기존 Azure 리소스를 Terraform 상태로 가져오기 위한 명령어들을 포함한 스크립트입니다.

**주의사항:**
- 이 스크립트는 **참고용으로만** 사용하세요
- 실제로는 정상 동작하지 않을 수 있습니다
- 리소스 임포트 시에는 수동으로 각 명령어를 확인하고 실행하시기 바랍니다

## 배포 순서

### 1. 준비
```bash
# Azure CLI 로그인
az login

# 백엔드 스토리지 설정 (최초 1회만 실행)
./setup-backend.sh

# 환경변수 설정 (Terraform 실행 전 매번 필요)
source ./set-arm-key.sh
```

### 2. 개발 환경 배포
```bash
# 개발 환경 디렉토리로 이동
cd environments/dev

# Terraform 초기화
terraform init

# 배포 계획 확인
terraform plan

# 인프라 배포
terraform apply
```

### 3. 프로덕션 환경 배포
```bash
# 프로덕션 환경 디렉토리로 이동
cd environments/prod

# Terraform 초기화
terraform init

# 배포 계획 확인
terraform plan

# 인프라 배포
terraform apply
```

### 4. 개별 모듈 테스트 (개발 시)
```bash
# 특정 모듈 디렉토리로 이동
cd modules/<module-name>

# 모듈 초기화
terraform init

# 모듈 테스트 (변수 파일 지정)
terraform plan -var-file="../../environments/prod/terraform.tfvars"
```

## 아키텍처 개요

### 인프라 구성요소
- **Resource Group**: `artemia-rg` (Korea Central)
- **Virtual Machines**: Backend, LLM, Elasticsearch
- **Networking**: VNet, Subnet, NSG, Load Balancer
- **Database**: Azure SQL Server with Azure AD 인증
- **Storage**: Terraform 상태 저장소 및 데이터 저장소
- **Messaging**: EventHub (Kafka)
- **AI/ML**: Azure OpenAI Cognitive Services
- **Monitoring**: Action Groups 및 Metric Alerts

### 모듈별 역할
- **network**: 네트워크 인프라 (VNet, Subnet, NSG, Load Balancer)
- **compute**: 가상머신 리소스 (Backend, LLM, Elasticsearch)
- **database**: Azure SQL Server 및 Database
- **storage**: Storage Account 리소스
- **messaging**: EventHub 및 관련 리소스
- **ai-ml**: Azure OpenAI서비스
- **monitoring**: 모니터링 및 알림 설정

## 환경 관리

### 환경별 상태 파일 분리
- Development: `dev/terraform.tfstate`
- Production: `prod/terraform.tfstate`

### 환경별 변수 관리
각 환경에서 `terraform.tfvars` 파일을 통해 환경별 설정 관리:
- VM 크기 및 스토리지 타입
- 네트워크 설정
- 모니터링 임계값
- 인증 정보

## 개발 가이드라인

### 새로운 리소스 추가
1. `modules/` 디렉토리에 모듈 생성
2. 개발 환경에서 테스트
3. 프로덕션 환경에 적용

### 보안 고려사항
- SSH 키 인증 사용
- NSG 규칙 최소 권한 적용
- Azure AD 인증 우선 사용
- 환경별 완전 분리

## 요구사항

- Azure CLI
- Terraform >= 1.0
- Azure 구독 권한
- SSH 키 페어 / Azure AD 설정 (VM 접근용)

## 주의사항

1. **작업 디렉토리**: Terraform 명령은 해당 환경 디렉토리에서 실행
2. **환경 변수**: `ARM_ACCESS_KEY` 설정 후 Terraform 실행
3. **변수 파일**: `terraform.tfvars`는 환경별 관리, git 커밋 금지
4. **상태 파일**: 환경별로 분리되어 있으므로 올바른 디렉토리에서 작업
5. **모듈 의존성**: 모듈 간 의존성 관계 고려하여 개발
