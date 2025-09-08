# 🚀 Queue System - 대용량 로그인 큐잉 시스템

## 📋 프로젝트 개요

10만명이 동시에 접속하여 로그인을 시도하는 대용량 트래픽을 처리하는 **Redis 기반 큐잉 시스템**입니다. 마이크로서비스 아키텍처로 구성되어 있으며, Kubernetes 환경에서 운영됩니다.

## 🎯 핵심 목표

- **대용량 트래픽 처리**: 10만명 동시 접속 (1분 이내)
- **Redis 기반 큐잉**: 고성능 대기열 시스템
- **실시간 통신**: SSE + WebSocket
- **마이크로서비스**: 독립적이고 확장 가능한 아키텍처
- **Kubernetes 배포**: 클라우드 네이티브 환경

## 🏗️ 프로젝트 구조

### 프로젝트별 역할
- **queue-portal**: 사용자 인터페이스 (Vue.js/React.js)
- **queue-backend**: 비즈니스 로직 및 큐 관리 (Java Spring Boot)
- **queue-login**: 인증 및 사용자 관리 (Java Spring Boot)
- **queue-infra**: 인프라 관리 및 배포 (Kubernetes, Helm)

### 기술 스택
- **Frontend**: Vue.js 3.x, TypeScript, Element Plus
- **Backend**: Java 17, Spring Boot 3.x, Spring Security
- **Database**: MariaDB 10.11, Redis 7.x
- **Infrastructure**: Kubernetes 1.28, Helm 3.x, ArgoCD
- **Monitoring**: Prometheus, Grafana, ELK Stack

## 📚 문서 구조

### 📖 주요 문서
- **[README.md](docs/README.md)**: 전체 시스템 개요 및 상세 아키텍처
- **[Usecase.md](docs/Usecase.md)**: 큐별 데이터 흐름 시나리오
- **[ProjectInfo.md](docs/ProjectInfo.md)**: 프로젝트별 역할 및 기술 스택
- **[Api.md](docs/Api.md)**: 완전한 REST API 명세서
- **[DEVELOPMENT_PLAN.md](docs/DEVELOPMENT_PLAN.md)**: 4단계 4주 개발 계획
- **[TEAM_WORK_GUIDE.md](docs/TEAM_WORK_GUIDE.md)**: 팀 업무 분담 및 협업 가이드

## 🚀 빠른 시작

### 1. 사전 요구사항
- Kubernetes 클러스터
- Helm 3.x
- kubectl

### 2. 인프라 배포
```bash
# Redis 클러스터 배포
helm install redis-cluster ./queue-infra/redis-cluster --namespace queue

# MariaDB 배포
helm install mariadb ./queue-infra/mariadb --namespace queue
```

### 3. 애플리케이션 배포
```bash
# 백엔드 서비스 배포
helm install queue-backend ./queue-infra/backend --namespace queue

# 프론트엔드 서비스 배포
helm install queue-portal ./queue-infra/portal --namespace queue
```

## 📊 성능 지표

### 처리 성능
- **로그인 큐**: 초당 1,000명 처리
- **게임 큐**: 평균 매칭 시간 10초 이내
- **랭킹 큐**: 실시간 업데이트 (1초 이내)
- **포털 큐**: 기능별 1-30초 처리

### 확장성
- **최대 동시 사용자**: 100,000명
- **최대 큐 길이**: 50,000명
- **Redis 메모리**: 16GB 이내
- **API 응답 시간**: 평균 100ms 이내

## 🛠️ 개발 도구

### MCP 서버 연동
- **mcp-kubernetes**: Kubernetes 클러스터 관리
- **mcp-redis**: Redis 클러스터 모니터링
- **mcp-k6**: 성능 테스트 자동화
- **mcp-playwright**: E2E 테스트

### 바이브 코딩
- **Cursor**: AI 기반 코드 에디터
- **Gemini CLI**: Google AI 도구

## 👥 팀 구성 및 업무 분담

### 🎯 부장님 - 전체 기획 및 구성
- **담당 영역**: 전체 시스템 기획, 아키텍처 설계, 프로젝트 관리
- **주요 업무**: 
  - 전체 문서 관리 및 검토
  - 시스템 아키텍처 설계 및 검증
  - 프로젝트 일정 관리 및 품질 관리
  - 외부 연동 전략 수립
- **관련 문서**: [docs/README.md](docs/README.md), [docs/DEVELOPMENT_PLAN.md](docs/DEVELOPMENT_PLAN.md)

### 🔐 차장님 - queue-login 전담
- **담당 영역**: JWT 기반 인증 시스템, 사용자 관리
- **주요 업무**:
  - JWT 기반 인증 시스템 개발
  - 사용자 회원가입/로그인 기능
  - 보안 정책 및 토큰 관리
- **관련 문서**: [docs/Api.md](docs/Api.md), [docs/Usecase.md](docs/Usecase.md)

### ⚙️ 과장님 - queue-infra & queue-backend
- **담당 영역**: 인프라 관리, 큐 시스템, 백엔드 API
- **주요 업무**:
  - Kubernetes 클러스터 관리
  - Redis 기반 큐 시스템 구현
  - MariaDB 데이터베이스 관리
  - 백엔드 API 개발 및 최적화
  - 모니터링 및 장애 대응
- **관련 문서**: [docs/ProjectInfo.md](docs/ProjectInfo.md) (인프라/백엔드), [docs/Api.md](docs/Api.md) (큐 관련)

### 🎮 A대리님 - queue-portal
- **담당 영역**: 프론트엔드, UI/UX, 게임 개발
- **주요 업무**:
  - Vue.js/React.js 프론트엔드 개발
  - 사용자 인터페이스 설계 및 구현
  - 수박게임 개발 (Matter.js 기반)
  - 실시간 통신 (SSE/WebSocket) 구현
  - 반응형 디자인 및 사용자 경험 최적화
- **관련 문서**: [docs/Usecase.md](docs/Usecase.md) (UI 플로우), [docs/ProjectInfo.md](docs/ProjectInfo.md) (프론트엔드)

### 🧪 B대리님 - K6 성능 테스트
- **담당 영역**: 성능 테스트, Usecase 검증
- **주요 업무**:
  - K6 기반 성능 테스트 시나리오 작성
  - 10만명 동시 접속 시뮬레이션
  - 부하 테스트 및 스트레스 테스트
  - Usecase 시나리오 검증 및 테스트
  - 성능 메트릭 수집 및 분석
- **관련 문서**: [docs/Usecase.md](docs/Usecase.md) (테스트 시나리오), [docs/DEVELOPMENT_PLAN.md](docs/DEVELOPMENT_PLAN.md) (테스트 계획)

## 📅 개발 일정

| Phase | 기간 | 주요 목표 | 담당자 | 상태 |
|-------|------|-----------|--------|------|
| Phase 1 | 1주 | 기본 인프라 및 핵심 기능 | 과장님, 차장님 | 🔄 진행중 |
| Phase 2 | 1주 | 실시간 기능 및 고급 큐잉 | A대리님, 과장님 | ⏳ 대기 |
| Phase 3 | 1주 | 고급 기능 및 최적화 | 차장님, A대리님 | ⏳ 대기 |
| Phase 4 | 1주 | 확장 및 운영 준비 | B대리님, 부장님 | ⏳ 대기 |

## 🤝 기여하기

### 브랜치 전략
- **main**: 프로덕션 배포용
- **develop**: 개발 통합 브랜치
- **feature/**: 기능 개발 브랜치
- **hotfix/**: 긴급 수정 브랜치

### 커밋 규칙
- `feat`: 새로운 기능
- `fix`: 버그 수정
- `docs`: 문서 수정
- `style`: 코드 스타일
- `refactor`: 리팩토링
- `test`: 테스트 추가
- `chore`: 빌드 설정

## 📄 라이선스

MIT License

## 📞 지원

- **이슈 리포트**: GitHub Issues
- **문서**: [docs/](docs/) 폴더 참조
- **API 문서**: [docs/Api.md](docs/Api.md)

---

**개발팀**: AI Assistant  
**프로젝트**: Queue System  
**시작일**: 2025년 09월 02일  
**목표**: 10만명 동시 접속 처리 시스템 구축
