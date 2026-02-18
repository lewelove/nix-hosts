#!/usr/bin/env bash

# Define variables relative to the internal $HOME
COMFY_DIR="$HOME/ComfyUI"
VENV_DIR="$HOME/.venv-comfy"

echo ":: Running setup in: $HOME"

# 1. Install System Dependencies
echo ":: Installing system dependencies..."
sudo dnf install -y git wget ffmpeg libsndfile python3.12 python3-pip pciutils

# 2. Setup ComfyUI and Virtual Environment
echo ":: Setting up ComfyUI and Python Environment..."

if [ ! -d "$COMFY_DIR" ]; then
    echo ":: Cloning ComfyUI..."
    git clone https://github.com/comfyanonymous/ComfyUI.git "$COMFY_DIR"
fi

if [ ! -d "$VENV_DIR" ]; then
    echo ":: Creating Virtual Environment (Python 3.12)..."
    python3.12 -m venv "$VENV_DIR"
fi

# Activate
source "$VENV_DIR/bin/activate"
pip install --upgrade pip

# 3. Install AI Stack
echo ":: Installing PyTorch (CUDA 12.1)..."
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121

echo ":: Installing ComfyUI core requirements..."
pip install -r "$COMFY_DIR/requirements.txt"

echo ":: Installing Qwen TTS and extra dependencies..."
pip install transformers librosa soundfile accelerate numpy einops tiktoken sentencepiece

echo ""
echo ":: Setup Complete."
echo ":: Check GPU status:"
nvidia-smi
