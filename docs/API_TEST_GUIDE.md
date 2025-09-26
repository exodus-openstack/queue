# API 테스트 가이드

이 문서는 큐 시스템의 API 테스트 방법을 설명합니다.

## 테스트 환경 설정

### 1. 디렉토리 이동
```bash
cd queue-infra/api-test
```

### 2. 의존성 설치
```bash
npm install
```

## 테스트 시나리오

### 시나리오 1: 대규모 로드 테스트 (K6)

**목적**: MQTT 대기 없이 회원가입 후 로그인으로 대기열을 여러 명 쌓기 위한 테스트

**명령어**:
```bash
k6 run --vus 100 --duration 30m queue-login-dev-test-grade.js
```

**설명**:
- `--vus 100`: 100개의 가상 사용자로 동시 테스트
- `--duration 30m`: 30분간 지속적인 테스트
- `queue-login-dev-test-grade.js`: 등급 기반 회원가입 및 로그인 테스트 스크립트

**테스트 내용**:
- 랜덤한 등급 코드 선택 (NORMAL, VIP, PREMIUM, ADMIN)
- 등급 코드 검증
- 회원가입
- 로그인 시도
- 대기열 진입

**예상 결과**:
- 대량의 사용자가 대기열에 쌓임
- 시스템 부하 테스트
- 등급별 우선순위 처리 확인

### 시나리오 2: 단일 사용자 통합 테스트 (Node.js)

**목적**: 한 건의 회원가입 후 로그인 테스트를 통해 MQTT로 결과 대기까지 하는 통합 테스트

**명령어**:
```bash
node .\queue-login-dev-test.js
```

**설명**:
- 단일 사용자로 전체 플로우 테스트
- MQTT 메시지 수신 대기
- 실제 사용자 경험 시뮬레이션

**테스트 내용**:
1. 회원가입
2. 로그인 시도
3. 대기열 진입
4. MQTT 메시지 수신 대기
5. READY 상태 확인
6. 최종 로그인 완료

**예상 결과**:
- 전체 플로우 정상 동작 확인
- MQTT 메시지 수신 확인
- 대기열 상태 변화 모니터링

## 테스트 전 준비사항

### 1. 서비스 상태 확인
- queue-backend 서비스 실행 중
- queue-login 서비스 실행 중
- MQTT 브로커 실행 중
- Redis 서버 실행 중

### 2. 네트워크 설정 확인
- 테스트 대상 서버 주소 확인
- 포트 접근 가능 여부 확인
- TLS 인증서 설정 확인

### 3. 테스트 데이터 준비
- 유효한 등급 코드 확인
- 테스트용 사용자 데이터 준비

## 테스트 결과 분석

### K6 테스트 결과
- **VU (Virtual Users)**: 가상 사용자 수
- **RPS (Requests Per Second)**: 초당 요청 수
- **Response Time**: 응답 시간
- **Error Rate**: 오류율
- **Throughput**: 처리량

### Node.js 테스트 결과
- **회원가입 성공률**: 회원가입 성공 비율
- **로그인 성공률**: 로그인 성공 비율
- **대기열 진입 시간**: 대기열 진입까지 소요 시간
- **MQTT 수신 시간**: MQTT 메시지 수신까지 소요 시간
- **전체 처리 시간**: 회원가입부터 로그인 완료까지 총 소요 시간

## 문제 해결

### 일반적인 문제
1. **연결 오류**: 서비스 상태 및 네트워크 설정 확인
2. **인증 오류**: TLS 인증서 및 인증 정보 확인
3. **타임아웃 오류**: 서비스 응답 시간 및 네트워크 지연 확인
4. **MQTT 수신 실패**: MQTT 브로커 상태 및 구독 설정 확인

### 로그 확인
```bash
# K6 테스트 로그
k6 run --vus 10 --duration 1m queue-login-dev-test-grade.js --log-output=file=test.log

# Node.js 테스트 로그
node .\queue-login-dev-test.js > test.log 2>&1
```

## 추가 테스트 옵션

### K6 고급 옵션
```bash
# 단계별 부하 증가
k6 run --stage 30s:10,1m:50,2m:100,30s:0 queue-login-dev-test-grade.js

# 특정 등급만 테스트
k6 run --vus 50 --duration 10m -e GRADE_FILTER=VIP queue-login-dev-test-grade.js

# 결과를 JSON으로 출력
k6 run --vus 10 --duration 1m --out json=results.json queue-login-dev-test-grade.js
```

### Node.js 디버그 모드
```bash
# 상세 로그 출력
DEBUG=* node .\queue-login-dev-test.js

# 특정 등급으로 테스트
GRADE_CODE=VIP node .\queue-login-dev-test.js
```

## 성능 기준

### K6 테스트 기준
- **응답 시간**: 95% 요청이 2초 이내
- **오류율**: 1% 미만
- **처리량**: 초당 50회 이상

### Node.js 테스트 기준
- **회원가입**: 5초 이내
- **로그인**: 10초 이내
- **MQTT 수신**: 30초 이내
- **전체 처리**: 60초 이내

## 주의사항

1. **테스트 환경**: 프로덕션 환경에서 테스트하지 마세요
2. **리소스 사용량**: 대규모 테스트 시 시스템 리소스 모니터링
3. **데이터 정리**: 테스트 후 생성된 데이터 정리
4. **동시 실행**: 여러 테스트를 동시에 실행하지 마세요
5. **네트워크 대역폭**: 테스트 시 네트워크 대역폭 고려
