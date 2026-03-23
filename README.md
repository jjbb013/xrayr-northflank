# XrayR Northflank 部署 - 13 节点单容器方案

**一个容器，13 个端口，管理 13 个 Shadowsocks 节点**

---

## ✨ 特性

- 🚀 **单容器多节点** - 一个 Service 处理 13 个节点，节省 92% 资源
- 🌍 **海外 IP 池** - Northflank 提供干净海外 IP，降低被封风险
- 🔧 **环境变量配置** - 敏感信息通过 Secrets 注入
- 💰 **免费额度** - 每月 50GB 流量，适合中小规模部署
- 🏥 **自动健康检查** - 自动检测服务状态并重启
- 🔐 **TLS 支持** - 节点 21-26 自动启用 TLS

---

## 📦 节点映射

| Node ID | 端口 | 上游服务器 | TLS |
|---------|------|------------|-----|
| 14 | 10014 | yg1.ygkkk.dpdns.org:80 | ❌ |
| 15 | 10015 | yg2.ygkkk.dpdns.org:8080 | ❌ |
| 16 | 10016 | yg3.ygkkk.dpdns.org:8880 | ❌ |
| 17 | 10017 | yg4.ygkkk.dpdns.org:2052 | ❌ |
| 18 | 10018 | yg5.ygkkk.dpdns.org:2082 | ❌ |
| 19 | 10019 | yg6.ygkkk.dpdns.org:2086 | ❌ |
| 20 | 10020 | yg7.ygkkk.dpdns.org:2095 | ❌ |
| 21 | 10021 | yg8.ygkkk.dpdns.org:443 | ✅ |
| 22 | 10022 | yg9.ygkkk.dpdns.org:8443 | ✅ |
| 23 | 10023 | yg10.ygkkk.dpdns.org:2053 | ✅ |
| 24 | 10024 | yg11.ygkkk.dpdns.org:2083 | ✅ |
| 25 | 10025 | yg12.ygkkk.dpdns.org:2087 | ✅ |
| 26 | 10026 | yg13.ygkkk.dpdns.org:2096 | ✅ |

---

## 🚀 快速开始

### 1. 克隆仓库

```bash
git clone https://github.com/jjbb013/xrayr-northflank-deploy.git
cd xrayr-northflank-deploy
```

### 2. 推送代码

```bash
git push origin main
```

### 3. 在 Northflank 部署

详见 [DEPLOY.md](DEPLOY.md)

### 4. 配置 XBoard 节点

将每个节点的地址更新为 Northflank 域名 + 对应端口：

```
https://your-service.northflank.app:10014
https://your-service.northflank.app:10015
...
```

---

## 🔧 环境变量

### 必填

| 变量 | 说明 |
|------|------|
| `XBOARD_API_HOST` | XBoard 面板地址 |
| `XBOARD_API_KEY` | API Key |

### 可选

| 变量 | 默认值 | 说明 |
|------|--------|------|
| `LOG_LEVEL` | `info` | 日志级别 |
| `NODE_PASSWORD_14` ~ `NODE_PASSWORD_26` | - | 节点密码（可选） |

---

## 📁 文件结构

```
.
├── Dockerfile                      # 基于官方 XrayR 镜像
├── entrypoint.sh                   # 启动脚本
├── config.yml.template             # 主配置模板
├── custom_outbound.json.template   # 节点路由模板
├── route.json                      # 路由规则
├── DEPLOY.md                       # 详细部署指南
└── README.md                       # 本文件
```

---

## ✅ 验证部署

```bash
# 查看日志
northflank logs xrayr-nodes

# 测试节点
curl -v https://your-service.northflank.app:10014
```

---

## 📊 资源消耗

| 资源 | 配置 |
|------|------|
| CPU | 0.5 vCPU |
| Memory | 1 GB |
| Disk | 1 GB |
| 端口 | 13 个 |

**免费额度足够运行！**

---

## 🔐 安全说明

- API Key 通过环境变量注入，不写入代码
- 使用 Northflank Secrets 管理敏感信息
- 可选 IP 白名单限制访问

---

## 📚 相关链接

- [XrayR 官方文档](https://github.com/XrayR-project/XrayR)
- [Northflank 文档](https://northflank.com/docs)
- [完整部署指南](DEPLOY.md)

---

## 📄 License

MIT
