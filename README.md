# Artemia Infrastructure

Azure 기반의 Artemia 프로젝트 인프라스트럭처를 관리하는 Terraform 코드입니다.

## 프로젝트 구조

- `main.tf` - 주요 Azure 리소스 정의
- `provider.tf` - Azure provider 설정
- `variables.tf` - Terraform 변수 정의
- `terraform.tf` - Terraform 버전 및 백엔드 설정
- `backend.tf` - 원격 상태 저장소 설정 (협업을 위해 Terraform 상태 파일을 로컬 대신 Azure Storage에 안전하게 저장하기 위함)
- `terraform.tfvars` - 변수 값 정의

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

## 배포 순서

1. Azure CLI 로그인
   ```bash
   az login
   ```

2. 백엔드 스토리지 설정
   ```bash
   ./setup-backend.sh
   ```

3. 환경변수 설정
   ```bash
   source ./set-arm-key.sh
   ```

4. Terraform 초기화 및 배포
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

## 요구사항

- Azure CLI
- Terraform
- 적절한 Azure 구독 권한