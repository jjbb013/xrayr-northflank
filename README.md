# XrayR Northflank 部署

**XrayR + Northflank + 移花接木** - 单容器部署 13 个 Shadowsocks 节点

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![XrayR](https://img.shields.io/badge/XrayR-latest-blue.svg)](https://github.com/XrayR-project/XrayR)

---

## 📖 项目简介

本项目提供了一个完整的 **XrayR Northflank 部署方案**，让你能够：

- ✅ **一个容器** 管理 **13 个 Shadowsocks 节点**
- ✅ **海外干净 IP** - Northflank 提供全球 Anycast IP 池
- ✅ **自动健康检查** - 服务异常自动重启
- ✅ **环境变量配置** - 敏感信息不写入代码
- ✅ **免费额度** - 每月 50GB 流量，适合中小规模部署

### 架构图

```
┌─────────┐     ┌─────────────┐     ┌──────────────────┐     ┌─────────────┐
│  用户   │ ──→ │ Xboard 面板 │ ──→ │ Northflank XrayR │ ──→ │ 13个Worker  │
│         │     │   (EC2)     │     │   (单容器)       │     │   节点      │
└─────────┘     └─────────────┘     └──────────────────┘     └─────────────┘
                                          │
                                          ├─ 端口 10014 → Node 14 (yg1:80)
                                          ├─ 端口 10015 → Node 15 (yg2:8080)
                                          ├─ ...
                                          └─ 端口 10026 → Node 26 (yg13:2096)
```

---

## 🚀 快速开始

### 前置要求

- [Northflank](https://northflank.com) 账号
- Xboard 面板（已部署）
- GitHub 仓库（本项目）

### 部署步骤

#### 1. 克隆仓库

```bash
git clone https://github.com/jjbb013/xrayr-northflank.git
cd xrayr-northflank
```

#### 2. 在 Northflank 创建 Service

1. 登录 [Northflank](https://app.northflank.com)
2. 创建项目或选择已有项目
3. 点击 **Add Service** → **Service**
4. 选择 **Build and Deploy from Git Repository**

#### 3. 配置 Git 仓库

| 配置项 | 值 |
|--------|-----|
| Repository URL | `https://github.com/jjbb013/xrayr-northflank` |
| Branch | `northflank-deploy` |
| Dockerfile Path | `Dockerfile` |

#### 4. 配置环境变量

| 变量名 | 值 | 说明 |
|--------|-----|------|
| `XBOARD_API_HOST` | `https://your-xboard-domain.com` | Xboard 面板地址 |
| `XBOARD_API_KEY` | `your-api-key` | API Key |
| `LOG_LEVEL` | `info` | 日志级别（可选） |

#### 5. 配置端口映射

添加 13 个 TCP 端口，每个端口开启 **Public Access**：

```
10014, 10015, 10016, 10017, 10018, 10019, 10020,
10021, 10022, 10023, 10024, 10025, 10026
```

#### 6. 资源配置

| 资源 | 推荐值 |
|------|--------|
| CPU | 0.5 vCPU |
| Memory | 1 GB |
| Disk | 1 GB |

#### 7. 创建并部署

点击 **Create Service**，等待构建完成（约 3-5 分钟）。

---

## 📊 节点映射表

| Node ID | 端口 | 上游服务器 | 上游端口 | TLS | 节点名称 |
|---------|------|------------|----------|-----|----------|
| 14 | 10014 | yg1.ygkkk.dpdns.org | 80 | ❌ | 🇭🇰 香港01 |
| 15 | 10015 | yg2.ygkkk.dpdns.org | 8080 | ❌ | 🇭🇰 香港02 |
| 16 | 10016 | yg3.ygkkk.dpdns.org | 8880 | ❌ | 🇭🇰 香港03 |
| 17 | 10017 | yg4.ygkkk.dpdns.org | 2052 | ❌ | 🇭🇰 香港04 |
| 18 | 10018 | yg5.ygkkk.dpdns.org | 2082 | ❌ | 🇭🇰 香港05 |
| 19 | 10019 | yg6.ygkkk.dpdns.org | 2086 | ❌ | 🇭🇰 香港06 |
| 20 | 10020 | yg7.ygkkk.dpdns.org | 2095 | ❌ | 🇭🇰 香港07 |
| 21 | 10021 | yg8.ygkkk.dpdns.org | 443 | ✅ | 🇭🇰 香港08 |
| 22 | 10022 | yg9.ygkkk.dpdns.org | 8443 | ✅ | 🇭🇰 香港09 |
| 23 | 10023 | yg10.ygkkk.dpdns.org | 2053 | ✅ | 🇭🇰 香港10 |
| 24 | 10024 | yg11.ygkkk.dpdns.org | 2083 | ✅ | 🇭🇰 香港11 |
| 25 | 10025 | yg12.ygkkk.dpdns.org | 2087 | ✅ | 🇭🇰 香港12 |
| 26 | 10026 | yg13.ygkkk.dpdns.org | 2096 | ✅ | 🇭🇰 香港13 |

### 节点配置说明

- **协议**: Shadowsocks
- **加密方式**: aes-128-gcm
- **密码**: 由 Xboard 自动生成
- **TLS 节点**: Node 21-26 自动启用 TLS 加密

---

## 📝 Xboard 面板配置

部署成功后，Northflank 会为每个端口分配一个域名：

```
https://your-service-xxxxx.northflank.app:10014
https://your-service-xxxxx.northflank.app:10015
...
https://your-service-xxxxx.northflank.app:10026
```

在 Xboard 面板中，将对应节点的地址更新为这些域名：

| 节点 ID | 地址 | 端口 | 类型 |
|---------|------|------|------|
| 14 | `your-service.northflank.app` | 10014 | Shadowsocks |
| 15 | `your-service.northflank.app` | 10015 | Shadowsocks |
| ... | ... | ... | ... |
| 26 | `your-service.northflank.app` | 10026 | Shadowsocks |

---

## ✅ 验证部署

### 1. 查看日志

在 Northflank 控制台 → Service → **Logs**，应该看到：

```
==========================================
🚀 XrayR Northflank 多节点启动脚本
==========================================
📋 环境变量:
  - XBOARD_API_HOST: https://...
  - LOG_LEVEL: info

📝 生成 config.yml...
📝 生成 custom_outbound.json...
✅ 配置文件生成完成

🚀 启动 XrayR...
```

### 2. 测试连通性

```bash
# 测试 HTTP 节点
curl -v https://your-service.northflank.app:10014

# 测试 TLS 节点
curl -vk https://your-service.northflank.app:10021
```

### 3. 检查 Xboard 面板

登录 Xboard → 节点管理，13 个节点状态应为 **在线**。

---

## 📁 项目结构

```
xrayr-northflank/
├── Dockerfile                      # 基于官方 XrayR 镜像
├── entrypoint.sh                   # 启动脚本，动态生成配置
├── config.yml.template             # 主配置模板（13 个节点）
├── custom_outbound.json.template   # 节点路由模板
├── route.json                      # 路由规则
├── DEPLOY.md                       # 详细部署指南
├── README.md                       # 本文件
└── northflank-deploy/              # 部署文件目录
```

---

## 🔧 环境变量

### 必填

| 变量 | 说明 | 示例 |
|------|------|------|
| `XBOARD_API_HOST` | Xboard 面板地址 | `https://xboard.example.com` |
| `XBOARD_API_KEY` | API Key | `your-api-key` |

### 可选

| 变量 | 默认值 | 说明 |
|------|--------|------|
| `LOG_LEVEL` | `info` | 日志级别 (debug/info/warning/error) |
| `NODE_PASSWORD_14` ~ `NODE_PASSWORD_26` | - | 节点密码（Xboard 自动管理） |

---

## 📊 资源对比

| 部署方式 | 容器数 | CPU | 内存 | 管理复杂度 |
|----------|--------|-----|------|------------|
| 传统多容器 | 13 | 6.5 vCPU | 13 GB | 高 |
| **本项目** | **1** | **0.5 vCPU** | **1 GB** | **低** |

**节省 92% 资源！**

---

## 🐛 故障排查

### Service 启动失败

**检查**：
1. 环境变量 `XBOARD_API_HOST` 和 `XBOARD_API_KEY` 是否正确
2. Northflank 日志中的错误信息

### 节点显示离线

**可能原因**：
- API Host 地址错误或不可达
- API Key 无效
- Northflank 无法访问 Xboard（检查网络策略）

**测试连接**：
```bash
curl ${XBOARD_API_HOST}/api/v1/node/14/info
```

### 端口无法访问

**检查**：
1. Northflank 端口映射是否正确
2. Public Access 是否已开启
3. 防火墙规则

---

## 🔐 安全建议

1. **使用 Northflank Secrets**
   - 将 `XBOARD_API_KEY` 存储在 Secrets 中
   - 不要硬编码在代码里

2. **限制访问**
   - 可选：配置 IP 白名单
   - 只允许 Xboard 面板 IP 访问

3. **定期更新**
   - 定期拉取最新 XrayR 镜像
   - 重新部署获取安全更新

---

## 📚 相关文档

- [XrayR 官方文档](https://github.com/XrayR-project/XrayR)
- [Northflank 文档](https://northflank.com/docs)
- [Xboard 部署指南](https://github.com/XTLS/XrayR)

---

## 📄 License

MIT License - 详见 [LICENSE](LICENSE) 文件

---

## 🙏 致谢

- [XrayR](https://github.com/XrayR-project/XrayR) - 强大的后端面板
- [Northflank](https://northflank.com) - 优秀的容器平台
- [Xboard](https://github.com/cedar2025/Xboard) - 简洁的面板

---

**Made with ❤️ for better proxy deployment**
