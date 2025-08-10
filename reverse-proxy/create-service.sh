aws ecs create-service \
  --cluster sight-cluster \
  --service-name sight-reverse-proxy \
  --task-definition sight-reverse-proxy:1 \
  --desired-count 1 \
  --launch-type EC2 \
  --region ap-northeast-2
