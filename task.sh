# zsh task.sh  で実行（"channel access token"を自分のものに書き換える
curl -v -X POST https://api.line.me/v2/bot/message/broadcast -H 'Content-Type: application/json' -H 'Authorization: Bearer {channel access token}' -d '{"messages":[{"type":"text","text":"Hello, world"}]}'
