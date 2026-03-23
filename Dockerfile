# XrayR Northflank 部署 - 单节点测试版
# Node ID: 14, 端口: 10014

FROM ghcr.io/xrayr-project/xrayr:latest

# 安装必要工具
RUN apk add --no-cache curl ca-certificates bash gettext

# 创建工作目录
WORKDIR /etc/XrayR

# 复制配置文件
COPY config.yml.template /etc/XrayR/config.yml.template
COPY custom_outbound.json /etc/XrayR/custom_outbound.json
COPY route.json /etc/XrayR/route.json

# 复制启动脚本
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# 健康检查
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:10014 || exit 1

# 暴露端口
EXPOSE 10014

ENTRYPOINT ["/entrypoint.sh"]
