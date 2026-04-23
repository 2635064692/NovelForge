FROM python:3.11-slim

ARG NODE_VERSION=20.19.0

RUN apt-get update \
    && apt-get install -y --no-install-recommends bash curl xz-utils \
    && curl -fsSL https://npmmirror.com/mirrors/node/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.xz \
       | tar -xJ -C /usr/local --strip-components=1 \
    && rm -rf /var/lib/apt/lists/*

RUN pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
RUN npm config set registry https://registry.npmmirror.com

WORKDIR /app

COPY docker/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 54321 5173

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
