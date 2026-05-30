# Lambda 병행 전환 컨텍스트 노트

## 2026-05-30

- 기존 prod는 ECS on EC2 + ALB로 유지한다.
- Lambda는 별도 테스트 도메인으로 추가해 트래픽 이전 전 검증한다.
- ECS와 Lambda image를 같은 ECR repository에 섞으면 기존 lifecycle policy가 최근 3개 이미지만 유지해 운영 image를 밀어낼 수 있다. Lambda 전용 ECR repository를 분리한다.
- Lambda function 생성은 image tag가 ECR에 있어야 가능하다. 따라서 ECR repo 생성, backend Lambda image push, Lambda/API Gateway enable 순서가 필요하다.
- `enable_lambda_api` 기본값은 `false`로 두어 기존 prod plan/apply가 즉시 Lambda function 생성을 시도하지 않게 한다.
- prod Terraform workflow는 수동 실행 시 `enable_lambda_api`와 `lambda_image_tag`를 입력받게 한다.
- backend Lambda workflow는 function이 없으면 image push까지만 성공 처리하고, function이 있으면 `update-function-code`를 수행한다.
- 로컬에는 Docker CLI가 없어 `Dockerfile.lambda` 이미지는 이 머신에서 빌드 검증하지 못했다. 대신 backend Gradle test/ktlint와 workflow YAML parse를 먼저 검증했다.
- prod Terraform plan에서 `enable_lambda_api=false`는 19 create, 1 update, 0 destroy이고 `enable_lambda_api=true`는 39 create, 1 update, 0 destroy였다. create에는 기존 state 밖 SSM 파라미터가 포함된다.
- `public.ecr.aws/awsguru/aws-lambda-adapter:1.0.0` manifest는 Public ECR anonymous token으로 HTTP 200을 확인했다.
- `./gradlew :app:api:bootJar`가 성공해 Dockerfile의 애플리케이션 jar 생성 단계는 확인했다.
- live SSM에는 `/prod/nomoney/api/*`, `/prod/nomoney/grafana/*` 값이 이미 존재하지만 prod Terraform state에는 잡혀 있지 않다. 전체 apply는 이 SSM drift 때문에 Lambda 변경과 무관하게 충돌할 수 있다.
- ECR apply 전 전체 prod plan은 19 add, 1 change, 0 destroy였다. ECR apply 후 전체 prod plan은 17 add, 1 change, 0 destroy로 남아 있다. 남은 plan에는 Lambda 작업과 무관한 state 밖 SSM 파라미터와 ECS launch template AMI drift가 같이 포함된다.
- 안전한 bootstrap 단위로 `module.component.module.ecr.aws_ecr_repository.lambda_repository`와 `module.component.module.ecr.aws_ecr_lifecycle_policy.lambda_retention`만 target plan/apply했다.
- ECR targeted apply 결과는 2 added, 0 changed, 0 destroyed였다. 생성된 repository는 `618531912247.dkr.ecr.ap-northeast-2.amazonaws.com/prod-app-lambda`이고 scan on push가 켜져 있다.
- `prod-app-lambda` repository의 image 목록은 비어 있다. Lambda function과 API Gateway apply는 image push 이후에 진행해야 한다.
- backend 브랜치 `feat/72-lambda-parallel`은 원격에 push됐다. 다만 새 `prod-deploy-lambda.yml` workflow는 기본 브랜치에 없어서 GitHub Actions의 workflow 목록에는 아직 나타나지 않는다.
- backend Lambda workflow 첫 실행은 성공했지만 `b3c5ebd7fd31f63b5ae23297cdfb70950f9c3290` image가 `application/vnd.oci.image.index.v1+json` manifest로 push되어 Lambda CreateFunction이 거부했다.
- backend workflow에 `provenance: false`, `sbom: false`를 추가해 Buildx가 Lambda 호환 Docker v2 manifest를 push하도록 수정했다.
- 수정 후 workflow run `26678602746`이 성공했고 image tag `709323aa10772b8365ad7ed356d6d7416a87734f`의 manifest는 `application/vnd.docker.distribution.manifest.v2+json`로 확인됐다.
- Lambda/API Gateway retry target apply는 4 added, 0 changed, 0 destroyed였다. 생성된 함수는 `prod-app-lambda`, HTTP API id는 `rq02kcvz8e`다.
- `terraform plan -target=module.component.module.prod`는 `enable_lambda_api=true`, `lambda_image_tag=709323aa10772b8365ad7ed356d6d7416a87734f` 조건에서 no changes를 확인했다.
- `https://rq02kcvz8e.execute-api.ap-northeast-2.amazonaws.com/ping`는 HTTP 200과 `Healthy Connection`을 반환했다.
- `lambda-api.moit.kr`와 `lambda-api.weddin.kr` Route53 alias는 생성됐고 API Gateway custom domain target으로 강제 resolve하면 둘 다 `/ping` HTTP 200을 반환한다. 일반 DNS resolver에서는 신규 레코드 전파가 아직 일관되지 않을 수 있다.
