# ベースイメージ
FROM python:3.10-alpine

# ソースをコピー
COPY main.py .
COPY requirements.txt .
COPY modules modules
COPY schemas.py .

# build-baseを追加
RUN apk add --no-cache build-base

# 仮想環境を作成し、パッケージをインストール
RUN python -m venv pyenv-bot-backend && \
    . /pyenv-bot-backend/bin/activate && \
    pip install --upgrade pip && \
    pip install -r requirements.txt

# コンテナのポート8000を公開
EXPOSE 8000

# コンテナ起動時に実行するコマンド
CMD . /pyenv-bot-backend/bin/activate && python main.py
