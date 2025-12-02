FROM ghcr.io/cirruslabs/flutter:latest

# Webビルドに必要なツールのみインストール
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    clang \
    cmake \
    ninja-build \
    pkg-config \
    libcurl4 \
    libexpat1 \
    libuuid1 \
    ca-certificates \
    gnupg \
    lsb-release

ENV NODE_VERSION=20.x
# Node.jsをインストール
RUN curl -fsSL https://deb.nodesource.com/setup_$NODE_VERSION | bash - \
  && apt-get update \
  && apt-get install -y nodejs \
  && npm install -g firebase-tools

RUN dart pub global activate flutterfire_cli
# グローバル環境変数として PATH を設定し、後続のステップに引き継ぐ
ENV PATH="$PATH:/root/.pub-cache/bin"

# 1. 依存パッケージのインストール (既存)
RUN apt-get update && apt-get install -y --no-install-recommends dnsutils curl unzip && \
    rm -rf /var/lib/apt/lists/*

# flutteruser 作成と権限設定 (既存)
RUN useradd -m -s /bin/bash flutteruser
RUN chown -R flutteruser:flutteruser /sdks/flutter
RUN echo 'flutteruser ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# ユーザー切り替え
USER flutteruser

# npm グローバルインストール先を設定
ENV NPM_CONFIG_PREFIX=/home/flutteruser/.npm-global

# 4. ユーザー権限でインストール実行
# npm install -g は $NPM_CONFIG_PREFIX で指定された場所にインストールする
RUN npm install -g @google/gemini-cli

# 5. PATHを更新: グローバルインストール先を実行パスに追加
ENV PATH="$NPM_CONFIG_PREFIX/bin:$PATH"
WORKDIR /home/flutteruser

# 6. コンテナ起動時のデフォルトコマンド
CMD ["bash"]
