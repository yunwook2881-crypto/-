# autoworkers-1st

"영상 만들어줘" 한마디로 레퍼런스 수집 → 대본 제작 → 썸네일 프롬프트 → 유튜브 메타까지 **유튜브 대본 파이프라인**을 자동화하는 PD Agent. 장르별 전문 가이드 자동 로드 (야담/설화, 자기계발 등).

## 사용법

영상 제작 관련 요청 시 **반드시 `.claude/skills/youtube-pd/SKILL.md`를 먼저 읽고** 그대로 따를 것.

```
"영상 만들어줘" + YouTube URL 1개 이상  → SKILL.md 로드 → 상태 감지 → 자동 진행
"이어서 해줘"                        → 마지막 상태에서 재개
"대본 다시 써줘"                     → 해당 단계만 재실행
```

### 파이프라인 (레퍼런스 필수)
```
COLLECT → ANALYZE → DATA_PREP(리서치) → STRATEGY(방향 결정) → SCRIPT(outline+대본+검수) → YOUTUBE_META → DONE
```
STRATEGY에서 이야기 주제 3개 추천 + 러닝타임 결정 후, 크리에이티브 전략을 설계한다.

## 프로젝트 구조

```
autoworkers-1st/
├── .claude/
│   ├── skills/youtube-pd/SKILL.md    # PD 두뇌 (상태머신 + 오케스트레이션)
│   └── agents/                        # 역할별 에이전트 정의
├── channels/
│   ├── _template/                     # 새 채널 만들 때 복사
│   │   └── config/ (settings.json + profile.md + workflow.json)
│   ├── _presets/                      # 장르별 profile.md 프리셋
│   └── {채널}/                        # 채널별 설정 + 프로젝트
│       ├── config/                    # 채널 설정 파일
│       │   ├── settings.json          # 채널 기본 정보
│       │   ├── profile.md             # 장르 + 톤 + 리서치 지침
│       │   └── workflow.json          # 실행 모드 (ask/auto)
│       └── projects/                  # 영상별 작업 폴더
│           └── {프로젝트}/
│               ├── _refs/             # 레퍼런스 수집 결과
│               ├── _script/           # 대본 단계 산출물
│               └── output/            # 최종 산출물
├── prompts/                           # 에이전트용 프롬프트
│   └── genres/                        # 장르별 전문 가이드 (리서치·서사·문체·리텐션·검수)
│       ├── 야담설화.md
│       ├── 자기계발.md
│       └── ...
├── scripts/                           # Python 코드
│   ├── collect.py                     # yt-dlp 수집
│   ├── finalize.py                    # draft → script.txt
│   └── src/                           # merge_draft, validate_draft
├── .env                               # API 키
└── .env.example                       # 필요 키 안내
```

## 빠른 시작

```bash
# 1. 세팅
./setup.sh

# 2. .env에 API 키 입력
# GOOGLE_API_KEY=...

# 3. 채널 만들기
cp -r channels/_template channels/내채널

# 4. 장르 프리셋 복사 (야담설화, 자기계발 등)
cp channels/_presets/야담설화.md channels/내채널/config/profile.md

# 5. settings.json 수정
# channels/내채널/config/settings.json에서 채널 이름 변경

# 6. 시작
# "영상 만들어줘" + YouTube URL 1개 이상
```

## 설정

### .env (API 키)
```
GOOGLE_API_KEY=...       # WebSearch / Gemini
GEMINI_API_KEY=...       # 썸네일 이미지 생성 (선택, GOOGLE_API_KEY 폴백)
```

### profile.md (채널 정의)
`channels/_presets/`에서 장르에 맞는 프리셋을 복사 후 커스터마이즈.
- `## 장르`: 장르 전문 가이드(`prompts/genres/{장르}.md`) 자동 매칭에 사용
- `## 팩트체크`: true/false — data-researcher, script-reviewer 동작 결정
- `## 톤앤매너` + `## 말투 규칙`: 모든 에이전트의 글쓰기 톤
- `## 리서치 지침`: data-researcher의 조사 방향
- `## 스토리텔링 특성`: 장르 고유 서사 기법

### 장르 전문 가이드 (`prompts/genres/{장르}.md`)
장르에 특화된 작법 가이드. profile.md의 `## 장르` 값으로 자동 매칭.
- §1 리서치 방향 — §2 서사 구조 — §3 Hook 패턴 — §4 문체 규칙 — §5 리텐션 장치 — §6 검수 체크리스트 — §7 콘텐츠 제약
- 현재 지원: 야담설화, 자기계발 (+ 미스터리, 인물전, 사건사고 등 프리셋 존재)

### workflow.json
```json
{"mode": "ask"}   // ask: STRATEGY에서 3안 비교 후 선택 (기본값, 권장)
{"mode": "auto"}  // auto: 전체 자동 (익숙해지면)
```

## Python 실행

모든 Python 호출은 `.venv/bin/python scripts/...` 형태.
```bash
.venv/bin/python scripts/collect.py --project {project} --channel "{channel}" URL1
```

## 최종 산출물

| 파일 | 설명 |
|------|------|
| `_script/script.txt` | 완성 대본 (순수 텍스트) |
| `output/thumbnails/prompts.json` | 썸네일 이미지 프롬프트 5개 |
| `output/youtube.md` | 업로드 메타 (제목/설명글/태그/고정댓글) |
