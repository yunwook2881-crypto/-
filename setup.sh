#!/bin/bash
set -e

echo "=== autoworkers-1st 초기 세팅 ==="
echo ""

# 1. Python venv
if [ ! -d ".venv" ]; then
  echo "[1/3] Python 가상환경 생성..."
  python3 -m venv .venv
  echo "  -> .venv 생성 완료"
else
  echo "[1/3] .venv 이미 존재, 스킵"
fi

# 2. yt-dlp 설치
echo "[2/3] yt-dlp 설치..."
.venv/bin/pip install -q yt-dlp
echo "  -> yt-dlp $(.venv/bin/yt-dlp --version) 설치 완료"

# 3. .env 파일
if [ ! -f ".env" ]; then
  echo "[3/3] .env 파일 생성..."
  cp .env.example .env
  echo "  -> .env 생성 완료"
else
  echo "[3/3] .env 이미 존재, 스킵"
fi

echo ""
echo "=== 세팅 완료! ==="
echo ""
echo "다음 단계:"
echo "  1. .env 파일에 GOOGLE_API_KEY를 입력하세요"
echo "  2. 채널을 만드세요:"
echo "     cp -r channels/_template channels/내채널"
echo "  3. 장르 프리셋을 복사하세요:"
echo "     cp channels/_presets/야담설화.md channels/내채널/config/profile.md"
echo "  4. channels/내채널/config/settings.json에서 채널 이름을 수정하세요"
echo "  5. Claude에게 \"영상 만들어줘\"라고 말하세요!"
