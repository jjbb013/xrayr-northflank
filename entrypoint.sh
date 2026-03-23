#!/bin/bash
# XrayR Northflank 启动脚本 - 单节点测试版

set -e

echo "=========================================="
echo "🚀 XrayR Northflank 启动脚本 (单节点)"
echo "=========================================="
echo "时间: $(date)"
echo ""

# 配置目录
CONFIG_DIR="/etc/XrayR"
CONFIG_FILE="${CONFIG_DIR}/config.yml"

# 必填环境变量检查
if [ -z "${XBOARD_API_HOST}" ]; then
    echo "❌ 错误: XBOARD_API_HOST 未设置"
    exit 1
fi

if [ -z "${XBOARD_API_KEY}" ]; then
    echo "❌ 错误: XBOARD_API_KEY 未设置"
    exit 1
fi

echo "📋 环境变量:"
echo "  - XBOARD_API_HOST: ${XBOARD_API_HOST}"
echo "  - LOG_LEVEL: ${LOG_LEVEL:-warning}"
echo ""

# 生成 config.yml (替换环境变量)
echo "📝 生成 config.yml..."
envsubst < ${CONFIG_DIR}/config.yml.template > ${CONFIG_FILE}

echo "✅ 配置文件生成完成"
echo ""
echo "📁 生成的配置文件:"
echo "  - ${CONFIG_FILE}"
echo "  - /etc/XrayR/custom_outbound.json"
echo "  - /etc/XrayR/route.json"
echo ""

# 创建日志目录
mkdir -p /var/log/XrayR

# 启动 XrayR
echo "🚀 启动 XrayR..."
echo "=========================================="
exec XrayR -c ${CONFIG_FILE}
