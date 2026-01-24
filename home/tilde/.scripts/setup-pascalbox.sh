#!/usr/bin/env bash

# Define variables
CONTAINER_NAME="pascalbox"
IMAGE="registry.fedoraproject.org/fedora:41"
COMFY_DIR="$HOME/ComfyUI"
VENV_DIR="$HOME/.venv-comfy"

# 1. Create the PascalBox Container
# We use --nvidia to hook into the host drivers configured in your nix modules
# echo ":: Creating Distrobox container [$CONTAINER_NAME]..."
# distrobox create --name "$CONTAINER_NAME" --image "$IMAGE" --nvidia --yes

# 2. Install System Dependencies
# libsndfile and ffmpeg are critical for Qwen TTS audio processing
echo ":: Installing system dependencies..."
distrobox enter "$CONTAINER_NAME" -- sh -c "
    sudo dnf install -y git wget ffmpeg libsndfile python3.12 python3-pip
"

# 3. Setup ComfyUI and Virtual Environment
echo ":: Setting up ComfyUI and Python Environment..."
distrobox enter "$CONTAINER_NAME" -- sh -c "
    # Clone ComfyUI if it doesn't exist
    if [ ! -d \"$COMFY_DIR\" ]; then
        git clone https://github.com/comfyanonymous/ComfyUI.git \"$COMFY_DIR\"
    fi

    # Create Virtual Environment
    if [ ! -d \"$VENV_DIR\" ]; then
        python3.12 -m venv \"$VENV_DIR\"
    fi

    # Activate and Install Requirements
    source \"$VENV_DIR/bin/activate\"
    
    # Install PyTorch with CUDA 12.1 support (Stable for Fedora 41 + 1050 Ti)
    pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121
    
    # Install ComfyUI Core Requirements
    pip install -r \"$COMFY_DIR/requirements.txt\"
    
    # Install Qwen TTS Node Requirements (transformers, librosa, etc)
    # We install these upfront to ensure the environment is ready for the custom node
    pip install transformers librosa soundfile accelerate numpy einops tiktoken sentencepiece
"

echo ":: Setup Complete. You can now launch ComfyUI via the Application menu."
