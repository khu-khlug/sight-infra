#!/bin/bash

aws ecs update-service \
  --cluster sight-cluster \
  --service sight-spring-backend \
  --task-definition sight-spring-backend \
  --region ap-northeast-2
