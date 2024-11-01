#!/bin/bash

# 호스트 주소와 포트를 설정 (HTTPS 기본 포트 443 사용)
SERVER="host.docker.internal"
PORT=443

# 호스트 서버의 인증서 만료 일자를 조회하고 Prometheus 형식으로 출력
expiry_date=$(
    echo | openssl s_client -servername $SERVER -connect $SERVER:$PORT 2>/dev/null | \
    openssl x509 -noout -enddate | cut -d= -f2
)

# 만료 일자를 Unix 타임스탬프로 변환
expiry_timestamp=$(date -d "$expiry_date" +%s)

# 현재 시간의 Unix 타임스탬프
current_timestamp=$(date +%s)

# 만료일까지 남은 일수 계산
days_remaining=$(( (expiry_timestamp - current_timestamp) / 86400 ))

# Prometheus 형식으로 출력
echo "# HELP ssl_certificate_expiry_days Days until SSL certificate expires"
echo "# TYPE ssl_certificate_expiry_days gauge"
echo "ssl_certificate_expiry_days{server=\"$SERVER\"} $days_remaining"
