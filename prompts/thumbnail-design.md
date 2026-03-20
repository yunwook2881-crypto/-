# 유튜브 썸네일 이미지 프롬프트 규칙

## 목표

creative-strategy.md Phase 5에서 참조하는 **프롬프트 작성 규칙**.
확정된 썸네일 이미지 컨셉을 AI 이미지 프롬프트 5개로 변환할 때 이 규칙을 따른다.
사용자가 텍스트를 직접 추가하므로, **이미지에 텍스트를 절대 포함하지 않는다.**

---

## 프롬프트 5개 생성

### 다양성 규칙

concept.md의 **이미지 컨셉 2개**를 기반으로, 각 컨셉을 2가지 아트 스타일로 렌더링 + 자유 1장 = 총 5장:

| # | 이미지 컨셉 | 아트 스타일 | 설명 |
|---|------------|------------|------|
| 1 | **컨셉 A** | photorealistic / cinematic | 컨셉 A를 실사/시네마틱으로 구현 |
| 2 | **컨셉 A** | anime / stylized illustration | 컨셉 A를 애니메/일러스트로 구현 |
| 3 | **컨셉 B** | photorealistic / cinematic | 컨셉 B를 실사/시네마틱으로 구현 |
| 4 | **컨셉 B** | anime / stylized illustration | 컨셉 B를 애니메/일러스트로 구현 |
| 5 | **A or B** | 자유 (위 4개와 다른 스타일 권장) | 어느 컨셉이든, 가장 창의적인 접근 |

> **핵심**: 컨셉 A와 B는 본질적으로 다른 비주얼 방향이어야 한다 (단순 구도/색감 변형 금지). 같은 컨셉 내에서 실사 vs 애니메 스타일 차이로 선택지를 제공한다.

### 프롬프트 작성 규칙

1. **영어로 작성**: AI 이미지 생성 모델에 최적화
2. **실존 인물 실명 포함**: 전략에 실존 인물이 포함된 경우, 프롬프트에 반드시 실명과 직함을 영문으로 표기한다. 예: `"Lee Jae-yong (Samsung Electronics chairman)"`, `"Jensen Huang (NVIDIA CEO)"`. 일반화("an Asian man in a suit")는 금지.
3. **비실존 인물 외모**: 특정 실존 인물이 아닌 일반 캐릭터/인물이 등장할 경우, `"attractive, appealing appearance, likeable face"` 등을 추가하여 호감형 외모로 생성한다. 실사 스타일이면 `"attractive young woman/man with a warm likeable face"`, 애니메 스타일이면 `"beautiful/handsome anime character with expressive eyes"` 형태로.
4. **3~5문장**: 구체적이고 생생하게, 하지만 과도하게 길지 않게
5. **고유명사 보존**: concept_ko의 브랜드명, 제품명, 고유명사는 영어 프롬프트에 반드시 그대로 보존한다. 예: "HBM4 칩" → "Samsung HBM4 memory chip" (단순 "semiconductor chip"으로 일반화 금지)
6. **스타일 명시**: 다양성 규칙의 아트 스타일 열에 따라 해당 스타일을 프롬프트 앞부분에 명시. 실사: `"photorealistic"`, `"cinematic"`. 애니메: `"anime-style illustration"`, `"vibrant anime art"`, `"stylized digital illustration"` 등
7. **조명/분위기 — 밝고 선명하게**: 모바일 소형 썸네일에서 멀리서도 한눈에 보이려면 밝은 톤이 유리하다. 기본적으로 `"bright vibrant colors"`, `"clean white or light background"`, `"high-key lighting"`, `"vivid saturated tones"` 등 밝고 선명한 키워드를 사용한다. 어두운 분위기(`dark`, `moody`, `night`)는 주제가 명확히 요구할 때만 제한적으로 사용.
8. **구도 명시**: 좌우 배치, 중앙 집중, 원근 등 구도를 구체적으로 서술
9. **모바일 주목성**: 피사체를 크고 명확하게 묘사하여 모바일 소형 썸네일에서도 한눈에 알아볼 수 있도록 한다
10. **과장 연출**: 핵심 피사체를 의도적으로 과장하여 시각적 주목도를 높인다. 인물이면 감정 표현·얼굴 크기를 극대화(`exaggerated expression`, `extreme close-up`, `oversized face filling the frame`), 물체·로고면 스케일을 비현실적으로 키운다(`dramatically oversized`, `towering over`, `impossibly large`). 목표 감정은 **놀라움·충격·호기심**이며, 징그럽거나 혐오를 유발하는 과장은 금지.
11. **국기·상징물 주의**: 일본 국기는 반드시 일반 국기(日章旗, 흰 바탕에 빨간 원)만 사용한다. 전범기(旭日旗, 방사형 광선)는 절대 금지. 프롬프트에 `"Japanese national flag (white flag with red circle)"` 형태로 명시하고, `"rising sun"`, `"rays"`, `"imperial"` 등 전범기를 연상시키는 표현을 사용하지 않는다.

> **구도 원칙 — 상단 1/2 + 하단 1/2 분리**:
> 사용자가 미리캔버스에서 하단 1/2 영역에 텍스트를 직접 디자인한다.
> 따라서 이미지는 **상단 1/2에 핵심 피사체를 좌우 꽉 차게** 배치하고,
> **하단 1/2는 단순 배경만** 남겨서 텍스트가 올라갈 공간을 확보해야 한다.
> 하단에 인물 얼굴, 로고, 핵심 오브젝트 등 중요한 요소가 들어가면 텍스트에 가려지므로 금지.
>
> **boilerplate 불포함**: 아래 3가지는 `generate_thumbnails.py`가 자동 추가하므로 prompt_en에 포함하지 않는다:
> 1. 16:9 비율 (`wide 16:9 aspect ratio, YouTube thumbnail composition`)
> 2. 상단 1/2 구도 (`all key visual elements and the main subject fill the upper half of the frame edge to edge, the bottom half of the frame is reserved for text overlay and should contain only simple background with no important elements`)
> 3. 텍스트 금지 (`no text, no letters, no words, no numbers, no watermark`)

---

## 출력 형식

아래 JSON 형식으로 저장한다.

```json
{
  "meta": {
    "project": "{프로젝트명}",
    "titles": ["{추천 제목}", "{제목 후보 2}", "{제목 후보 3}"],
    "thumbnail_texts": ["{텍스트 세트 1}", "{텍스트 세트 2}", "{텍스트 세트 3}"],
    "image_concepts": {
      "A": "{컨셉 A 한줄 설명}",
      "B": "{컨셉 B 한줄 설명}"
    }
  },
  "thumbnails": [
    {
      "id": 1,
      "type": "concept-a-realistic",
      "concept_ko": "컨셉 A 실사. 배민 라이더가 무너지는 도시 앞에 서있는 시네마틱 장면.",
      "prompt_en": "Cinematic dramatic photograph of a Baemin delivery rider standing in front of a crumbling dark cityscape. The rider's mint-green uniform contrasts sharply against the shadowy backdrop with visible cracks spreading across buildings. Dramatic side lighting casts long shadows, creating a moody atmosphere of decline and crisis."
    },
    {
      "id": 2,
      "type": "concept-a-anime",
      "concept_ko": "컨셉 A 애니메. 같은 라이더+도시 붕괴를 애니메 스타일로 표현.",
      "prompt_en": "Vibrant anime-style illustration of a Baemin delivery rider standing before a dramatically crumbling cityscape. Bold ink outlines and cel-shaded lighting emphasize the contrast between the rider's mint-green uniform and the dark, fractured buildings behind. Intense dramatic atmosphere with exaggerated perspective and vivid color contrast."
    }
  ]
}
```

### 필드 설명

| 필드 | 설명 |
|------|------|
| `meta.titles` | 제목 후보 3개 배열. 첫 번째가 추천안 (concept.md "제목 후보" 3개 그대로) |
| `id` | 1~5 번호 |
| `type` | concept-a-realistic / concept-a-anime / concept-b-realistic / concept-b-anime / wildcard |
| `concept_ko` | 한국어로 이 이미지가 무엇을 보여주는지 1~2문장 설명 |
| `prompt_en` | AI 이미지 생성용 영어 프롬프트 (3~5문장, boilerplate 미포함) |
