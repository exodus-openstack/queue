# 성능 테스트 계획 (K6)

## 목표/지표
- p95 응답시간 ≤ 2s, 오류율 < 1%
- 처리량: 로그인 큐 유입 ≥ 1000/s (목표)
- 안정성: 30분 지속 부하 동안 장애/메모리 누수 없음

## 시나리오
- PERF-001 지속 부하: 100 VU, 30분, 로그인→큐 진입
- PERF-002 단계 부하: 10→50→100 VU 램프업/다운
- PERF-003 혼합 트래픽: VIP 5%, PREMIUM 15%, NORMAL 80%
- PERF-004 회복 탄력성: 부하 중 Redis 지연 주입(가정) 후 회복 확인

## 실행 예시
```bash
cd queue-infra/api-test
k6 run --vus 100 --duration 30m queue-login-dev-test-grade.js
k6 run --stage 30s:10,1m:50,2m:100,30s:0 queue-login-dev-test-grade.js
```

## 수집 지표
- VU, RPS, p50/p95/p99, 실패율, 처리량, 스레드풀 대기
- 큐 메트릭: ZCARD, 평균 대기시간, READY 전환 속도
- 시스템: CPU/메모리, GC, 네트워크 대역폭

## 합격 기준
- 오류율 < 1%, p95 ≤ 2s, 스로틀링/429 비율 허용 범위 내
- READY 전환율이 기대치 이상, 메시지 유실 없음

## 산출물
- K6 summary(json), 그래프 스크린샷, 튜닝 전/후 비교표
```json
{
  "thresholds": {
    "http_req_failed": ["rate<0.01"],
    "http_req_duration": ["p(95)<2000"]
  }
}
```
