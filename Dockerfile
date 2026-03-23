# XrayR Northflank 部署 - 单容器多节点方案
# 暴露 13 个端口 (10014-10026) 对应 Node ID 14-26
# 使用官方镜像，通过环境变量动态配置

FROM ghcr.io/xrayr-project/xrayr:latest

# 安装必要工具
RUN apk add --no-cache curl ca-certificates bash jq

# 创建工作目录
WORKDIR /etc/XrayR

# 复制配置文件模板
COPY config.yml.template /etc/XrayR/config.yml.template
COPY custom_outbound.json.template /etc/XrayR/custom_outbound.json.template
COPY route.json /etc/XrayR/route.json

# 复制启动脚本
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# 健康检查脚本
RUN echo '#!/bin/sh\n\
for port in 10014 10015 10016 10017 10018 10019 10020 10021 10022 10023 10024 10025 10026; do\n\
  curl -s -f -o /dev/null http://localhost:$port || exit 1\n\
done' > /usr/local/bin/healthcheck.sh && \
chmod +x /usr/local/bin/healthcheck.sh

# 健康检查
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD /usr/local/bin/healthcheck.sh

# 暴露 13 个端口
# Node 14-26 对应端口 10014-10026
EXPOSE 10014 10015 10016 10017 10018 10019 10020 \
       10021 10022 10023 10024 10025 10026

ENTRYPOINT ["/entrypoint.sh"]
