# Lambda 병행 전환 체크리스트

- [x] 현재 브랜치와 worktree 상태 확인.
- [x] Lambda 전용 ECR repository를 Terraform에 추가.
- [x] backend Lambda image Dockerfile 추가.
- [x] backend Lambda 배포 workflow 추가.
- [x] API Gateway HTTP API + Lambda Terraform 리소스 추가.
- [x] prod tfvars와 GitHub Actions tfvars 생성 로직에 Lambda 변수를 반영.
- [x] Terraform format/validate/plan으로 기존 prod 리소스 삭제가 없는지 확인.
- [x] backend bootJar와 Lambda Web Adapter tag 검증. Docker image 빌드는 Docker CLI 부재로 미실행.
- [x] 변경사항 커밋.
- [x] prod Lambda ECR repository와 lifecycle policy를 targeted Terraform apply로 생성.
- [x] backend Lambda image를 `prod-app-lambda` ECR repository에 push.
- [x] image tag 지정 후 `enable_lambda_api=true`로 Lambda/API Gateway 리소스 apply.
- [x] execute-api endpoint와 custom domain mapping으로 `/ping` smoke test.
- [x] 기존 `api.moit.kr`, `api.weddin.kr` 도메인을 Lambda API Gateway로 전환.
- [x] 기존 `api.*` 도메인으로 `/ping` smoke test.
