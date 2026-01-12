
# anaconda(또는 miniconda)가 존재하지 않을 경우 설치해주세요!
## TODO


# Conda 환셩 생성 및 활성화
## TODO

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

# Submission 폴더 파일 실행
cd submission || { echo "[INFO] submission 디렉토리로 이동 실패"; exit 1; }

for file in *.py; do
    ## TODO

done

# mypy 테스트 실행 및 mypy_log.txt 저장
## TODO

# conda.yml 파일 생성
## TODO

# 가상환경 비활성화
## TODO