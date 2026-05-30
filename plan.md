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
