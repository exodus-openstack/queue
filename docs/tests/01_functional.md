# 기능 테스트 케이스 (Auth + Queue)

## 1. 회원가입/중복 체크

- TC-F-001 회원가입 중복체크 성공
  - 전제: id/username/email 미사용
  - 액션: POST /auth/check-duplicates
  - 입력: {id, username, email}
  - 기대: 200, success=true, message="모든 필드가 사용 가능합니다"

- TC-F-002 아이디 중복
  - 전제: 동일 id 존재
  - 액션: POST /auth/check-duplicates
  - 기대: 400, success=false, message 포함 "아이디"

- TC-F-003 사용자명 중복, TC-F-004 이메일 중복, TC-F-005 이메일 형식 오류

- TC-F-006 회원가입 성공
  - 액션: POST /auth/register
  - 입력: {id, username, password(강함), email, gradeCode(유효)}
  - 기대: 201, success=true, data.userId 존재

- TC-F-007 약한 비밀번호
  - 기대: 400, error="WEAK_PASSWORD"

- TC-F-008 등급 코드 무효/만료/사용됨
  - 기대: 400, error in [INVALID_GRADE_CODE, EXPIRED_GRADE_CODE, USED_GRADE_CODE]

## 2. 로그인/토큰

- TC-F-101 로그인 성공
  - 액션: POST /auth/login
  - 기대: 200 또는 202(큐 진입), success=true

- TC-F-102 로그인 실패(잘못된 비밀번호)
  - 기대: 400, message="인증 실패"

- TC-F-103 토큰 갱신 성공/만료
  - 액션: POST /auth/refresh
  - 기대(성공): 200, accessToken/refreshToken 재발급
  - 기대(실패): 401, message="토큰이 만료되었습니다"

- TC-F-104 로그아웃
  - 액션: POST /auth/logout
  - 기대: 200, success=true, Redis 세션 삭제

## 3. 큐 진입/대기/퇴장

- TC-F-201 ADMIN 직행
  - 전제: role=ADMIN
  - 기대: 큐 거치지 않고 토큰 즉시 발급

- TC-F-202 VIP/PREMIUM/NORMAL 우선순위
  - 액션: /api/queue/join
  - 기대: Redis ZADD score 우선순위*1e9+timestamp 정렬 확인

- TC-F-203 기존 세션 유지(hasExistingSession=true)
  - 기대: 기존 tid 유지, 바로 토큰 발급

- TC-F-204 만료 후 재접속(10분 초과)
  - 기대: 신규 큐 입장, 상태 PENDING

- TC-F-205 같은 클라이언트 재접속
  - 기대: 위치 유지, clientId 동일

- TC-F-206 다른 클라이언트 접속(기존 튕김)
  - 기대: MQTT cancelled 발행, 기존 클라이언트 취소 이벤트 수신

- TC-F-207 READY 전환 및 finalize
  - 절차: status 업데이트 → MQTT ready 수신 → POST /auth/finalize
  - 기대: access/refresh 토큰 발급, 큐 제거

## 4. 상태 업데이트(폴링/SSE/MQTT)

- TC-F-301 SSE 폴링 주기 준수(5~30초)
  - 기대: 상태 변경 시에만 이벤트 전송

- TC-F-302 MQTT status/ready payload 스키마
  - 기대: {position, estimatedWaitSec, totalWaiting} 필드 확인

## 5. 에러/Rate Limit

- TC-F-401 Rate Limit 초과(역할별)
  - 기대: 429, 재시도 헤더 존재

- TC-F-402 공통 에러 포맷
  - 기대: {success:false, message, error|errors[], timestamp}

## 6. 데이터 정합성

- TC-F-501 Redis 키 일관성
  - 기대: user:{userId}, ticket:{tid}, queue:{queueType} 정합성

- TC-F-502 MariaDB 사용자 스키마 일치
  - 기대: 회원가입 후 DB 레코드 필드 검증

---

부록 A. 사전 조건/테스트 데이터
- 유효/만료/사용됨 등급 코드 세트
- 사용자 더미 1k (VIP 5%, PREMIUM 15%, NORMAL 80%)

부록 B. 증거 수집 체크리스트
- 요청/응답 로그, Redis 명령 로그(ZADD/ZRANK), MQTT 캡처, 스크린샷


