# Telegraf 기반 이미지
FROM telegraf:1.31.3

# Docker CLI 설치
RUN apt-get update && apt-get install -y docker.io

# docker 명령어를 PATH에 추가
RUN ln -s /usr/bin/docker /usr/local/bin/docker

# Telegraf를 root 사용자로 실행 (필요한 경우)
USER root

# 환경 변수 설정
ENV DOCKER_HOST=unix:///var/run/docker.sock
