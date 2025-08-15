aws ecs create-service \
  --cluster sight-cluster \
  --service-name sight-laravel-backend \
  --task-definition sight-laravel-backend:1 \
  --desired-count 1 \
  --launch-type EC2 \
  --region ap-northeast-2
