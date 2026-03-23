# XrayR for Northflank

**XrayR 的 Northflank 优化版本** - 通过环境变量动态配置，支持一键部署。

## ✨ 特性

- 🚀 **Northflank 原生支持** - 直接从 GitHub 仓库 Build & Deploy
- 🔧 **环境变量配置** - 无需修改配置文件，通过环境变量动态生成
- 📦 **单一镜像多节点** - 同一个 Docker 镜像，通过环境变量区分节点
- 🔐 **安全配置** - 敏感信息不写入代码，通过 Secrets 管理
- 🏥 **健康检查** - 内置健康检查，自动重启故障节点

## 📋 快速开始

### 1. 克隆仓库

```bash
git clone https://github.com/jjbb013/xrayr-northflank.git
cd xrayr-northflank
```

### 2. 配置环境变量

复制 `.env.example` 为 `.env` 并填写实际值：

```bash
cp .env.example .env
# 编辑 .env 文件，填写你的 XBoard 信息
```

### 3. 本地测试 (可选)

```bash
# 使用 docker-compose 本地测试单个节点
docker-compose up node84
```

### 4. 推送到 GitHub

```bash
git add .
git commit -m "Initial commit"
git push origin main
```

### 5. 在 Northflank 部署

详见 [DEPLOY.md](DEPLOY.md)

## 🏗️ 项目结构

```
.
├── Dockerfile           # 多阶段构建，生产镜像
├── entrypoint.sh        # 启动脚本，动态生成配置
├── docker-compose.yml   # 本地测试用
├── .env.example         # 环境变量模板
├── DEPLOY.md            # 详细部署指南
└── README.md            # 本文件
```

## 🔧 环境变量

### 必填

| 变量 | 说明 | 示例 |
|------|------|------|
| `XBOARD_API_HOST` | XBoard 面板地址 | `https://xboard.example.com` |
| `XBOARD_API_KEY` | API Key | `your-api-key` |
| `NODE_ID` | 节点 ID | `84` |
| `OUTBOUND_ADDRESS` | 目标服务器地址 | `yg1.ygkkk.dpdns.org` |
| `OUTBOUND_PORT` | 目标服务器端口 | `80` |
| `OUTBOUND_UUID` | UUID | `3c4dd06f-7ede-47ba-b83d-ca16a023cc4f` |

### 可选

| 变量 | 默认值 | 说明 |
|------|--------|------|
| `NODE_TYPE` | `Vless` | 节点类型 |
| `PANEL_TYPE` | `NewV2board` | 面板类型 |
| `ENABLE_TLS` | `false` | 是否启用 TLS |
| `OUTBOUND_PATH` | `/` | WebSocket 路径 |
| `OUTBOUND_HOST` | - | WebSocket Host |
| `LOG_LEVEL` | `warning` | 日志级别 |
| `UPDATE_PERIODIC` | `60` | 更新周期(秒) |
| `LISTEN_IP` | `0.0.0.0` | 监听地址 |

## 🚀 节点配置示例

### HTTP 节点 (无 TLS)
```yaml
NODE_ID=84
OUTBOUND_ADDRESS=yg1.ygkkk.dpdns.org
OUTBOUND_PORT=80
ENABLE_TLS=false
OUTBOUND_PATH=/?ed=2560
OUTBOUND_HOST=wboard.will-pan.workers.dev
```

### HTTPS 节点 (TLS)
```yaml
NODE_ID=91
OUTBOUND_ADDRESS=yg8.ygkkk.dpdns.org
OUTBOUND_PORT=443
ENABLE_TLS=true
OUTBOUND_PATH=/?ed=2560
OUTBOUND_HOST=wboard.will-pan.workers.dev
```

## 📊 13 个节点配置

| Node ID | 地址 | 端口 | TLS |
|---------|------|------|-----|
| 84 | yg1.ygkkk.dpdns.org | 80 | ❌ |
| 85 | yg2.ygkkk.dpdns.org | 8080 | ❌ |
| 86 | yg3.ygkkk.dpdns.org | 8880 | ❌ |
| 87 | yg4.ygkkk.dpdns.org | 2052 | ❌ |
| 88 | yg5.ygkkk.dpdns.org | 2082 | ❌ |
| 89 | yg6.ygkkk.dpdns.org | 2086 | ❌ |
| 90 | yg7.ygkkk.dpdns.org | 2095 | ❌ |
| 91 | yg8.ygkkk.dpdns.org | 443 | ✅ |
| 92 | yg9.ygkkk.dpdns.org | 8443 | ✅ |
| 93 | yg10.ygkkk.dpdns.org | 2053 | ✅ |
| 94 | yg11.ygkkk.dpdns.org | 2083 | ✅ |
| 95 | yg12.ygkkk.dpdns.org | 2087 | ✅ |
| 96 | yg13.ygkkk.dpdns.org | 2096 | ✅ |

## 🔍 验证部署

### 查看日志
```bash
# Northflank Web 控制台
Service → Logs
```

### 检查节点状态
```bash
# 在 XBoard 面板查看节点是否在线
```

### API 测试
```bash
curl -H "Authorization: Bearer ${XBOARD_API_KEY}" \
  ${XBOARD_API_HOST}/api/v1/node/${NODE_ID}/info
```

## 🐛 故障排查

### Service 启动失败
- 检查环境变量是否完整
- 查看启动日志

### 节点离线
- 确认 API Host 可访问
- 检查 API Key 是否正确
- 验证 outbound 地址是否可达

### 连接失败
- 确认端口映射正确
- 检查防火墙规则

## 📚 更多文档

- [详细部署指南](DEPLOY.md)
- [XrayR 官方文档](https://github.com/XrayR-project/XrayR)
- [Northflank 文档](https://northflank.com/docs)

## 📄 License

MIT
