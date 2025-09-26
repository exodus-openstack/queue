# 보안/네거티브 테스트 케이스

## 인증/JWT
- SEC-001 만료 Access Token 접근 → 401
- SEC-002 위조 토큰(서명 불일치) → 401
- SEC-003 Refresh 재사용 공격 → 401 및 토큰 폐기

## 권한/등급
- SEC-101 ADMIN 전용 엔드포인트 일반 권한 접근 → 403
- SEC-102 VIP 전용 처리 우회 시도 → 우선순위 미상승 확인

## Rate Limiting
- SEC-201 일반 사용자 100rps 초과 → 429
- SEC-202 VIP 200rps 초과 → 429

## 입력검증/오류 노출
- SEC-301 SQL/NoSQL 인젝션 페이로드 → 차단/정상 오류 포맷
- SEC-302 이메일/비밀번호 규칙 위반 → VALIDATION_ERROR

## 전송/구성
- SEC-401 HTTPS 강제 (443) 미사용 시 정책 확인
- SEC-402 프록시 헤더(User-Agent/X-Forwarded-For) 누락 시 처리 안전성

## MQTT
- SEC-501 권한 없는 토픽 구독/발행 차단
- SEC-502 MQTT 연결 끊김/재연결 시 세션/이벤트 이탈 없음

## 관측성/로그
- SEC-601 민감정보 로그 노출 금지(토큰/비밀번호)
- SEC-602 상관관계ID로 추적 가능
