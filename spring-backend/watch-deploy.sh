#!/bin/bash

CLUSTER="sight-cluster"
SERVICE="sight-spring-backend"
REGION="ap-northeast-2"
POLL_INTERVAL=10
POLL_COUNT=0

while true; do
  POLL_COUNT=$((POLL_COUNT + 1))
  clear

  echo "=== ECS 배포 상태 모니터링 ==="
  echo "클러스터: $CLUSTER | 서비스: $SERVICE"
  echo "폴링 횟수: $POLL_COUNT | $(date '+%Y-%m-%d %H:%M:%S')"
  echo ""

  # describe-services로 상태 조회
  SERVICE_JSON=$(aws ecs describe-services \
    --cluster "$CLUSTER" \
    --services "$SERVICE" \
    --region "$REGION" \
    --query 'services[0]' \
    --output json 2>&1)

  if [ $? -ne 0 ]; then
    echo "❌ AWS API 호출 실패: $SERVICE_JSON"
    sleep $POLL_INTERVAL
    continue
  fi

  # jq로 정보 추출 및 출력
  echo "$SERVICE_JSON" | jq -r '
    "【현재 상태】",
    "  Running: \(.runningCount) | Pending: \(.pendingCount) | Desired: \(.desiredCount)",
    "",
    "【배포 목록】",
    (.deployments[] |
      "  [\(.status)] \(.taskDefinition | split("/")[-1])",
      "    상태: \(.rolloutState // "N/A")",
      "    생성: \(.createdAt)",
      "    업데이트: \(.updatedAt)",
      "    Running: \(.runningCount) / Desired: \(.desiredCount)",
      ""
    )
  '

  # PRIMARY 배포가 COMPLETED인지 확인
  ROLLOUT_STATE=$(echo "$SERVICE_JSON" | jq -r '.deployments[] | select(.status == "PRIMARY") | .rolloutState')

  if [ "$ROLLOUT_STATE" = "COMPLETED" ]; then
    echo "✅ 배포 완료!"
    exit 0
  fi

  echo "⏳ ${POLL_INTERVAL}초 후 재확인..."
  sleep $POLL_INTERVAL
done
