# laravel-backend

Laravel 백엔드입니다. 실제 코드는 보안 상 이유로 인해 Private Repository로 운영하고 있으며, 운영진 외에는 볼 수 없습니다.

## 폴더 구조

```
sight-infra/laravel-backend/
├── create-service.sh
├── README.md
├── register-task-definition.sh
└── task-definition.json
```

- `create-service.sh`: 최초에 서비스를 생성하는 스크립트
- `register-task-definition.sh`: ECS에 task definition을 등록하기 위한 스크립트
- `task-definition.json`: ECS task definition 파일
