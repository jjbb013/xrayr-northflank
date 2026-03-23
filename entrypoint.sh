#!/bin/bash
# XrayR Northflank 启动脚本
# 支持环境变量动态配置，单容器多节点部署

set -e

echo "=========================================="
echo "🚀 XrayR Northflank 多节点启动脚本"
echo "=========================================="
echo "时间: $(date)"
echo ""

# 配置目录
CONFIG_DIR="/etc/XrayR"
CONFIG_FILE="${CONFIG_DIR}/config.yml"
OUTBOUND_FILE="${CONFIG_DIR}/custom_outbound.json"
ROUTE_FILE="${CONFIG_DIR}/route.json"

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
echo "  - LOG_LEVEL: ${LOG_LEVEL:-info}"
echo ""

# 创建配置目录
mkdir -p ${CONFIG_DIR}

# 生成 config.yml (使用 envsubst 替换环境变量)
echo "📝 生成 config.yml..."
envsubst < ${CONFIG_DIR}/config.yml.template > ${CONFIG_FILE}

# 直接复制 custom_outbound.json（已经是完整配置，无需变量替换）
echo "📝 复制 custom_outbound.json..."
cp ${CONFIG_DIR}/custom_outbound.json.template ${OUTBOUND_FILE}

# 验证生成的 JSON 格式
echo "📝 验证 custom_outbound.json 格式..."
if ! jq empty ${OUTBOUND_FILE} 2>/dev/null; then
    echo "❌ custom_outbound.json 格式错误！"
    echo "文件内容:"
    cat ${OUTBOUND_FILE}
    exit 1
fi
echo "✅ JSON 格式正确"

# 复制 route.json
cp ${CONFIG_DIR}/route.json ${ROUTE_FILE} 2>/dev/null || echo '{"rules":[]}' > ${ROUTE_FILE}

# 创建 dns.json
cat > ${CONFIG_DIR}/dns.json << 'EOF'
{
  "servers": [
    "1.1.1.1",
    "8.8.8.8",
    "223.5.5.5"
  ]
}
EOF

echo "✅ 配置文件生成完成"
echo ""
echo "📁 生成的配置文件:"
echo "  - ${CONFIG_FILE}"
echo "  - ${OUTBOUND_FILE}"
echo "  - ${ROUTE_FILE}"
echo ""

# 创建日志目录
mkdir -p /tmp

# 启动 XrayR
echo "🚀 启动 XrayR..."
echo "=========================================="
exec XrayR -c ${CONFIG_FILE}
