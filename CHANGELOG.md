# Changelog

All notable changes to this project will be documented in this file.

---

## [v1.4.0] - 2026-06-17

> 설치 범위를 넓히되, **독립 실행 프로그램(앱)은 [8] 직접 다운로드로 분리**했습니다. 자동 설치(winget)는 개발 환경 구성요소(CLI·런타임)만 담당합니다. (winget ID는 2026-06-17 실조회 검증)

### Added — 설치 범위 확대

- **[5] 선택 설치**: uv(`astral-sh.uv`, Python 패키지 관리 CLI) 추가 — [7] 제거·[9] 확인에도 반영
- **[8] 직접 다운로드**: AI 도구 LM Studio·Windsurf·Warp 추가 (Cursor·Claude Desktop·GitHub Desktop은 기존부터 있음)

### Added — 초보자 친화성 (AI·전자기기 처음 다루는 사람용)

- **[A] 가장 쉬운 추천 설치** — 기본 5종(Git·Python·Node·VS Code·Windows Terminal) 설치 + Cursor·Claude Desktop **다운로드 페이지를 열어줌**(직접 설치 유도)
- **첫 실행 환영·안심 안내** — 무엇을 하는지/안전한지, SmartScreen 파란 경고 대처법([추가 정보] → [실행]) 설명
- **완료 후 '바이브코딩 첫 걸음' 가이드** — Cursor 열기 → Claude 로그인 → 한국어로 요청
- **설치 실패 시 친절 안내** — "[8] 직접 다운로드에서 받을 수 있어요" 안내
- **결과 색상 표시** — 설치 완료=초록, 실패=빨강, 메뉴 제목=청록 (Windows 10+ 터미널 색상; 이미 켜둔 VT 기능을 실제로 사용)
- **관리자 권한 자동 안내** — 권한 없이 실행 시 "우클릭 → 관리자 권한으로 실행"을 안내(대부분은 권한 없이도 설치됨; README↔PRD 모순도 정리)

### 설계 원칙 (이번 버전에서 명확화)

- **독립 프로그램(앱)은 자동 설치하지 않음** — Cursor·Claude Desktop·LM Studio·Windsurf·Warp·GitHub Desktop은 **[8] 직접 다운로드 안내로만** 제공. 올인원·추천 설치에 휩쓸려 한꺼번에 깔리지 않고, 사용자가 원할 때 직접 설치.
- 4개 레벨(초보자~새로운)은 변경 없음.
- 후속(검토): winget 실패 시 URL 자동 폴백, 도구 한 줄 쉬운 설명, 완료 후 결과 폴더 열기, CP949→UTF-8 검토.

---

## [v1.3.0] - 2026-06-17

> v1.2.0 업데이트 과정에서 누락(회귀)됐던 v1.1.0 수정들을 코드에 복구하고, 제거 기능 누락과 소요 시간 계산 버그를 함께 수정했습니다.

### Fixed (v1.1.0에서 누락됐다 복구)

- **B1** 선택 설치 Node.js 선행 감지 — findstr 부분일치 오탐 → `for` 정확 매칭으로 교체
- **B2** 디스크 여유 공간 체크 복구 — C드라이브 3GB 미만 시 경고 후 계속 여부 선택
- **B3** 설치 재시도 대기에 `/nobreak` 추가 — 대기 중 키 입력으로 건너뛰는 문제 방지
- **B4** 설치 개수 표시 수정 — 고급 15→16개, 올인원 17→18개
- **B5** PATH 검증 목록에서 cursor 제거 — winget 미설치 항목 오탐 방지
- **U3** 소요 시간 화면 표시 복구 + 8진수 계산 버그 수정 (`10#` 적용, 08·09 시/분/초 오류 방지)
- **제거 누락** — [7] 개별/전체 제거에 Git LFS·Stripe CLI 추가 (설치는 되나 제거가 안 되던 문제)

### Changed (v1.1.0에서 누락됐다 복구)

- **S1** [6] 업데이트 — `winget upgrade --all`(시스템 전체) → 키트 18개 도구만 개별 업그레이드
- **U2** npm 패키지 — POST 단계 자동 일괄 설치 → Vercel/Supabase/Stripe/Resend 개별 Y/N 선택
- **U1** ANSI 색상 시퀀스 활성화(VirtualTerminalLevel) 복구

---

## [v1.2.0] - 2026-04-22

### Added

- **F1** [8] 직접 다운로드 메뉴 — 21개 공식 URL 목록 (초보자/중급/고급/새로운/AI도구/개발확장CLI 그룹)
- **F2** [20] GitHub LFS, [21] Stripe CLI — 개발 확장 CLI 그룹 신규 추가

### Fixed

- **F3** Flutter 버전 표시 수정 — `tokens=2 + findstr /B` 로 깨진 문자 제거, 버전 번호만 출력
- **F4** Flutter 다운로드 URL 수정 — `flutter.dev/docs/...` (404) → `docs.flutter.dev/get-started/install/windows` (200 OK)

---

## [v1.1.0] - 2026-04-22

### Fixed

- **B1** findstr 오탐 수정 - for 이중 루프 정확 매칭으로 교체
- **B2** 디스크 여유 공간 체크 추가 - C드라이브 3GB 미만 시 경고 및 중단 선택
- **B3** timeout /nobreak 추가 - 재시도 대기 중 Ctrl+C 스킵 방지
- **B4** 설치 카운터 수정 - LEVEL_3: 15->16개, LEVEL_4: 17->18개
- **B5** PATH_CHECK cursor 제거 - winget PATH 미등록 항목 오탐 방지

### Changed

- **S1** 전체 업데이트 - winget upgrade --all -> 키트 18개 도구 개별 업그레이드
- **S2** 수동 설치 메뉴 - Antigravity 항목 완전 제거 (메뉴/start/echo 포함)
- **U1** ANSI 색상 코드 초기화 - Windows 10+ 가상 터미널 시퀀스 자동 활성화
- **U2** npm 패키지 설치 방식 - 자동 일괄 -> Vercel/Supabase/Stripe/Resend 개별 Y/N 선택
- **U3** 소요 시간 표시 - 완료 시 총 분/초 화면 출력 및 로그 기록

### Removed

- fix6b.py fix6c.py fix7.py fix8.py fix9.py upgrade6.py - 내부 패치 스크립트 삭제


## [v1.0.0] - 2026-04-20

### Added

- **원클릭 자동 설치** — Windows 기본 패키지 관리자(winget) 기반 자동 설치
- **4단계 설치 레벨** — 초보자(5종) / 중급(+5종) / 고급(+4종) / 새로운(+2종), 총 16종 도구
- **이미 설치된 도구 감지** — 건너뜀 / 업그레이드 / 제거 선택 기능
- **이식성 보장** — `%~dp0` 기반으로 BAT 파일 위치·이름 변경 후에도 정상 작동
- **자동 재시도** — 첫 시도 실패 시 1회 자동 재시도
- **설치 리포트 자동 저장** — `install-report-날짜.txt`, `install-log-날짜.txt`
- **PATH 경로 확인** — 설치 후 환경 변수 등록 여부 자동 점검
- **CLI 버전 치트시트** — 완료 후 주요 명령어 버전 확인 안내
- **개별 선택 설치** — `[5]` 메뉴에서 [1]~[26] 중 원하는 도구만 선택
- **npm 패키지 선택 설치** — Vercel, Supabase, Stripe, Railway, Prisma, Claude CLI, Uploadthing
- **업데이트 메뉴** — `[6]` npm 패키지 일괄 최신화
- **제거 메뉴** — `[7]` 개별 제거 / `[8]` 전체 제거
- **README.md** — 한국어 완전 초보자 가이드 포함
- **README_EN.md** — 영어 가이드 (동일 구조)
- **LICENSE** — MIT 라이선스, Copyright © 2026 SoDam AI Studio
