# XrayR for Northflank - Build & Deploy
# 支持通过环境变量动态配置

# Stage 1: Build
FROM golang:1.25.3-alpine AS builder
WORKDIR /app

# 克隆 XrayR 源码
RUN git clone https://github.com/XrayR-project/XrayR.git .

# 构建
ENV CGO_ENABLED=0
RUN go mod download
RUN go build -v -o XrayR -trimpath -ldflags "-s -w -buildid="

# Stage 2: Runtime
FROM alpine:latest

# 安装依赖
RUN apk --update --no-cache add tzdata ca-certificates bash curl \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# 创建必要目录
RUN mkdir -p /etc/XrayR /var/log/xrayr

# 复制二进制文件
COPY --from=builder /app/XrayR /usr/local/bin/XrayR

# 复制启动脚本
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# 健康检查
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD pgrep XrayR || exit 1

ENTRYPOINT ["/entrypoint.sh"]
