# Lambda 병행 전환 계획

## 목표

기존 prod ECS/ALB 인프라는 유지한 채 Spring Boot API를 Lambda + API Gateway HTTP API 경로로 추가 배포하고, 별도 테스트 도메인에서 검증한 뒤 문제가 없을 때 기존 API 도메인을 이전한다.

## 가정

- 현재 prod 트래픽은 `api.moit.kr`, `api.weddin.kr`에서 ALB/ECS로 계속 처리한다.
- Lambda 테스트 경로는 `lambda-api.moit.kr`, `lambda-api.weddin.kr`처럼 기존 도메인과 분리한다.
- backend 앱은 Spring Boot HTTP 서버이므로 Lambda Web Adapter 기반 container image로 실행한다.
- Lambda image repository는 ECS image repository와 분리해 lifecycle 충돌을 피한다.

## 접근

1. `aws-iac`에 Lambda 전용 ECR repository를 추가한다.
2. backend repo에 Lambda image용 Dockerfile과 수동 배포 workflow를 추가한다.
3. `aws-iac`에 `enable_lambda_api` 플래그로 보호되는 API Gateway HTTP API + Lambda 리소스를 추가한다.
4. 첫 적용은 ECR repo 생성까지 확인하고, Lambda image push 후 `enable_lambda_api`를 켜서 병행 endpoint를 만든다.
5. `/ping`과 주요 API를 ALB 경로와 Lambda 경로에서 비교한다.

## 검증 기준

- backend의 `Dockerfile.lambda`가 빌드된다.
- Terraform format/validate가 통과한다.
- prod plan에서 기존 ECS/ALB 삭제가 없어야 한다.
- Lambda endpoint `/ping`이 `pong!`을 반환해야 한다.

## Lambda-only 상시 인프라 정리 계획

### 목표

운영 API 도메인이 Lambda/API Gateway로 안정적으로 전환됐으므로 ECS on EC2, ALB, VPC 등 상시 비용이 발생하는 이전 런타임 인프라를 Terraform desired state에서 제외한다. 단, 나중에 복구할 수 있도록 기존 HCL은 삭제하지 않고 주석으로 남긴다.

### 접근

1. Lambda/API Gateway를 기본 운영 경로로 고정해 `enable_lambda_api`와 `route_primary_api_to_lambda` 입력값이 false여도 운영 Lambda 리소스가 제거되지 않게 한다.
2. ECS/EC2/ALB 호출부와 ALB HTTPS listener를 주석 처리해 이전 런타임 리소스가 destroy 대상으로 잡히게 한다.
3. Lambda가 사용하지 않는 VPC, ECS용 ECR repository, Grafana SSM 파라미터를 주석 처리한다.
4. 이미 live에는 있지만 Terraform state 밖에 있는 API SSM 파라미터는 placeholder 재생성을 피하도록 주석 처리한다.
5. Route53 `api.*` alias는 API Gateway custom domain만 바라보게 하고, 기존 ALB alias 코드는 주석으로 남긴다.
6. `terraform fmt`, `terraform validate`, `terraform plan -var-file=prod.tfvars`로 Lambda 유지와 이전 인프라 destroy 범위를 확인한다.

### 검증 기준

- Lambda, API Gateway, Route53 hosted zone, `api.*` ACM 인증서는 destroy 대상에 포함되지 않아야 한다.
- API용 SSM 파라미터는 live 값을 유지하되 이번 cleanup apply에서 create/destroy 대상에 포함되지 않아야 한다.
- ECS service, ECS cluster/capacity provider, EC2 ASG/launch template/IAM, ALB/listener/target group/security group, VPC/subnet/IGW/route table, ECS용 ECR, Grafana SSM은 destroy 대상에 포함되어야 한다.
- 실제 `terraform apply`는 별도 승인 후 진행한다.
