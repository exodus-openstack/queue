# 🔌 API 문서 인덱스

## 📋 개요

Queue 시스템의 API는 마이크로서비스별로 분리되어 있으며, 각 서비스의 상세 API 명세는 해당 프로젝트에서 관리됩니다.

## 🔗 서비스별 API 문서

### 🔐 인증 및 사용자 관리 (queue-login)
**담당자**: 차장님  
**문서 위치**: [queue-login/API.md](https://github.com/exodus-openstack/queue-login/blob/develop/API.md)

- 사용자 회원가입/로그인/로그아웃
- **개별 필드 실시간 검증** (아이디, 사용자명, 이메일, 비밀번호)
- **등급 코드 검증** (ADMIN, VIP, PREMIUM 등급 인증)
- JWT 토큰 관리
- 사용자 프로필 관리
- 세션 관리

#### 회원가입 API
- **POST** `/api/auth/register` - 회원가입 (중복 검사 포함)
- **POST** `/api/auth/validate-grade-code` - 등급 코드 검증

**회원가입 요청 형식:**
```json
{
  "id": "string",
  "username": "string",
  "email": "string", 
  "password": "string",
  "gradeCode": "string"
}
```

**회원가입 응답 형식:**
```json
{
  "success": true,
  "message": "회원가입이 완료되었습니다",
  "data": {
    "userId": "string",
    "username": "string",
    "email": "string",
    "role": "VIP",
    "rateLimit": 200,
    "createdAt": "2024-12-18T10:00:00Z"
  }
}
```

### 🎯 큐 시스템 관리 (queue-backend)
**담당자**: 과장님  
**문서 위치**: [queue-backend/API.md](https://github.com/exodus-openstack/queue-backend/blob/develop/API.md)

- 로그인 큐 시스템
- 게임 큐 시스템  
- 랭킹 큐 시스템
- 포털 큐 시스템
- 통합 큐 관리

---

## 📊 공통 응답 형식

### 성공 응답
```json
{
  "success": true,
  "message": "string",
  "data": "object",
  "timestamp": "2024-12-18T10:00:00Z"
}
```

### 에러 응답
```json
{
  "success": false,
  "message": "string",
  "error": "string",
  "errors": [
    {
      "field": "string",
      "message": "string"
    }
  ],
  "timestamp": "2024-12-18T10:00:00Z"
}
```

---

## 🔐 인증 및 권한

### JWT 토큰
- **Access Token**: 15분 만료
- **Refresh Token**: 7일 만료
- **Algorithm**: HS256
- **Header**: `Authorization: Bearer {token}`

### 권한 레벨
- **ADMIN**: 모든 API 접근 가능
- **VIP**: 우선순위 높은 큐 접근
- **PREMIUM**: 일반 큐 접근
- **NORMAL**: 기본 큐 접근

### Rate Limiting
- **일반 사용자**: 초당 100회 요청
- **VIP 사용자**: 초당 200회 요청
- **관리자**: 초당 500회 요청

---

## 📝 에러 코드

### HTTP 상태 코드
- `200 OK`: 성공
- `201 Created`: 생성 성공
- `202 Accepted`: 요청 수락
- `400 Bad Request`: 잘못된 요청
- `401 Unauthorized`: 인증 실패
- `403 Forbidden`: 권한 없음
- `404 Not Found`: 리소스 없음
- `409 Conflict`: 충돌
- `413 Payload Too Large`: 페이로드 초과
- `429 Too Many Requests`: 요청 제한 초과
- `500 Internal Server Error`: 서버 오류

### 비즈니스 에러 코드
- `USERNAME_EXISTS`: 사용자명 중복
- `EMAIL_EXISTS`: 이메일 중복
- `INVALID_CREDENTIALS`: 인증 정보 오류
- `TOKEN_EXPIRED`: 토큰 만료
- `ACCOUNT_LOCKED`: 계정 잠김
- `QUEUE_FULL`: 큐 가득참
- `ALREADY_IN_QUEUE`: 이미 큐에 있음
- `INVALID_SCORE`: 잘못된 점수
- `MATCH_NOT_FOUND`: 매칭 없음
- `TASK_NOT_FOUND`: 작업 없음

### 회원가입 관련 에러 코드
- `ID_EXISTS`: 아이디 중복
- `INVALID_EMAIL_FORMAT`: 이메일 형식 오류
- `WEAK_PASSWORD`: 비밀번호 강도 부족
- `PASSWORD_MISMATCH`: 비밀번호 불일치
- `INVALID_GRADE_CODE`: 잘못된 등급 코드
- `EXPIRED_GRADE_CODE`: 만료된 등급 코드
- `USED_GRADE_CODE`: 이미 사용된 등급 코드
- `GRADE_CODE_NOT_FOUND`: 등급 코드를 찾을 수 없음
- `GRADE_CODE_FORMAT_ERROR`: 등급 코드 형식 오류
- `VALIDATION_ERROR`: 입력값 검증 실패

---

## 🔧 개발 도구

### API 테스트
- **Postman Collection**: API 테스트 컬렉션
- **Swagger UI**: API 문서 및 테스트
- **Insomnia**: REST 클라이언트

### 모니터링
- **Prometheus**: 메트릭 수집
- **Grafana**: 대시보드
- **Jaeger**: 분산 추적

### 로깅
- **ELK Stack**: 로그 수집 및 분석
- **Fluentd**: 로그 전송
- **Kibana**: 로그 시각화
