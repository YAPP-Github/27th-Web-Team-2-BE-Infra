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
