#!/bin/bash
# XrayR Northflank 启动脚本
# 根据环境变量动态生成配置文件

set -e

echo "🚀 XrayR Northflank 启动脚本"
echo "时间: $(date)"

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

if [ -z "${NODE_ID}" ]; then
    echo "❌ 错误: NODE_ID 未设置"
    exit 1
fi

# 可选环境变量默认值
NODE_TYPE=${NODE_TYPE:-Vless}
PANEL_TYPE=${PANEL_TYPE:-NewV2board}
UPDATE_PERIODIC=${UPDATE_PERIODIC:-60}
LISTEN_IP=${LISTEN_IP:-0.0.0.0}
LOG_LEVEL=${LOG_LEVEL:-warning}

# 检查是否启用 TLS (根据端口或环境变量判断)
ENABLE_TLS=${ENABLE_TLS:-false}
if [ "$ENABLE_TLS" = "true" ] || [[ "$NODE_PORT" =~ ^(443|8443|2053|2083|2087|2096)$ ]]; then
    ENABLE_TLS="true"
fi

echo "📝 生成配置文件..."
echo "  - XBoard API: ${XBOARD_API_HOST}"
echo "  - Node ID: ${NODE_ID}"
echo "  - Node Type: ${NODE_TYPE}"
echo "  - Enable TLS: ${ENABLE_TLS}"

# 生成 config.yml
cat > ${CONFIG_FILE} << EOF
Log:
  Level: ${LOG_LEVEL}
  AccessPath: /var/log/xrayr/access.log
  ErrorPath: /var/log/xrayr/error.log

DnsConfigPath: ${CONFIG_DIR}/dns.json
RouteConfigPath: ${ROUTE_FILE}
OutboundConfigPath: ${OUTBOUND_FILE}

ConnectionConfig:
  Handshake: 4
  ConnIdle: 30
  UplinkOnly: 2
  DownlinkOnly: 4
  BufferSize: 64

Nodes:
  - PanelType: "${PANEL_TYPE}"
    ApiConfig:
      ApiHost: "${XBOARD_API_HOST}"
      ApiKey: "${XBOARD_API_KEY}"
      NodeID: ${NODE_ID}
      NodeType: ${NODE_TYPE}
      Timeout: 30
      EnableVless: true
      VlessFlow: ""
      SpeedLimit: 0
      DeviceLimit: 0
      RuleListPath:
      DisableCustomConfig: false
    ControllerConfig:
      ListenIP: ${LISTEN_IP}
      SendIP: 0.0.0.0
      UpdatePeriodic: ${UPDATE_PERIODIC}
      EnableDNS: false
      DNSType: AsIs
      EnableProxyProtocol: false
      AutoSpeedLimitConfig:
        Limit: 0
        WarnTimes: 0
        LimitSpeed: 0
        LimitDuration: 0
      GlobalDeviceLimitConfig:
        Enable: false
        RedisNetwork: tcp
        RedisAddr: 127.0.0.1:6379
        RedisUsername:
        RedisPassword:
        RedisDB: 0
        Timeout: 5
        Expiry: 60
      EnableFallback: false
      FallBackConfigs: []
      DisableLocalREALITYConfig: false
      EnableREALITY: false
      CertConfig:
        CertMode: none
EOF

# 生成 outbound.json (如果有 OUTBOUND_NODES 环境变量)
if [ -n "${OUTBOUND_NODES}" ]; then
    echo "📦 使用自定义 outbound 配置: ${OUTBOUND_NODES}"
    # 如果 OUTBOUND_NODES 是 JSON 字符串，直接写入
    echo "${OUTBOUND_NODES}" > ${OUTBOUND_FILE}
else
    # 生成默认 outbound (单个节点)
    DEFAULT_OUTBOUND=$(cat <<-EOF
{
  "outbounds": [
    {
      "tag": "node-${NODE_ID}",
      "protocol": "vless",
      "settings": {
        "vnext": [{
          "address": "${OUTBOUND_ADDRESS:-localhost}",
          "port": ${OUTBOUND_PORT:-443},
          "users": [{"id": "${OUTBOUND_UUID:-00000000-0000-0000-0000-000000000000}", "encryption": "none", "flow": ""}]
        }]
      },
      "streamSettings": {
        "network": "ws",
        "security": "${ENABLE_TLS}",
        "wsSettings": {
          "path": "${OUTBOUND_PATH:-/}",
          "headers": {"Host": "${OUTBOUND_HOST:-localhost}"}
        }
      }
    }
  ]
}
EOF
)
    echo "${DEFAULT_OUTBOUND}" > ${OUTBOUND_FILE}
fi

# 生成 route.json (可选)
if [ -z "${ROUTE_CONFIG}" ]; then
    cat > ${ROUTE_FILE} << EOF
{
  "rules": []
}
EOF
else
    echo "${ROUTE_CONFIG}" > ${ROUTE_FILE}
fi

echo "✅ 配置文件生成完成"
echo "📁 配置文件位置:"
echo "  - ${CONFIG_FILE}"
echo "  - ${OUTBOUND_FILE}"
echo "  - ${ROUTE_FILE}"

# 启动 XrayR
echo "🚀 启动 XrayR..."
exec XrayR --config ${CONFIG_FILE}
