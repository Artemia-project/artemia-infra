# Artemia 인프라 - 모듈화 아키텍처

이 문서는 Artemia 인프라 프로젝트의 모듈화된 아키텍처를 설명합니다.

## 모듈 구조

인프라는 재사용 가능한 모듈로 구성되었습니다:

```
modules/
├── network/           # 네트워킹 리소스 (VNet, Subnets, NSGs, Load Balancer)
├── compute/           # 가상 머신, SSH 키, 네트워크 인터페이스
├── database/          # SQL Server, 데이터베이스, 보안 정책
├── messaging/         # EventHub 네임스페이스, 허브, 컨슈머 그룹
├── monitoring/        # 액션 그룹, 메트릭 알람
├── storage/           # 스토리지 계정, 컨테이너
└── ai-ml/            # OpenAI Cognitive Service
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

### 디렉터리 구조
```
artemia-infra/
├── main.tf              # 모듈을 사용하는 메인 구성
├── variables.tf         # 입력 변수
├── outputs.tf           # 모듈의 출력 값
├── locals.tf            # 로컬 값 및 태그
├── backend.tf           # Terraform 백엔드 구성
├── provider.tf          # 프로바이더 구성
├── terraform.tf         # 프로바이더 버전 요구사항
├── modules/             # 재사용 가능한 모듈
└── README-MODULES.md    # 이 파일
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

다양한 환경(dev/stg/prod)에서 이 모듈 구조를 사용하려면:

1. 환경별 디렉터리 생성:
   ```
   environments/
   ├── dev/
   ├── stg/
   └── prod/
   ```

2. 각 환경은 다음을 가져야 합니다:
   - `main.tf` (환경별 값으로 모듈 호출)
   - `terraform.tfvars`
   - `backend.tf` (환경별 상태)

### 모놀리식에서 마이그레이션

기존 모놀리식 구성은 `main.tf.backup`으로 백업되었습니다. 새로운 모듈 구조는 더 나은 조직화와 재사용성을 제공하면서 동일한 기능을 유지합니다.

## 다음 단계

1. `terraform plan`으로 모듈 배포 테스트
2. 환경별 구성 생성
3. 모듈 테스트를 위한 CI/CD 파이프라인 구현
4. 프로덕션 사용을 위한 모듈 버전 관리 고려
