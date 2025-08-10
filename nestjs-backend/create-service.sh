aws ecs create-service \
  --cluster sight-cluster \
  --service-name sight-nestjs-backend \
  --task-definition sight-nestjs-backend:1 \
  --desired-count 1 \
  --launch-type EC2 \
  --region ap-northeast-2
