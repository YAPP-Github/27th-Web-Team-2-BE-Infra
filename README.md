# '서비스 이름' Terraform Infrastructure

**AWS 인프라를 Terraform으로 관리**하고,  
**GitHub Actions와 Discord 명령어를 통해 인프라를 제어**하는 것을 목표로 합니다.

Sandbox(테스트) 환경과 Production 환경을 분리하여 운영하며,  
Terraform Plan / Apply를 GitHub Actions로 자동화하여  
**안전한 변경 검증 → 수동 승인 적용** 흐름을 구성했습니다.

---

## 🎯 주요 기능

- **Discord Bot**
    - Sandbox 인프라 시작 / 종료 / 상태 확인
- **AWS Infrastructure**
    - EC2, RDS 등 서비스 운영 인프라 관리
- **Terraform IaC**
    - 코드 기반 인프라 관리
- **GitHub Actions**
    - `sandbox` 브랜치에 push 시 Terraform Plan 자동 실행
    - 승인 후 Terraform Apply 수동 실행
- **환경 분리**
    - Sandbox / Production 독립 운영
- **비용 절감**
    - Sandbox 환경은 필요 시에만 운영

---

## 📚 문서

- **[SETUP.md](./SETUP.md)**  
  로컬 개발 환경 및 Terraform 실행 방법 정리

---

## 🚀 인프라 제어 방식 개요

### 1️⃣ Sandbox 인프라 (개발 환경)

#### Discord 명령어
```
/infra start    # Sandbox 인프라 시작
/infra stop     # Sandbox 인프라 종료
/infra status   # 상태 확인
```

- Sandbox 환경은 비용 절감을 위해 **필요한 시간에만 운영**
- Discord Bot은 Sandbox 환경 전용

---

### 2️⃣ Terraform + GitHub Actions (권장 방식)

#### Terraform Plan
- `sandbox` 브랜치 push 기준으로 Plan 실행
- 변경 사항을 **실제 리소스 생성 없이(terraform plan 단계에서) 검증**
- Plan 결과는 GitHub Actions Summary 및 Discord 알림으로 확인

#### Terraform Apply
- GitHub Actions `workflow_dispatch`로 **수동 실행**
- GitHub Environment를 통한 승인 후 적용 가능
- Sandbox / Production 각각 독립 실행

> Sandbox 환경에서는 Apply가 실행 시점의 최신 커밋을 기준으로 수행됩니다.  
> 따라서 Plan 이후 추가 변경이 있다면 Apply 결과가 달라질 수 있습니다.

---

## 🧪 Terraform 변경 테스트 흐름 (Sandbox 기준)

1. `develop` 브랜치 기준으로 작업 브랜치 생성
2. 테스트가 필요한 변경을 `sandbox` 브랜치에 직접 반영
3. GitHub Actions에서 Terraform Plan 자동 실행
4. Plan 결과 확인
5. 필요 시 GitHub Actions에서 Terraform Apply 수동 실행

> Sandbox에서는 필요 시 `null_resource` 등을 활용해
> 리소스 생성 없이 Terraform 동작 검증이 가능합니다.

---

## 💻 로컬에서 Terraform 실행

### AWS CLI 자격 증명 설정

Terraform 실행을 위해 AWS Profile 기반 인증을 사용합니다.

#### 자격 증명 파일 위치
- **Windows**
  ```
  C:\Users\<사용자명>\.aws\credentials
  ```
- **macOS**
  ```
  /Users/<사용자명>/.aws/credentials
  ```

#### 예시
```
[sandbox-nomoney]
aws_access_key_id     = <ACCESS_KEY>
aws_secret_access_key = <SECRET_KEY>

[prod-nomoney]
aws_access_key_id     = <ACCESS_KEY>
aws_secret_access_key = <SECRET_KEY>
```

---

### Terraform 초기화

환경 변경 시마다 `terraform init`을 다시 실행해야 합니다.

```shell
# Sandbox
terraform init \
-var-file="sandbox.tfvars" \
-backend-config="backend/backend-sandbox.hcl" \
-reconfigure

# Production
terraform init \
-var-file="prod.tfvars" \
-backend-config="backend/backend-prod.hcl" \
-reconfigure
```

---

### Terraform 실행

#### 실행 계획 확인
```shell
# Sandbox
terraform plan -var-file="sandbox.tfvars"

# Production
terraform plan -var-file="prod.tfvars"
```

#### 실제 적용
```shell
# Sandbox
terraform apply -var-file="sandbox.tfvars"

# Production
terraform apply -var-file="prod.tfvars"
```

---

## 🧹 코드 포맷팅

```shell
terraform fmt --recursive
```

---