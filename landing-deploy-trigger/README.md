# landing-deploy-trigger

Cloudflare Pages Deploy Hook을 호출해 랜딩 페이지를 다시 빌드·배포하는 단발성 ECS 태스크입니다.

## 폴더 구조

```
sight-infra/landing-deploy-trigger/
├── README.md
├── register-task-definition.sh
└── task-definition.json
```

- `register-task-definition.sh`: ECS에 task definition을 등록하는 스크립트
- `task-definition.json`: Deploy Hook에 POST 요청 후 종료하는 ECS task definition

## 사전 준비

1. Cloudflare Pages에서 `main` 브랜치용 Deploy Hook을 생성합니다.
2. Hook URL을 SSM Parameter Store의 SecureString `/app/landing/cloudflare-deploy-hook-url`에 저장합니다.
3. `ecs-service-parameter-reader-role`에 위 Parameter를 읽을 권한이 있는지 확인합니다.
4. CloudWatch Logs에 `/ecs/sight-landing-deploy-trigger` 로그 그룹을 생성합니다.

Deploy Hook URL은 POST만으로 배포를 실행할 수 있으므로 Secret으로 취급합니다.

## Task definition 등록

```bash
./register-task-definition.sh
```

## 예약 태스크 생성

ECS 클러스터의 **예약된 태스크**에서 다음과 같이 설정합니다.

- 클러스터: `sight-cluster`
- 시작 유형: `EC2`
- task definition: 방금 등록한 `sight-landing-deploy-trigger` revision
- 태스크 수: `1`
- 일정: `rate(12 hours)`
- Flexible time window: 비활성화

이 태스크는 `curl --fail --silent --show-error --request POST "$SIGHT_LANDING_DEPLOY_HOOK_URL"`를 실행한 뒤 종료합니다. 실패하면 0이 아닌 종료 코드로 끝나므로 ECS stopped task와 CloudWatch Logs에서 실패 원인을 확인할 수 있습니다.
