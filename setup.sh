#!/usr/bin/env bash
set -euo pipefail

MODEL_DIR="./models"
MODEL_NAME="ggml-small-q5_1.bin"
MODEL_PATH="${MODEL_DIR}/${MODEL_NAME}"
BASE_URL="https://huggingface.co/ggerganov/whisper.cpp/resolve/main"

mkdir -p "$MODEL_DIR"

if [ -f "$MODEL_PATH" ]; then
    echo "[OK] Modelo já existe: ${MODEL_PATH}"
    exit 0
fi

echo "[*] Baixando modelo ${MODEL_NAME}..."
wget --show-progress -O "$MODEL_PATH" "${BASE_URL}/${MODEL_NAME}"

echo "[OK] Modelo salvo em ${MODEL_PATH}"
echo "[*] Para iniciar o servidor: docker compose up -d --build"
