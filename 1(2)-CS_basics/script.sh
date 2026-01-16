#!/bin/bash

# anaconda(또는 miniconda)가 존재하지 않을 경우 설치해주세요!
## TODO
# 1. Conda 명령어 사용을 위한 설정 로드 (경로 자동 탐색)
if [ -f "$HOME/miniconda3/etc/profile.d/conda.sh" ]; then
    source "$HOME/miniconda3/etc/profile.d/conda.sh"
elif [ -f "$HOME/anaconda3/etc/profile.d/conda.sh" ]; then
    source "$HOME/anaconda3/etc/profile.d/conda.sh"
elif [ -f "/opt/conda/etc/profile.d/conda.sh" ]; then
    source "/opt/conda/etc/profile.d/conda.sh"
fi

# 2. Conda가 없으면 설치
if ! command -v conda &> /dev/null; then
    echo "[INFO] Conda가 설치되어 있지 않습니다. Miniconda 설치를 진행합니다."
    mkdir -p ~/miniconda3
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh
    bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
    rm -rf ~/miniconda3/miniconda.sh
    source ~/miniconda3/etc/profile.d/conda.sh
fi

# 3. [중요] Anaconda 약관 동의 (ToS 에러 해결)
# 오류가 났던 tos 관련 명령어를 자동으로 수행합니다.
if conda --help | grep -q "tos"; then
    conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main > /dev/null 2>&1 || true
    conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r > /dev/null 2>&1 || true
fi


# Conda 환경 생성 및 활성화
## TODO
# 스크립트 내 활성화를 위한 훅 초기화
eval "$(conda shell.bash hook)"

# 환경 존재 여부 체크 후 생성 또는 스킵
if conda info --envs | grep -q "myenv"; then
    echo "[INFO] 가상환경 'myenv'가 이미 존재하므로 생성을 건너뜁니다."
else
    echo "[INFO] 가상환경 'myenv'를 생성합니다."
    conda create -n myenv python=3.8 -y
fi

# 활성화
conda activate myenv


## 건드리지 마세요! ##
python_env=$(python -c "import sys; print(sys.prefix)")
if [[ "$python_env" == *"/envs/myenv"* ]]; then
    echo "[INFO] 가상환경 활성화: 성공"
else
    echo "[INFO] 가상환경 활성화: 실패"
    exit 1 
fi

# 필요한 패키지 설치
## TODO
pip install mypy

# Submission 폴더 파일 실행
cd submission || { echo "[INFO] submission 디렉토리로 이동 실패"; exit 1; }

for file in *.py; do
    ## TODO
    filename=$(basename "$file" .py)
    input_file="../input/${filename}_input"
    output_file="../output/${filename}_output"
    
    # input 폴더에 파일이 있는 경우에만 실행
    if [ -f "$input_file" ]; then
        python "$file" < "$input_file" > "$output_file"
    fi
done

# mypy 테스트 실행 및 mypy_log.txt 저장
## TODO
# 상위 폴더(..)에 로그 저장
mypy *.py > ../mypy_log.txt

# conda.yml 파일 생성
## TODO
# 상위 폴더(..)에 설정 저장
conda env export > ../conda.yml

# 가상환경 비활성화
## TODO
conda deactivate