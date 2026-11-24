# 대본 제작 — 상세 절차

`{P}` = `channels/{채널}/projects/{프로젝트}`

---

## COLLECT

**YouTube 레퍼런스 수집. URL 필수.**

1. 사용자에게 YouTube URL 수집 (또는 이미 있으면 확인)
2. 실행:
```bash
.venv/bin/python scripts/collect.py --project {프로젝트} --channel "{채널}" URL1 [URL2 ...]
```
3. 결과: `_refs/{NNN}/` 에 meta.md, transcript.txt, thumbnail.webp

---

## ANALYZE

**레퍼런스 영상 분석. 에이전트: video-analyst**

1. `_refs/*/analysis.md`가 없는 영상 목록 확인
2. **전체 동시 병렬 실행** (run_in_background: true, **TaskOutput 사용 금지** → Glob으로 확인)
3. 각 에이전트에게 전달:
   - 채널 프로필 (`channels/{채널}/config/profile.md`)
   - 분석 프롬프트 (`prompts/reference-analyze.md`)
   - 영상 데이터 (meta.md + transcript.txt + thumbnail.webp)
4. 출력: 각 `_refs/{NNN}/analysis.md`
5. 완료 후 요약 보고

---

## DATA_PREP

**배경 리서치. data-researcher 에이전트 1개.**

장르에 맞는 배경 리서치를 수행한다.
`prompts/genres/{장르}.md` §1(리서치 방향)을 data-researcher에게 전달한다.

### data-researcher 에이전트 호출

1. 에이전트 1개 호출 (run_in_background: true, WebSearch 사용)
2. 전달:
   - 채널 프로필 + `prompts/data-research.md`
   - `prompts/genres/{장르}.md` §1 리서치 방향
   - 모든 transcript.txt + 모든 analysis.md
   - `factcheck`: profile.md의 팩트체크 설정값
3. 출력: `{P}/_script/verified-data.md`

### 완료 확인

- `_script/verified-data.md` 존재 확인

---

## STRATEGY

**크리에이티브 전략 통합 설계 + 썸네일 프롬프트. strategist 에이전트 1회.**

입력: `_script/verified-data.md` + 채널 프로필 + `prompts/genres/{장르}.md`

### Step 1: 콘텐츠 주제 + 러닝타임 결정 (PD 직접, 항상 ask)

strategist 호출 전에 PD가 사용자와 방향을 잡는다.

1. analysis.md + verified-data.md를 바탕으로 **새 콘텐츠 주제 3개 추천**
   - 레퍼런스의 구조·기법·감정 아크를 차용할 수 있는 주제로 선정
   - profile.md에 `## 구조 템플릿`이 있으면 템플릿 SKILL.md §0으로 각 주제를 판별해 "구조 템플릿 적용 가능/불가"를 함께 표시
2. **러닝타임 추천**: profile.md 범위(최소~최대) 내에서 추천 + 근거
3. 사용자가 주제 + 러닝타임 선택

### Step 2: strategist 에이전트 호출

사용자 결정(주제 + 러닝타임)을 strategist에게 전달한다.

#### 사전 준비

```bash
mkdir -p {P}/output/thumbnails
```

#### 에이전트 호출

1. strategist 에이전트 호출:
   - 전달: `prompts/creative-strategy.md` 내용 + `prompts/ctr-reference.md` 내용
          + `prompts/thumbnail-design.md` 내용
          + 채널 프로필 + `config/pd-guide.md` (있으면)
          + `_script/verified-data.md` 경로
          + `prompts/genres/{장르}.md` (장르 전문 가이드)
          + 구조 템플릿 SKILL.md 경로 (적용 시) — §1 논지 설계·§7 메타 템플릿 반영, concept.md에 논지 한 문장·비교축·조어 2개·제목 숫자 포함
          + `{P}/_refs/` 경로
          + 사용자 결정 (이야기 주제 + 타겟 러닝타임)
          + 모드 (auto / ask)
   - auto 출력: `{P}/_script/concept.md` + `{P}/_script/hook-intro.md` + `{P}/output/thumbnails/prompts.json`
   - ask 출력: `{P}/_script/_strategy_candidates.md`

### auto 모드

1. concept.md + hook-intro.md + prompts.json 존재 확인
2. 결과 요약 보고
3. OUTLINE 진행

### ask 모드

1. `_strategy_candidates.md` 읽기
2. 3 패키지 사용자에게 제시:
   - **`_strategy_candidates.md` 전체 내용을 그대로 출력한다. 요약 테이블로 대체 금지.**
   - 특히 **Hook & Intro는 나레이션 원문 전체**를 반드시 보여준다 (글자수·초수 포함)
   - 사용자가 Hook/Intro 원문을 직접 읽고 비교해야 선택할 수 있다
3. 사용자 선택/수정/혼합:
   - "B로 해줘" → B 그대로 채택
   - "A 앵글에 B 제목으로" → 혼합
   - "A 좋은데 Hook 좀 바꿔줘" → 수정
4. 확정 → `_script/concept.md` + `_script/hook-intro.md` 저장
   - concept.md에 **타겟 러닝타임**과 **타겟 글자수(러닝타임 × 500자)**를 포함
5. 썸네일 프롬프트 생성: `{S}/concept.md`의 썸네일 이미지 컨셉 + `prompts/thumbnail-design.md` 규칙 + `_refs/` 썸네일 분석으로 `{P}/output/thumbnails/prompts.json` 생성 (PD 직접 또는 strategist Phase 5 호출)
6. SCRIPT 진행

---

## SCRIPT

**outline 작성 → 대본 집필 → 자체 검수 → 확정. 에이전트: script-writer 1개.**

OUTLINE + DRAFT + REVIEW를 하나의 에이전트가 일괄 수행한다.

### script-writer 에이전트 호출

1. 에이전트 1개 호출 (run_in_background: true)
2. 전달:
   - `_script/concept.md` 경로
   - `_script/hook-intro.md` 경로
   - `_script/verified-data.md` 경로
   - 채널 프로필 (`config/profile.md` 경로)
   - 장르 가이드 (`prompts/genres/{장르}.md` 경로)
   - 구조 템플릿 (적용 시 `.claude/skills/{템플릿}/SKILL.md` 경로) — outline은 §2 비트 구조·비중, draft는 §3 문체, 자체검수에 §6 체크리스트 추가. profile.md 제약이 템플릿보다 우선
   - 검수 체크리스트 (`prompts/script-review-checklist.md` 경로)
   - 검증 기준 (`prompts/draft-verify.md` 경로)
   - outline 템플릿 (`prompts/pd-templates.md` 경로)
   - `factcheck`: profile.md의 팩트체크 설정값
   - 출력 디렉토리: `{P}/_script/`
3. 에이전트가 내부에서 순차 수행:
   - Step 1: outline.md 작성 (셀프체크 9항목 내장)
   - Step 2: draft.md 작성 (hook-intro.md 삽입 + 본문 + 클로징)
   - Step 3: 자체 검수 (치명적 항목 발견 시 직접 수정, 최대 1회)
   - Step 4: review.md + script.txt 저장

### 완료 확인

- `_script/script.txt` 존재 확인 (Glob)
- 존재하면 → YOUTUBE_META 진행

→ **다음 단계: YOUTUBE_META**

---

## YOUTUBE_META

**유튜브 업로드 메타 생성. PD 직접 수행.**

입력: `_script/outline.md` + `_script/concept.md` + `channels/{채널}/config/settings.json`

### 실행 절차

1. `prompts/youtube-upload.md` 읽기
2. outline.md + concept.md + settings.json 기반으로 youtube.md 생성
3. `{P}/output/youtube.md` 저장

→ **다음 단계: DONE**
