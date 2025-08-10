# nestjs-backend

Nestjs 백엔드입니다. 실제 코드는 [`khu-khlug/sight-backend`](https://github.com/khu-khlug/sight-backend) 레포지토리를 참고해주세요.

## 폴더 구조

```
sight-infra/nestjs/backend/
├── create-service.sh
├── README.md
├── register-task-definition.sh
└── task-definition.json
```

- `create-service.sh`: 최초에 서비스를 생성하는 스크립트
- `register-task-definition.sh`: ECS에 task definition을 등록하기 위한 스크립트
- `task-definition.json`: ECS task definition 파일
