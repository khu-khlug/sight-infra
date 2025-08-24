SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

aws ecs register-task-definition \
  --cli-input-json file://$SCRIPT_DIR/task-definition.json \
  --region ap-northeast-2
