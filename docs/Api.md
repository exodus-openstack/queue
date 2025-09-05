# 🔌 API 문서

## 📋 목차

### 1. 인증 및 사용자 관리

#### Phase 1: 기본 인증 시스템 (현재)
- [1.1 사용자 회원가입](#11-사용자-회원가입)
- [1.2 사용자 로그인](#12-사용자-로그인)
- [1.3 토큰 갱신](#13-토큰-갱신)
- [1.4 사용자 로그아웃](#14-사용자-로그아웃)

#### Phase 2: IAM 기반 고급 시스템 (추후)
- [1.5 IAM 기반 사용자 회원가입](#15-iam-기반-사용자-회원가입)
- [1.6 IAM 기반 사용자 로그인](#16-iam-기반-사용자-로그인)
- [1.7 IAM 토큰 갱신](#17-iam-토큰-갱신)
- [1.8 IAM 기반 사용자 로그아웃](#18-iam-기반-사용자-로그아웃)
- [1.9 IAM 그룹 관리](#19-iam-그룹-관리)
- [1.10 IAM 정책 관리](#110-iam-정책-관리)
- [1.11 IAM 권한 검증](#111-iam-권한-검증)

### 2. 로그인 큐 시스템
- [2.1 로그인 큐 진입](#21-로그인-큐-진입)
- [2.2 로그인 큐 상태 조회](#22-로그인-큐-상태-조회)
- [2.3 로그인 큐 처리](#23-로그인-큐-처리)
- [2.4 로그인 큐 퇴장](#24-로그인-큐-퇴장)

### 3. 게임 큐 시스템
- [3.1 게임 매칭 요청](#31-게임-매칭-요청)
- [3.2 게임 매칭 상태 조회](#32-게임-매칭-상태-조회)
- [3.3 게임 매칭 완료](#33-게임-매칭-완료)
- [3.4 게임 매칭 취소](#34-게임-매칭-취소)

### 4. 랭킹 큐 시스템
- [4.1 점수 제출](#41-점수-제출)
- [4.2 랭킹 조회](#42-랭킹-조회)
- [4.3 친구 랭킹 조회](#43-친구-랭킹-조회)
- [4.4 랭킹 업데이트 알림](#44-랭킹-업데이트-알림)

### 5. 포털 큐 시스템
- [5.1 파일 업로드 요청](#51-파일-업로드-요청)
- [5.2 데이터 처리 요청](#52-데이터-처리-요청)
- [5.3 알림 발송 요청](#53-알림-발송-요청)
- [5.4 작업 상태 조회](#54-작업-상태-조회)

### 6. 통합 큐 관리
- [6.1 큐 간 연동](#61-큐-간-연동)
- [6.2 우선순위 관리](#62-우선순위-관리)
- [6.3 부하 분산](#63-부하-분산)
- [6.4 모니터링 및 알림](#64-모니터링-및-알림)

---

## 1. 인증 및 사용자 관리

### Phase 1: 기본 인증 시스템 (현재)

#### 1.1 사용자 회원가입

#### POST /api/auth/register
사용자 회원가입을 처리합니다.

**Request Body:**
```json
{
  "username": "string",
  "password": "string",
  "email": "string",
  "nickname": "string"
}
```

**Request Headers:**
```
Content-Type: application/json
```

**Response Codes:**
- `201 Created`: 회원가입 성공
- `400 Bad Request`: 잘못된 요청 데이터
- `409 Conflict`: 사용자명 또는 이메일 중복

**Response Body (201):**
```json
{
  "success": true,
  "message": "회원가입이 완료되었습니다.",
  "data": {
    "userId": "user123",
    "username": "user123",
    "email": "user@example.com",
    "nickname": "닉네임",
    "role": "NORMAL",
    "status": "ACTIVE",
    "createdAt": "2024-12-18T10:00:00Z"
  }
}
```

**Response Body (400):**
```json
{
  "success": false,
  "message": "잘못된 요청 데이터입니다.",
  "errors": [
    {
      "field": "password",
      "message": "비밀번호는 8자 이상이어야 합니다."
    }
  ]
}
```

**Response Body (409):**
```json
{
  "success": false,
  "message": "이미 사용 중인 사용자명입니다.",
  "error": "USERNAME_EXISTS"
}
```

#### 1.2 사용자 로그인

#### POST /api/auth/login
사용자 로그인을 처리합니다.

**Request Body:**
```json
{
  "username": "string",
  "password": "string"
}
```

**Request Headers:**
```
Content-Type: application/json
```

**Response Codes:**
- `200 OK`: 로그인 성공
- `401 Unauthorized`: 인증 실패
- `423 Locked`: 계정 잠김

**Response Body (200):**
```json
{
  "success": true,
  "message": "로그인이 완료되었습니다.",
  "data": {
    "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "expiresIn": 900,
    "user": {
      "userId": "user123",
      "username": "user123",
      "email": "user@example.com",
      "nickname": "닉네임",
      "role": "NORMAL",
      "status": "ACTIVE"
    }
  }
}
```

**Response Body (401):**
```json
{
  "success": false,
  "message": "사용자명 또는 비밀번호가 올바르지 않습니다.",
  "error": "INVALID_CREDENTIALS"
}
```

#### 1.3 토큰 갱신

#### POST /api/auth/refresh
JWT 토큰을 갱신합니다.

**Request Body:**
```json
{
  "refreshToken": "string"
}
```

**Request Headers:**
```
Content-Type: application/json
```

**Response Codes:**
- `200 OK`: 토큰 갱신 성공
- `401 Unauthorized`: 토큰 무효

**Response Body (200):**
```json
{
  "success": true,
  "message": "토큰이 갱신되었습니다.",
  "data": {
    "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "expiresIn": 900
  }
}
```

#### 1.4 사용자 로그아웃

#### POST /api/auth/logout
사용자 로그아웃을 처리합니다.

### Phase 2: IAM 기반 고급 시스템 (추후)

#### 1.5 IAM 기반 사용자 회원가입

#### POST /api/auth/register
IAM 시스템을 통한 사용자 회원가입을 처리합니다.

**Request Body:**
```json
{
  "username": "string",
  "password": "string",
  "email": "string",
  "nickname": "string",
  "iamGroups": ["Normal_Users"]
}
```

**Response Codes:**
- `201 Created`: 회원가입 성공
- `400 Bad Request`: 잘못된 요청 데이터
- `409 Conflict`: 사용자명 또는 이메일 중복

**Response Body (201):**
```json
{
  "success": true,
  "message": "IAM 회원가입이 완료되었습니다.",
  "userId": "사용자ID",
  "username": "사용자명",
  "iamGroups": ["Normal_Users"],
  "iamPolicies": ["basic_access"]
}
```

#### 1.6 IAM 기반 사용자 로그인

#### POST /api/auth/login
IAM 시스템을 통한 사용자 로그인을 처리합니다.

**Request Body:**
```json
{
  "username": "string",
  "password": "string"
}
```

**Response Codes:**
- `200 OK`: 로그인 성공
- `401 Unauthorized`: 인증 실패
- `403 Forbidden`: 계정 잠금

**Response Body (200):**
```json
{
  "success": true,
  "message": "IAM 로그인 성공",
  "token": "IAM_JWT_액세스_토큰",
  "username": "사용자명",
  "iamGroups": ["VIP_Users"],
  "iamPolicies": ["queue_priority", "game_early_access"]
}
```

#### 1.7 IAM 토큰 갱신

#### POST /api/auth/refresh
IAM 토큰을 갱신합니다.

**Request Body:**
```json
{
  "refreshToken": "IAM_리프레시_토큰"
}
```

**Response Codes:**
- `200 OK`: 토큰 갱신 성공
- `401 Unauthorized`: 토큰 무효

**Response Body (200):**
```json
{
  "success": true,
  "message": "IAM 토큰 갱신 성공",
  "token": "새로운_IAM_JWT_액세스_토큰"
}
```

#### 1.8 IAM 기반 사용자 로그아웃

#### POST /api/auth/logout
IAM 시스템을 통한 사용자 로그아웃을 처리합니다.

**Request Headers:**
```
Authorization: Bearer IAM_JWT_토큰
```

**Response Codes:**
- `200 OK`: 로그아웃 성공
- `401 Unauthorized`: 인증 실패

**Response Body (200):**
```json
{
  "success": true,
  "message": "IAM 로그아웃 성공"
}
```

#### 1.9 IAM 그룹 관리

#### GET /api/iam/groups
IAM 그룹 목록을 조회합니다.

**Request Headers:**
```
Authorization: Bearer {accessToken}
```

**Response Codes:**
- `200 OK`: 그룹 목록 조회 성공
- `401 Unauthorized`: 인증 실패

**Response Body (200):**
```json
{
  "success": true,
  "data": {
    "groups": [
      {
        "groupId": "group123",
        "groupName": "VIP Users",
        "description": "VIP 사용자 그룹",
        "memberCount": 150,
        "permissions": ["queue_priority", "game_early_access"]
      },
      {
        "groupId": "group456",
        "groupName": "Premium Users",
        "description": "프리미엄 사용자 그룹",
        "memberCount": 500,
        "permissions": ["queue_priority"]
      }
    ]
  }
}
```

#### 1.10 IAM 정책 관리

#### GET /api/iam/policies
IAM 정책 목록을 조회합니다.

**Request Headers:**
```
Authorization: Bearer {accessToken}
```

**Response Codes:**
- `200 OK`: 정책 목록 조회 성공
- `401 Unauthorized`: 인증 실패

**Response Body (200):**
```json
{
  "success": true,
  "data": {
    "policies": [
      {
        "policyId": "policy123",
        "policyName": "Queue Access Policy",
        "description": "큐 접근 정책",
        "rules": [
          {
            "action": "queue:join",
            "resource": "queue:login",
            "condition": "user.role == 'VIP'"
          }
        ]
      }
    ]
  }
}
```

#### 1.11 IAM 권한 검증

#### POST /api/iam/check-permission
사용자의 특정 권한을 검증합니다.

**Request Body:**
```json
{
  "action": "string",
  "resource": "string",
  "context": {
    "queueType": "string",
    "userId": "string"
  }
}
```

**Request Headers:**
```
Content-Type: application/json
Authorization: Bearer {accessToken}
```

**Response Codes:**
- `200 OK`: 권한 검증 완료
- `401 Unauthorized`: 인증 실패
- `403 Forbidden`: 권한 없음

**Response Body (200):**
```json
{
  "success": true,
  "data": {
    "allowed": true,
    "reason": "User has VIP role with queue priority access",
    "policyMatched": "policy123"
  }
}
```

**Request Body:**
```json
{
  "refreshToken": "string"
}
```

**Request Headers:**
```
Content-Type: application/json
Authorization: Bearer {accessToken}
```

**Response Codes:**
- `200 OK`: 로그아웃 성공
- `401 Unauthorized`: 인증 실패

**Response Body (200):**
```json
{
  "success": true,
  "message": "로그아웃이 완료되었습니다."
}
```

---

## 2. 로그인 큐 시스템

### 2.1 로그인 큐 진입

#### POST /api/queue/login/join
로그인 큐에 진입합니다.

**Request Body:**
```json
{
  "userId": "string",
  "priority": "VIP" | "PREMIUM" | "NORMAL" | "ADMIN"
}
```

**Request Headers:**
```
Content-Type: application/json
Authorization: Bearer {accessToken}
```

**Response Codes:**
- `200 OK`: 큐 진입 성공
- `400 Bad Request`: 잘못된 요청
- `401 Unauthorized`: 인증 실패
- `409 Conflict`: 이미 큐에 있음

**Response Body (200):**
```json
{
  "success": true,
  "message": "큐에 진입했습니다.",
  "data": {
    "position": 150,
    "estimatedWaitTime": 30,
    "totalWaiting": 5000,
    "processingRate": 100,
    "priority": "NORMAL"
  }
}
```

### 2.2 로그인 큐 상태 조회

#### GET /api/queue/login/status/{userId}
로그인 큐 상태를 조회합니다.

**Path Parameters:**
- `userId` (string): 사용자 ID

**Request Headers:**
```
Authorization: Bearer {accessToken}
```

**Response Codes:**
- `200 OK`: 상태 조회 성공
- `401 Unauthorized`: 인증 실패
- `404 Not Found`: 큐에 없음

**Response Body (200):**
```json
{
  "success": true,
  "data": {
    "position": 150,
    "estimatedWaitTime": 30,
    "totalWaiting": 5000,
    "processingRate": 100,
    "priority": "NORMAL",
    "joinedAt": "2024-12-18T10:00:00Z"
  }
}
```

### 2.3 로그인 큐 처리

#### GET /api/queue/login/process
다음 사용자를 처리합니다. (내부 API)

**Request Headers:**
```
Authorization: Bearer {serviceToken}
```

**Response Codes:**
- `200 OK`: 처리 성공
- `204 No Content`: 처리할 사용자 없음

**Response Body (200):**
```json
{
  "success": true,
  "data": {
    "userId": "user123",
    "processedAt": "2024-12-18T10:00:00Z",
    "nextPosition": 149
  }
}
```

### 2.4 로그인 큐 퇴장

#### DELETE /api/queue/login/leave/{userId}
로그인 큐에서 퇴장합니다.

**Path Parameters:**
- `userId` (string): 사용자 ID

**Request Headers:**
```
Authorization: Bearer {accessToken}
```

**Response Codes:**
- `200 OK`: 퇴장 성공
- `401 Unauthorized`: 인증 실패
- `404 Not Found`: 큐에 없음

**Response Body (200):**
```json
{
  "success": true,
  "message": "큐에서 퇴장했습니다."
}
```

---

## 3. 게임 큐 시스템

### 3.1 게임 매칭 요청

#### POST /api/queue/game/match
게임 매칭을 요청합니다.

**Request Body:**
```json
{
  "userId": "string",
  "difficulty": "easy" | "medium" | "hard" | "expert",
  "level": "number",
  "preferences": {
    "region": "string",
    "maxWaitTime": "number",
    "gameMode": "string"
  }
}
```

**Request Headers:**
```
Content-Type: application/json
Authorization: Bearer {accessToken}
```

**Response Codes:**
- `200 OK`: 매칭 성공
- `202 Accepted`: 매칭 대기
- `400 Bad Request`: 잘못된 요청
- `401 Unauthorized`: 인증 실패

**Response Body (200):**
```json
{
  "success": true,
  "message": "매칭이 완료되었습니다.",
  "data": {
    "gameSessionId": "session123",
    "matchedUsers": ["user456", "user789"],
    "difficulty": "medium",
    "level": 5,
    "startTime": "2024-12-18T10:00:00Z"
  }
}
```

**Response Body (202):**
```json
{
  "success": true,
  "message": "매칭을 기다리는 중입니다.",
  "data": {
    "estimatedMatchTime": 30,
    "currentWaitTime": 0,
    "difficulty": "medium",
    "level": 5
  }
}
```

### 3.2 게임 매칭 상태 조회

#### GET /api/queue/game/status/{userId}
게임 매칭 상태를 조회합니다.

**Path Parameters:**
- `userId` (string): 사용자 ID

**Request Headers:**
```
Authorization: Bearer {accessToken}
```

**Response Codes:**
- `200 OK`: 상태 조회 성공
- `401 Unauthorized`: 인증 실패
- `404 Not Found`: 매칭 요청 없음

**Response Body (200):**
```json
{
  "success": true,
  "data": {
    "status": "matching" | "matched" | "cancelled",
    "waitTime": 15,
    "estimatedMatchTime": 10,
    "difficulty": "medium",
    "level": 5,
    "matchedUsers": ["user456", "user789"],
    "gameSessionId": "session123"
  }
}
```

### 3.3 게임 매칭 완료

#### POST /api/queue/game/complete
게임 매칭을 완료합니다. (내부 API)

**Request Body:**
```json
{
  "userId": "string",
  "gameSessionId": "string",
  "matchedUsers": ["string"],
  "difficulty": "string",
  "level": "number"
}
```

**Request Headers:**
```
Authorization: Bearer {serviceToken}
```

**Response Codes:**
- `200 OK`: 완료 성공
- `400 Bad Request`: 잘못된 요청

**Response Body (200):**
```json
{
  "success": true,
  "data": {
    "gameSessionId": "session123",
    "completedAt": "2024-12-18T10:00:00Z"
  }
}
```

### 3.4 게임 매칭 취소

#### DELETE /api/queue/game/cancel/{userId}
게임 매칭을 취소합니다.

**Path Parameters:**
- `userId` (string): 사용자 ID

**Request Headers:**
```
Authorization: Bearer {accessToken}
```

**Response Codes:**
- `200 OK`: 취소 성공
- `401 Unauthorized`: 인증 실패
- `404 Not Found`: 매칭 요청 없음

**Response Body (200):**
```json
{
  "success": true,
  "message": "매칭이 취소되었습니다."
}
```

---

## 4. 랭킹 큐 시스템

### 4.1 점수 제출

#### POST /api/queue/ranking/submit
게임 점수를 제출합니다.

**Request Body:**
```json
{
  "userId": "string",
  "score": "number",
  "gameType": "string",
  "difficulty": "easy" | "medium" | "hard" | "expert",
  "gameSessionId": "string"
}
```

**Request Headers:**
```
Content-Type: application/json
Authorization: Bearer {accessToken}
```

**Response Codes:**
- `202 Accepted`: 점수 제출 성공
- `400 Bad Request`: 잘못된 요청
- `401 Unauthorized`: 인증 실패

**Response Body (202):**
```json
{
  "success": true,
  "message": "점수가 제출되었습니다.",
  "data": {
    "taskId": "task123",
    "estimatedProcessingTime": 5,
    "submittedAt": "2024-12-18T10:00:00Z"
  }
}
```

### 4.2 랭킹 조회

#### GET /api/queue/ranking/{type}/{period}
랭킹을 조회합니다.

**Path Parameters:**
- `type` (string): 랭킹 타입 (total, daily, weekly, monthly)
- `period` (string): 기간 (YYYYMMDD, YYYY-WW, YYYY-MM)

**Query Parameters:**
- `limit` (number, optional): 조회할 개수 (기본값: 100)
- `offset` (number, optional): 시작 위치 (기본값: 0)

**Request Headers:**
```
Authorization: Bearer {accessToken}
```

**Response Codes:**
- `200 OK`: 랭킹 조회 성공
- `400 Bad Request`: 잘못된 요청
- `401 Unauthorized`: 인증 실패

**Response Body (200):**
```json
{
  "success": true,
  "data": {
    "rankings": [
      {
        "rank": 1,
        "userId": "user456",
        "username": "user456",
        "nickname": "닉네임456",
        "score": 20000,
        "difficulty": "medium",
        "achievedAt": "2024-12-18T10:00:00Z"
      },
      {
        "rank": 2,
        "userId": "user789",
        "username": "user789",
        "nickname": "닉네임789",
        "score": 18000,
        "difficulty": "medium",
        "achievedAt": "2024-12-18T09:30:00Z"
      }
    ],
    "userRank": 15,
    "totalPlayers": 100000,
    "period": "20241218",
    "type": "daily"
  }
}
```

### 4.3 친구 랭킹 조회

#### GET /api/queue/ranking/friends/{userId}
친구 랭킹을 조회합니다.

**Path Parameters:**
- `userId` (string): 사용자 ID

**Request Headers:**
```
Authorization: Bearer {accessToken}
```

**Response Codes:**
- `200 OK`: 친구 랭킹 조회 성공
- `401 Unauthorized`: 인증 실패
- `404 Not Found`: 사용자 없음

**Response Body (200):**
```json
{
  "success": true,
  "data": {
    "friendRankings": [
      {
        "rank": 1,
        "userId": "friend123",
        "username": "friend123",
        "nickname": "친구1",
        "score": 15000,
        "difficulty": "medium"
      },
      {
        "rank": 2,
        "userId": "friend456",
        "username": "friend456",
        "nickname": "친구2",
        "score": 12000,
        "difficulty": "easy"
      }
    ],
    "userRank": 3,
    "totalFriends": 50
  }
}
```

### 4.4 랭킹 업데이트 알림

#### GET /api/queue/ranking/notifications/{userId}
랭킹 업데이트 알림을 조회합니다.

**Path Parameters:**
- `userId` (string): 사용자 ID

**Request Headers:**
```
Authorization: Bearer {accessToken}
```

**Response Codes:**
- `200 OK`: 알림 조회 성공
- `401 Unauthorized`: 인증 실패

**Response Body (200):**
```json
{
  "success": true,
  "data": {
    "notifications": [
      {
        "id": "notif123",
        "type": "RANKING_UPDATE",
        "message": "랭킹이 15위에서 12위로 상승했습니다.",
        "createdAt": "2024-12-18T10:00:00Z",
        "read": false
      },
      {
        "id": "notif456",
        "type": "NEW_RECORD",
        "message": "새로운 최고 기록을 달성했습니다!",
        "createdAt": "2024-12-18T09:30:00Z",
        "read": true
      }
    ],
    "unreadCount": 1
  }
}
```

---

## 5. 포털 큐 시스템

### 5.1 파일 업로드 요청

#### POST /api/queue/portal/submit
파일 업로드 작업을 요청합니다.

**Request Body:**
```json
{
  "userId": "string",
  "taskType": "file_upload",
  "fileData": "string",
  "fileName": "string",
  "fileSize": "number",
  "priority": "high" | "normal" | "low"
}
```

**Request Headers:**
```
Content-Type: application/json
Authorization: Bearer {accessToken}
```

**Response Codes:**
- `202 Accepted`: 작업 요청 성공
- `400 Bad Request`: 잘못된 요청
- `401 Unauthorized`: 인증 실패
- `413 Payload Too Large`: 파일 크기 초과

**Response Body (202):**
```json
{
  "success": true,
  "message": "파일 업로드 작업이 요청되었습니다.",
  "data": {
    "taskId": "task123",
    "estimatedCompletion": 30,
    "priority": "normal",
    "submittedAt": "2024-12-18T10:00:00Z"
  }
}
```

### 5.2 데이터 처리 요청

#### POST /api/queue/portal/submit
데이터 처리 작업을 요청합니다.

**Request Body:**
```json
{
  "userId": "string",
  "taskType": "data_processing",
  "data": "object",
  "processingType": "string",
  "priority": "high" | "normal" | "low"
}
```

**Request Headers:**
```
Content-Type: application/json
Authorization: Bearer {accessToken}
```

**Response Codes:**
- `202 Accepted`: 작업 요청 성공
- `400 Bad Request`: 잘못된 요청
- `401 Unauthorized`: 인증 실패

**Response Body (202):**
```json
{
  "success": true,
  "message": "데이터 처리 작업이 요청되었습니다.",
  "data": {
    "taskId": "task456",
    "estimatedCompletion": 60,
    "priority": "normal",
    "submittedAt": "2024-12-18T10:00:00Z"
  }
}
```

### 5.3 알림 발송 요청

#### POST /api/queue/portal/submit
알림 발송 작업을 요청합니다.

**Request Body:**
```json
{
  "userId": "string",
  "taskType": "notification",
  "message": "string",
  "recipients": ["string"],
  "notificationType": "email" | "sms" | "push",
  "priority": "high" | "normal" | "low"
}
```

**Request Headers:**
```
Content-Type: application/json
Authorization: Bearer {accessToken}
```

**Response Codes:**
- `202 Accepted`: 작업 요청 성공
- `400 Bad Request`: 잘못된 요청
- `401 Unauthorized`: 인증 실패

**Response Body (202):**
```json
{
  "success": true,
  "message": "알림 발송 작업이 요청되었습니다.",
  "data": {
    "taskId": "task789",
    "estimatedCompletion": 10,
    "priority": "high",
    "submittedAt": "2024-12-18T10:00:00Z"
  }
}
```

### 5.4 작업 상태 조회

#### GET /api/queue/portal/status/{taskId}
포털 작업 상태를 조회합니다.

**Path Parameters:**
- `taskId` (string): 작업 ID

**Request Headers:**
```
Authorization: Bearer {accessToken}
```

**Response Codes:**
- `200 OK`: 상태 조회 성공
- `401 Unauthorized`: 인증 실패
- `404 Not Found`: 작업 없음

**Response Body (200):**
```json
{
  "success": true,
  "data": {
    "taskId": "task123",
    "status": "pending" | "processing" | "completed" | "failed",
    "progress": 75,
    "taskType": "file_upload",
    "priority": "normal",
    "createdAt": "2024-12-18T10:00:00Z",
    "startedAt": "2024-12-18T10:01:00Z",
    "completedAt": "2024-12-18T10:02:00Z",
    "result": {
      "fileUrl": "https://storage.example.com/files/uploaded_file.pdf",
      "fileSize": 1024000,
      "processedAt": "2024-12-18T10:02:00Z"
    },
    "error": null
  }
}
```

---

## 6. 통합 큐 관리

### 6.1 큐 간 연동

#### POST /api/queue/integration/transfer
큐 간 사용자를 이동시킵니다.

**Request Body:**
```json
{
  "userId": "string",
  "fromQueue": "string",
  "toQueue": "string",
  "reason": "string"
}
```

**Request Headers:**
```
Content-Type: application/json
Authorization: Bearer {serviceToken}
```

**Response Codes:**
- `200 OK`: 이동 성공
- `400 Bad Request`: 잘못된 요청
- `404 Not Found`: 사용자 없음

**Response Body (200):**
```json
{
  "success": true,
  "message": "큐 이동이 완료되었습니다.",
  "data": {
    "userId": "user123",
    "fromQueue": "login",
    "toQueue": "game",
    "movedAt": "2024-12-18T10:00:00Z"
  }
}
```

### 6.2 우선순위 관리

#### PUT /api/queue/priority/adjust
큐 우선순위를 조정합니다.

**Request Body:**
```json
{
  "queueType": "string",
  "newPriority": "number",
  "reason": "string"
}
```

**Request Headers:**
```
Content-Type: application/json
Authorization: Bearer {adminToken}
```

**Response Codes:**
- `200 OK`: 우선순위 조정 성공
- `400 Bad Request`: 잘못된 요청
- `403 Forbidden`: 권한 없음

**Response Body (200):**
```json
{
  "success": true,
  "message": "우선순위가 조정되었습니다.",
  "data": {
    "queueType": "login",
    "oldPriority": 1.0,
    "newPriority": 1.2,
    "adjustedAt": "2024-12-18T10:00:00Z"
  }
}
```

### 6.3 부하 분산

#### GET /api/queue/load/status
큐 부하 상태를 조회합니다.

**Request Headers:**
```
Authorization: Bearer {adminToken}
```

**Response Codes:**
- `200 OK`: 상태 조회 성공
- `403 Forbidden`: 권한 없음

**Response Body (200):**
```json
{
  "success": true,
  "data": {
    "queues": [
      {
        "queueType": "login",
        "currentLoad": 75,
        "maxCapacity": 100,
        "loadRatio": 0.75,
        "processingRate": 100,
        "waitingCount": 5000
      },
      {
        "queueType": "game",
        "currentLoad": 60,
        "maxCapacity": 100,
        "loadRatio": 0.60,
        "processingRate": 50,
        "waitingCount": 2000
      }
    ],
    "systemResources": {
      "cpuUsage": 65,
      "memoryUsage": 70,
      "diskUsage": 45,
      "networkUsage": 30
    },
    "lastUpdated": "2024-12-18T10:00:00Z"
  }
}
```

### 6.4 모니터링 및 알림

#### GET /api/queue/monitoring/metrics
큐 시스템 메트릭을 조회합니다.

**Query Parameters:**
- `timeRange` (string, optional): 시간 범위 (1h, 24h, 7d, 30d)
- `queueType` (string, optional): 큐 타입 필터

**Request Headers:**
```
Authorization: Bearer {adminToken}
```

**Response Codes:**
- `200 OK`: 메트릭 조회 성공
- `403 Forbidden`: 권한 없음

**Response Body (200):**
```json
{
  "success": true,
  "data": {
    "timeRange": "24h",
    "metrics": {
      "processingRate": {
        "login": 100,
        "game": 50,
        "ranking": 200,
        "portal": 30
      },
      "averageWaitTime": {
        "login": 30,
        "game": 15,
        "ranking": 5,
        "portal": 60
      },
      "errorRate": {
        "login": 0.1,
        "game": 0.2,
        "ranking": 0.05,
        "portal": 0.3
      },
      "throughput": {
        "total": 10000,
        "successful": 9950,
        "failed": 50
      }
    },
    "alerts": [
      {
        "id": "alert123",
        "type": "HIGH_LOAD",
        "message": "로그인 큐 부하가 80%를 초과했습니다.",
        "severity": "warning",
        "createdAt": "2024-12-18T10:00:00Z"
      }
    ]
  }
}
```

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
