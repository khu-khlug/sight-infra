# reverse-proxy

인프라의 가장 앞단에서 요청을 최초로 받는 곳입니다. SSL Termination 및 `Host`에 따른 트래픽 라우팅을 수행합니다.

## 폴더 구조

```
sight-infra/reverse-proxy/
├── crontab.txt
├── Dockerfile
├── entrypoint.sh
├── nginx.conf
├── README.md
├── register-task-definition.sh
└── task-definition.json
```

- `crontab.txt`: cron 기반 certbot 자동 갱신 스크립트
- `Dockerfile`: nginx reverse proxy 컨테이너 이미지를 생성하는 Dockerfile
- `entrypoint.sh`: nginx 컨테이너가 켜지면 실행될 스크립트, 최초 인증서 발급을 처리합니다.
- `nginx.conf`: nginx 설정 파일, HTTPS 리다이렉트 및 SSL Termination에 대한 설정이 포함되어 있습니다.
- `register-task-definition.sh`: 최초에 ECS에 task definition을 등록하기 위한 스크립트
  - `task-definition.json`에서 `latest` 태그를 사용하고 있기 때문에 `task-definition.json`을 배포할 때 올리지 않습니다. 따라서 최초 한 번 `task-definition.json`을 등록해주어야 합니다.
- `task-definition.json`: ECS task definition 파일

## 도메인 추가

운영 중, 도메인을 추가해야 하는 경우 아래 프로세스를 따라주세요.

1. [`entrypoint.sh`](./entrypoint.sh)의 `certbot` 명령어에 추가할 도메인을 옵션으로 넣어주세요.
2. [`nginx.conf`](./nginx.conf)에 추가할 도메인과 뒷단 서버에 대한 정보를 `server` 블록으로 추가해주세요.
3. 그런 다음 해당 `reverse-proxy` 컨테이너를 배포합니다.
