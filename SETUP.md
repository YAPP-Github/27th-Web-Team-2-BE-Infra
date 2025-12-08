# 수정 중인 문서입니다.

이 가이드는 Discord를 통해 AWS 인프라를 제어하는 시스템을 구축하는 방법을 설명합니다.

## 아키텍처

```
Discord 명령어 (/infra start/stop)
  ↓
Discord Bot (AWS Lambda)
  ↓
GitHub Actions Workflow Trigger
  ↓
Terraform Apply/Destroy
  ↓
AWS 리소스 생성/삭제
  ↓
Discord Webhook 알림
```

## 비용

- **Lambda**: 월 100만 요청 무료 (충분함)
- **GitHub Actions**: Private repo 월 2,000분 무료
- **예상 총 비용**: **$0/월** (AWS 리소스 제외)

---

## 1단계: Discord Bot 생성

### 1.1 Discord Application 생성

1. [Discord Developer Portal](https://discord.com/developers/applications) 접속
2. **New Application** 클릭
3. 애플리케이션 이름 입력 (예: "WooSsu Infrastructure Bot")

### 1.2 Bot 설정

1. 좌측 메뉴에서 **Bot** 선택
2. **Add Bot** 클릭
3. **Reset Token** 클릭하여 토큰 복사
    - 이 토큰은 나중에 명령어 등록 시 사용 (`DISCORD_TOKEN`)
    - 안전한 곳에 보관

### 1.3 Public Key 복사

1. 좌측 메뉴에서 **General Information** 선택
2. **PUBLIC KEY** 복사
    - 이 값은 Lambda 환경변수로 사용 (`DISCORD_PUBLIC_KEY`)

### 1.4 Client ID 복사

1. 같은 페이지에서 **APPLICATION ID** 복사
    - 이 값은 명령어 등록 시 사용 (`DISCORD_CLIENT_ID`)

### 1.5 Bot을 서버에 초대

1. 좌측 메뉴에서 **OAuth2 → URL Generator** 선택
2. **Scopes** 섹션:
    - ✅ `bot`
    - ✅ `applications.commands`
3. **Bot Permissions** 섹션:
    - ✅ `Send Messages`
    - ✅ `Use Slash Commands`
4. 하단의 생성된 URL 복사 후 브라우저에서 열기
5. 봇을 초대할 서버 선택

---

## 2단계: GitHub 설정

### 2.1 GitHub Personal Access Token 생성

1. GitHub → **Settings** → **Developer settings** → **Personal access tokens** → **Tokens (classic)**
2. **Generate new token (classic)** 클릭
3. 권한 선택:
    - ✅ `repo` (전체 선택)
    - ✅ `workflow`
4. 토큰 생성 후 복사 (`GITHUB_TOKEN`)

### 2.2 GitHub Repository Secrets 설정

Repository → **Settings** → **Secrets and variables** → **Actions** → **New repository secret**

다음 Secrets를 추가하세요:

| Secret 이름               | 설명                          | 예시                                     |
|-------------------------|-----------------------------|----------------------------------------|
| `AWS_ACCESS_KEY_ID`     | Sandbox AWS Access Key      | `AKIA...`                              |
| `AWS_SECRET_ACCESS_KEY` | Sandbox AWS Secret Key      | `wJalr...`                             |
| `TFVARS_SANDBOX`        | **sandbox.tfvars 파일 전체 내용** | key=value                              |
| `DISCORD_WEBHOOK_URL`   | Discord Webhook URL (선택사항)  | `https://discord.com/api/webhooks/...` |

### 2.3 Discord Webhook URL 생성 (선택사항)

Terraform 실행 결과를 Discord로 받으려면:

1. Discord 서버의 채널 설정 → **Integrations** → **Webhooks**
2. **New Webhook** 클릭
3. Webhook URL 복사
4. GitHub Secrets에 `DISCORD_WEBHOOK_URL`로 추가

---

## 3단계: Discord 명령어 등록

### 3.1 환경 변수 설정

`discord-bot/.env` 파일 생성:

```bash
DISCORD_TOKEN=your_discord_bot_token_here
DISCORD_CLIENT_ID=your_discord_application_id_here
GITHUB_TOKEN=your_github_token_here
GITHUB_REPO_OWNER=WooSsuKorea
GITHUB_REPO_NAME=Terraform
```

### 3.2 명령어 등록 실행

```bash
cd discord-bot
npm install
npm run register
```

성공 메시지 확인:

```
✅ 슬래시 명령어가 성공적으로 등록되었습니다!
```

---

## 4단계: Lambda 배포

### 4.1 Terraform 변수 설정

`sandbox.tfvars` 또는 `prod.tfvars` 파일에 Discord Bot 설정 추가:

```hcl
environment = "sandbox"

# Discord Bot 설정
discord_public_key = "your_discord_public_key_here"
github_token       = "your_github_token_here"
```

**주의**:

- `discord_public_key`: Discord Application의 PUBLIC KEY
- `github_token`: GitHub Personal Access Token

### 4.2 Lambda 배포

```bash
# Sandbox 환경 배포
terraform init
terraform apply -var-file="sandbox.tfvars"
```

배포 완료 후 Lambda Function URL을 복사합니다:

```
Outputs:

discord_bot_function_url = "https://xxxxxx.lambda-url.ap-northeast-2.on.aws/"
```

---

## 5단계: Discord Interactions Endpoint 설정

### 5.1 Lambda Function URL 등록

1. [Discord Developer Portal](https://discord.com/developers/applications) 접속
2. 애플리케이션 선택
3. 좌측 메뉴에서 **General Information** 선택
4. **INTERACTIONS ENDPOINT URL** 입력
    - 4.2단계에서 복사한 Lambda Function URL 입력
5. **Save Changes** 클릭

Discord가 자동으로 엔드포인트를 검증합니다.

---

## 6단계: 테스트

### 6.1 Discord에서 명령어 실행

Discord 채널에서 슬래시 명령어 입력:

```
/infra start environment:sandbox
```

응답 예시:

```
🚀 sandbox 환경 인프라를 시작합니다...

GitHub Actions에서 실행 중입니다.
상태 확인: /infra status environment:sandbox
GitHub: https://github.com/WoosuKorea/Terraform/actions
```

### 6.2 GitHub Actions 확인

1. GitHub Repository → **Actions** 탭
2. `Infrastructure Start` 워크플로우 실행 확인
3. 로그 확인

### 6.3 상태 확인

```
/infra status environment:sandbox
```

---

## 사용 가능한 명령어

| 명령어             | 설명               |
|-----------------|------------------|
| `/infra start`  | Sandbox 환경 시작    |
| `/infra stop`   | Sandbox 환경 종료    |
| `/infra status` | Sandbox 환경 상태 확인 |

**참고**: 모든 명령어는 자동으로 Sandbox 환경에만 적용됩니다. Production 환경은 로컬에서 직접 Terraform을 실행하세요.

---

## 문제 해결

### Discord 명령어가 보이지 않음

1. `npm run register` 실행 확인
2. Bot이 서버에 정상 초대되었는지 확인
3. 5-10분 대기 (Discord 명령어 동기화 시간)

### "Invalid request signature" 오류

1. Lambda 환경 변수의 `DISCORD_PUBLIC_KEY` 확인
2. Discord Developer Portal에서 Public Key 재확인

### GitHub Actions가 트리거되지 않음

1. GitHub Token 권한 확인 (`repo`, `workflow`)
2. Lambda 환경 변수의 `GITHUB_TOKEN` 확인
3. Repository 이름 확인 (`GITHUB_REPO_OWNER`, `GITHUB_REPO_NAME`)

### Terraform 실행 실패

1. GitHub Actions 로그 확인
2. AWS 자격 증명 확인 (Secrets)
3. S3 Backend 확인 (`backend.tf`)

### Lambda 배포 실패

```bash
cd discord-bot
npm install
cd ..
terraform apply -var-file="sandbox.tfvars"
```

---

## 보안 고려사항

### ✅ 해야 할 것

- Discord Public Key는 Terraform 변수로 관리
- GitHub Token, AWS 자격 증명은 GitHub Secrets로 관리
- `.env` 파일은 절대 Git에 커밋하지 않기
- **Production 환경은 Discord Bot으로 제어 불가** (Sandbox만 허용)

### ❌ 하지 말아야 할 것

- Discord Bot Token을 코드에 하드코딩
- AWS Access Key를 `.tfvars`에 직접 작성
- Public Repository에 민감 정보 포함

---

## 비용 절감 효과

### Sandbox 환경 수동 제어 시

- **기존**: 24시간 운영 = 월 720시간
- **최적화**: 평일 10시간 운영 = 월 200시간
- **절감률**: 약 72% 비용 절감

### 예시 (EC2 t3.small 기준)

- 기존: $15/월
- 최적화: $4.2/월
- **절감액**: $10.8/월

---

## 다음 단계

### 기능 확장

1. **스케줄 자동화**: EventBridge로 업무 시간에 자동 시작/종료
2. **권한 관리**: Discord 역할 기반 명령어 제한
3. **상세 모니터링**: CloudWatch 대시보드 추가
4. **알림 강화**: Terraform 출력 정보를 Discord로 전송

### 추가 환경

다른 AWS 계정(Dev, Staging 등)도 같은 방식으로 추가 가능합니다.

---

## 참고 자료

- [Discord Developer Portal](https://discord.com/developers/docs)
- [GitHub Actions 문서](https://docs.github.com/en/actions)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
