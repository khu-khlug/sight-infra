aws ecs create-service \
  --cluster sight-cluster \
  --service-name sight-spring-backend \
  --task-definition sight-spring-backend:1 \
  --desired-count 1 \
  --launch-type EC2 \
  --region ap-northeast-2
