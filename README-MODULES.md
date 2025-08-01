# Artemia 인프라 - 모듈화 아키텍처

이 문서는 Artemia 인프라 프로젝트의 모듈화된 아키텍처와 환경별 구조를 설명합니다. 인프라는 재사용 가능한 모듈과 환경별 분리를 통해 확장성과 유지보수성을 제공합니다.

## 모듈 구조

인프라는 재사용 가능한 모듈로 구성되었습니다:

```
modules/
├── ai-ml/             # Azure OpenAI 서비스
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
├── compute/           # 가상 머신 리소스 (Backend, LLM, Elasticsearch)
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
├── database/          # Azure SQL Server 및 Database
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
├── messaging/         # EventHub (Kafka)
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
├── monitoring/        # Action Groups 및 Metric Alerts
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
├── network/           # VNet, Subnet, NSG, Load Balancer
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
├── services/          # 서비스별 설정
│   ├── backend/
│   └── frontend/
└── storage/           # Storage Accounts
    ├── main.tf
    ├── variables.tf
    └── outputs.tf
```

## 모듈 설명

### Network 모듈 (`modules/network/`)
- **목적**: 모든 네트워킹 리소스 관리
- **리소스**: 
  - 가상 네트워크 및 서브넷
  - 네트워크 보안 그룹 및 규칙
  - 로드 밸런서 및 백엔드 풀
- **주요 출력**: `vnet_id`, `default_subnet_id`, `backend_pool_id`, NSG ID들

### Compute 모듈 (`modules/compute/`)
- **목적**: 가상 머신 및 관련 컴퓨팅 리소스 관리
- **리소스**:
  - Linux 가상 머신 (Backend, LLM, Elasticsearch)
  - SSH 공개 키
  - 네트워크 인터페이스 및 공용 IP
  - 로드 밸런서 연결
- **주요 출력**: VM ID, 공용 IP 주소

### Database 모듈 (`modules/database/`)
- **목적**: SQL Server 및 데이터베이스 리소스 관리
- **리소스**:
  - Azure AD 인증이 설정된 Azure SQL Server
  - TDE 암호화가 적용된 SQL 데이터베이스
  - 방화벽 규칙 및 보안 정책
  - 가상 네트워크 규칙
- **주요 출력**: 서버 및 데이터베이스 ID, FQDN

### Messaging 모듈 (`modules/messaging/`)
- **목적**: EventHub (Kafka) 메시징 인프라 관리
- **리소스**:
  - EventHub 네임스페이스
  - 컨슈머 그룹이 있는 EventHub
  - 권한 부여 규칙
- **주요 출력**: 네임스페이스 및 EventHub ID, 연결 문자열

### Monitoring 모듈 (`modules/monitoring/`)
- **목적**: 모니터링 및 알림 인프라 관리
- **리소스**:
  - 알림용 액션 그룹
  - 포괄적인 VM 메트릭 알람 (CPU, 메모리, 디스크, 네트워크, 가용성)
- **주요 출력**: 액션 그룹 ID, 메트릭 알람 ID

### Storage 모듈 (`modules/storage/`)
- **목적**: 스토리지 계정 및 컨테이너 관리
- **리소스**:
  - 메인 데이터 스토리지 계정
  - Terraform 상태 스토리지 계정
  - 스토리지 컨테이너 및 큐 속성
- **주요 출력**: 스토리지 계정 이름 및 ID

### AI/ML 모듈 (`modules/ai-ml/`)
- **목적**: AI/ML 서비스 관리
- **리소스**:
  - Azure OpenAI 코그니티브 서비스
- **주요 출력**: 코그니티브 계정 엔드포인트, 액세스 키

## 사용법

### 전체 디렉터리 구조
```
artemia-infra/
├── environments/        # 환경별 구성
│   ├── dev/            # 개발 환경
│   │   ├── main.tf     # 모듈 호출
│   │   ├── provider.tf
│   │   ├── backend.tf
│   │   ├── terraform.tf
│   │   ├── locals.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── terraform.tfvars
│   └── prod/           # 프로덕션 환경
│       ├── main.tf
│       ├── provider.tf
│       ├── backend.tf
│       ├── terraform.tf
│       ├── locals.tf
│       ├── variables.tf
│       ├── outputs.tf
│       └── terraform.tfvars
├── modules/            # 재사용 가능한 모듈
│   ├── ai-ml/
│   ├── compute/
│   ├── database/
│   ├── messaging/
│   ├── monitoring/
│   ├── network/
│   ├── services/
│   └── storage/
├── setup-backend.sh    # 백엔드 설정 스크립트
├── set-arm-key.sh      # Azure 액세스 키 설정
├── stop-vm.sh          # VM 관리 스크립트
└── README-MODULES.md   # 이 파일
```

### 모듈 표준
각 모듈은 다음 규약을 따릅니다:
- `main.tf` - 리소스 정의
- `variables.tf` - 설명과 기본값이 있는 입력 변수
- `outputs.tf` - 모듈 사용자를 위한 출력 값

### 모듈화 아키텍처의 장점

1. **재사용성**: 모듈을 다양한 환경에서 재사용 가능
2. **유지보수성**: 변경사항이 특정 모듈에 격리됨
3. **테스트**: 개별 모듈을 독립적으로 테스트 가능
4. **확장성**: 새로운 환경 추가나 기존 환경 수정 용이
5. **조직화**: 명확한 관심사 분리

### 환경별 사용법

#### 개발 환경 배포
```bash
cd environments/dev
terraform init
terraform plan
terraform apply
```

#### 프로덕션 환경 배포
```bash
cd environments/prod
terraform init
terraform plan
terraform apply
```

#### 개별 모듈 테스트
```bash
cd modules/<module-name>
terraform init
terraform plan -var-file="../../environments/prod/terraform.tfvars"
```

### 환경별 구성 관리

각 환경은 다음과 같이 구성됩니다:

1. **환경별 백엔드 분리**:
   - Development: `key = "dev/terraform.tfstate"`
   - Production: `key = "prod/terraform.tfstate"`

2. **환경별 변수 관리**:
   - `terraform.tfvars` 파일을 통해 환경별 설정
   - VM 크기, 스토리지 타입, 모니터링 임계값 등 차별화

3. **환경별 태그**:
   ```hcl
   # environments/dev/locals.tf
   locals {
     tags = {
       Terraform   = "true"
       Environment = "dev"
       Project     = "artemia"
     }
   }
   
   # environments/prod/locals.tf
   locals {
     tags = {
       Terraform   = "true"
       Environment = "prod"
       Project     = "artemia"
     }
   }
   ```

### 모놀리식에서 마이그레이션

기존 모놀리식 구성은 `main.tf.backup`으로 백업되었습니다. 새로운 모듈 구조는 더 나은 조직화와 재사용성을 제공하면서 동일한 기능을 유지합니다.

## 모듈 의존성

모듈 간의 의존성 관계:

```
network (기본) 
    ↓
compute, database (network 출력 사용)
    ↓  
monitoring (compute 출력 사용)
    ↓
ai-ml, messaging, storage (독립적)
```

### 의존성 관리 예시
```hcl
# environments/prod/main.tf
module "network" {
  source = "../../modules/network"
  # ... 변수들
}

module "compute" {
  source = "../../modules/compute"
  subnet_id = module.network.default_subnet_id
  # ... 기타 변수들
  depends_on = [module.network]
}

module "monitoring" {
  source = "../../modules/monitoring"
  vm_ids = {
    "artemia-backend-vm" = module.compute.backend_vm_id
    # ... 기타 VM들
  }
  depends_on = [module.compute]
}
```

## 모듈 개발 가이드라인

### 새로운 모듈 추가
1. `modules/` 디렉터리에 새 모듈 디렉터리 생성
2. 표준 파일 생성: `main.tf`, `variables.tf`, `outputs.tf`
3. 모듈 문서화 (변수 설명, 출력 설명)
4. 개발 환경에서 테스트
5. 프로덕션 환경에 적용

### 모듈 수정 시 주의사항
1. **하위 호환성**: 기존 변수 인터페이스 유지
2. **출력 안정성**: 기존 출력 값 변경 시 영향 분석
3. **환경 간 일관성**: 모든 환경에서 동일하게 작동하는지 확인
4. **의존성 검토**: 다른 모듈에 미치는 영향 검토

## 베스트 프랙티스

1. **모듈 단일 책임**: 각 모듈은 하나의 명확한 책임을 가짐
2. **변수 검증**: 입력 변수에 대한 적절한 검증 규칙 적용
3. **출력 명시**: 다른 모듈에서 사용할 수 있는 모든 중요 값을 출력
4. **태그 일관성**: 모든 리소스에 일관된 태그 적용
5. **문서화**: 각 모듈의 목적과 사용법을 명확히 문서화

## 다음 단계

1. **환경별 구성 완성**: 개발/프로덕션 환경별 세부 설정
2. **CI/CD 파이프라인**: 자동화된 테스트 및 배포 구현
3. **모니터링 강화**: 환경별 모니터링 및 알림 세분화
4. **보안 강화**: 환경별 보안 정책 및 접근 제어
5. **백업 전략**: 환경별 백업 및 재해 복구 계획
