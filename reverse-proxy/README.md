# reverse-proxy

인프라의 가장 앞단에서 요청을 최초로 받는 곳입니다. SSL Termination 및 `Host`에 따른 트래픽 라우팅을 수행합니다.

## Caddy 사용

본 리버스 프록시는 Golang 기반의 [Caddy](https://caddyserver.com/)를 사용하고 있습니다.

일반적으로는 nginx를 사용하나, nginx가 SRV 레코드에 의한 라우팅을 기본적으로 제공하고 있지 않으며, https 인증서 발급을 수동으로 세팅해주어야 하는 등 운영 시 신경 써주어야 하는 부분이 여럿 존재하였기 때문에 Caddy를 활용하게 되었습니다.

## 폴더 구조

```
sight-infra/reverse-proxy/
├── Caddyfile
├── create-service.sh
├── Dockerfile
├── README.md
├── register-task-definition.sh
└── task-definition.json
```

- `Caddyfile`: Caddy 웹 서버에 대한 설정 파일
- `create-service.sh`: 최초에 서비스를 생성하는 스크립트
- `Dockerfile`: caddy reverse proxy 컨테이너 이미지를 생성하는 Dockerfile
- `register-task-definition.sh`: 최초에 ECS에 task definition을 등록하기 위한 스크립트
- `task-definition.json`: ECS task definition 파일

## 도메인 추가

운영 중, 도메인을 추가해야 하는 경우 아래 프로세스를 따라주세요.

1. [`Caddyfile`](./Caddyfile)에 새로운 도메인과 프록시 대상 서버를 추가합니다.
2. [리버스 프록시 빌드 액션](/.github/workflows/build-reverse-proxy.yaml)을 활용하여 이미지를 빌드합니다.
3. [`register-task-definition.sh`](./register-task-definition.sh)를 사용하여 새로운 task definition을 생성합니다.
4. AWS ECS 콘솔에서 새로 생성한 task definition을 적용하여 새 서비스를 띄웁니다.
