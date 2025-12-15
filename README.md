# '서비스 이름' Terraform Infrastructure
## 테스트용 주석

AWS 인프라를 Terraform으로 관리하고, Discord 명령어를 통해 
인프라를 제어하는 프로젝트입니다.
Sandbox(개발) 환경과 Production 환경을 각각 독립적으로 운영하며, Github Actions를 이용해 Terraform 자동화를 적용할 예정입니다.

## 🎯 주요 기능

- **Discord Bot**: 슬래시 명령어로 인프라 제어
- **AWS Infra(EC2, RDS 등)**: Discord Bot 호스팅
- **GitHub Actions**: Terraform 자동 실행
- **비용 절감**: Sandbox 환경을 업무 시간에만 운영
- **환경 분리**: Sandbox/Production 분리 운영

## 📚 문서

- **[SETUP.md](./SETUP.md)**: 환경 설정 및 Terraform 실행 가이드

## 🚀 빠른 시작

### 1. Discord 명령어로 인프라 제어 (Sandbox 전용)

```
/infra start    # Sandbox 인프라 시작
/infra stop     # Sandbox 인프라 종료
/infra status   # 상태 확인
```

**참고**: Production 환경은 로컬 또는 GitHub Actions를 통해 Terraform으로만 제어합니다.

### 2. 로컬에서 Terraform 실행

## 프로젝트 세팅
환경 변수 파일이 gitignore 되어 있어 따로 다운로드를 받아야 합니다.
현재는 @BE 이 가지고 있습니다.

## AWS CLI 자격 증명 설정
Terraform을 실행하려면 각 환경(sandbox, prod)의 AWS 자격 증명을 등록해야 합니다.

**Windows 기준**
```C:\Users\사용자명\.aws\credentials```

**macOS 기준**
```/Users/<사용자명>/.aws/credentials```

아래와 같이 수정합니다.

```
[sandbox]
aws_access_key_id = <ACCESS_KEY>
aws_secret_access_key = <SECRET_KEY>

[prod]
aws_access_key_id = <ACCESS_KEY>
aws_secret_access_key = <SECRET_KEY>
```

## 테라폼 초기화

환경 변경 시마다 init을 다시 실행해야 합니다.

```shell
# Sandbox
terraform init -var-file="sandbox.tfvars" -backend-config="backend-sandbox.hcl" -reconfigure
# Production
terraform init -var-file="prod.tfvars" -backend-config="backend-prod.hcl" -reconfigure
```

## Terraform 실행
#### 실행 계획 확인
```shell
# Sandbox
terraform plan -var-file="sandbox.tfvars"

# Production
terraform plan -var-file="prod.tfvars"
```
#### 실제 실행
```shell
# Sandbox
terraform apply -var-file="sandbox.tfvars"

# Production
terraform apply -var-file="prod.tfvars"
```

## 코드 포멧팅
```shell
terraform fmt --recursive
```
