# Grafana

- Telegraf: 데이터를 수집하는 에이전트로, CPU 사용량, 메모리 등 다양한 시스템 정보를 수집해 Prometheus로 전송.
- Prometheus: 데이터를 저장하고 관리. Telegraf가 보낸 데이터를 주기적으로 가져와 저장.
- Grafana: 시각화 도구로. Prometheus에 저장된 데이터를 기반으로 대시보드를 만들고 실시간으로 모니터링 제공.

<br>

## Telegraf

Telegraf는 플러그인(Plugin) 기반으로 동작하는 데이터 수집 에이전트이다.

서버의 메트릭 정보와 더불어 데이터베이스 상태, 웹 서버 상태 등의 정보를 수집한다.

또한 플러그인 기반 구조 덕분에 일정 주기에 따라 스크립트(input.exec)를 실행하도록 할 수 있다.

현재 도커 상태 정보(check_docker.sh)와 SSL 인증서 정보(check_cert.sh)를 수집한다.

```yml
[agent]
  interval = "15s"  # 15초 간격으로 데이터 수집
  round_interval = true
  collection_jitter = "0s"
  debug = false

[[inputs.system]]   # 시스템 정보 수집

...

[[inputs.docker]]   # 기본 도커 정보 수집
  endpoint = "unix:///var/run/docker.sock"
  container_name_include  = []
  storage_objects = ["container", "volume"]
  perdevice_include = ["cpu", "blkio", "network"]
  total_include = ["cpu", "blkio", "network"]
  timeout = "5s"
  gather_services = false

[[inputs.exec]]     # check_docker.sh 스크립트 수행
  commands = ["/app/check_docker.sh"]   
  timeout = "5s"    # 시도할 시간 (5초 초과할 경우 실패로 취급))
  data_format = "prometheus"

...

```

이 외 추가 스크립트 실행이 필요할 경우, 해당 스크립트를 작성하여 `/compose/telegraf/scripts/` 에 추가한 뒤 `telegraf.conf`에 해당 스크립트를 추가하여야 한다.

### Telegraf 실행

Telegraf는 데이터를 수집하여 모니터링하고자 하는 서버마다 실행되어야 하며,   

하기 명령어를 통해 실행할 수 있다.

```sh
sh restart_monitor          # 도커 재시작
sh restart_monitor build    # 도커 이미지 재빌드
```

<br>

## Monitor

모니터 서버는 Prometheus + Grafana로 구성되어 있다.

Prometheus가 각 Telegraf의 데이터를 수집하고 이를 Grafana를 통해 시각화하는 구조이다.

Telegraf에서 Prometheus로 데이터를 보내는 것이 아닌,   
Prometheus가 Telegraf로 API 요청을 보내 수집하는 방식이다.

```yml
global:
  scrape_interval: 15s      # 데이터 수집 간격
  evaluation_interval: 15s

alerting:
  alertmanagers:
  - scheme: http
    static_configs:
    - targets:
      - "alertmanager:9093"

scrape_configs:
  - job_name: 'telegraf'
    scrape_interval: 5s
    static_configs:
      - targets:    # 데이터를 수집할 서버
        - '192.168.1.157:9273'
        - '192.168.1.158:9273'
```

### Monitor 실행

하기 명령어를 통해 실행할 수 있다.

```sh
sh restart_monitor          # 도커 재시작
sh restart_monitor build    # 도커 이미지 빌드