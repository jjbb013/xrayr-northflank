# Northflank 部署 XrayR + 移花接木 完整指南

## 📦 架构说明

```
用户 → Xboard面板(EC2) → Northflank XrayR → 13个Worker节点 → 目标网站
                                ↑
                        一个容器，13个端口
                        10014-10026
```

**Northflank 优势**：
- 免费额度（每月 50GB 流量）
- 海外 IP 池（IP 干净，被封风险低）
- 容器化部署，自动健康检查
- 自动 SSL 证书（可选）

---

## 🚀 快速部署

### 步骤 1：准备 Git 仓库

```bash
# 创建部署目录
mkdir -p /Users/will/.openclaw/workspace-frank/northflank-deploy
cd /Users/will/.openclaw/workspace-frank/northflank-deploy

# 初始化 Git
git init
git add .
git commit -m "XrayR Northflank deployment for nodes 14-26"

# 推送到 GitHub
git remote add origin https://github.com/jjbb013/xrayr-northflank-deploy.git
git push -u origin main
```

### 步骤 2：在 Northflank 创建 Service

1. **登录 [Northflank](https://app.northflank.com)**
2. **创建项目**（如果还没有）
   - 项目名称：`xrayr-nodes`
3. **添加 Service**
   - 点击 **Add Service** → **Service**
   - 选择 **Build and Deploy from Git Repository**

### 步骤 3：配置 Git 仓库

| 配置项 | 值 |
|--------|-----|
| Repository URL | `https://github.com/jjbb013/xrayr-northflank-deploy.git` |
| Branch | `main` |
| Build | Dockerfile (自动检测) |

### 步骤 4：配置环境变量（Secrets）

在 **Environment Variables** 中添加：

| 变量名 | 值 | 说明 |
|--------|-----|------|
| `XBOARD_API_HOST` | `https://p01--xboard--m2cwcvt4zs8p.code.run` | XBoard 面板地址 |
| `XBOARD_API_KEY` | `Outline2025Outline2025` | API Key |
| `LOG_LEVEL` | `info` | 日志级别 (可选) |

**节点密码（可选，XBoard 会自动生成）**：
| 变量名 | 说明 |
|--------|------|
| `NODE_PASSWORD_14` ~ `NODE_PASSWORD_26` | 节点密码（XBoard 会自动同步，无需手动设置） |

### 步骤 5：配置端口映射

在 **Ports** 部分，添加 13 个端口：

| 端口 | 协议 | 节点 ID | 说明 |
|------|------|---------|------|
| 10014 | TCP | 14 | 香港01 (yg1:80) |
| 10015 | TCP | 15 | 香港02 (yg2:8080) |
| 10016 | TCP | 16 | 香港03 (yg3:8880) |
| 10017 | TCP | 17 | 香港04 (yg4:2052) |
| 10018 | TCP | 18 | 香港05 (yg5:2082) |
| 10019 | TCP | 19 | 香港06 (yg6:2086) |
| 10020 | TCP | 20 | 香港07 (yg7:2095) |
| 10021 | TCP | 21 | 香港08 (yg8:443) TLS |
| 10022 | TCP | 22 | 香港09 (yg9:8443) TLS |
| 10023 | TCP | 23 | 香港10 (yg10:2053) TLS |
| 10024 | TCP | 24 | 香港11 (yg11:2083) TLS |
| 10025 | TCP | 25 | 香港12 (yg12:2087) TLS |
| 10026 | TCP | 26 | 香港13 (yg13:2096) TLS |

**如何添加端口**：
1. 点击 **Add Port**
2. 输入端口号（如 10014）
3. 协议选择 **TCP**
4. 开启 **Public Access**（生成外网域名）
5. 重复添加所有 13 个端口

### 步骤 6：配置资源

| 配置项 | 推荐值 |
|--------|--------|
| CPU | 0.5 vCPU |
| Memory | 1 GB |
| Disk | 1 GB |
| Scaling | 1 实例 |

### 步骤 7：创建 Service

点击 **Create Service**，等待构建和部署完成（约 3-5 分钟）。

---

## 🔗 获取 Northflank 域名

部署成功后，每个端口会分配一个独立的域名：

```
https://xrayr-nodes-xxxxx.northflank.app:10014
https://xrayr-nodes-xxxxx.northflank.app:10015
...
https://xrayr-nodes-xxxxx.northflank.app:10026
```

**复制这些域名**，稍后在 XBoard 面板中使用。

---

## 📝 在 XBoard 面板配置节点

登录 XBoard 管理面板 → **节点管理** → **添加节点**（或编辑现有节点）：

| 节点 ID | 节点名称 | 地址 | 端口 | 类型 | 加密方式 |
|---------|----------|------|------|------|----------|
| 14 | 🇭🇰 香港01 | `xrayr-nodes-xxxxx.northflank.app` | 10014 | Shadowsocks | aes-128-gcm |
| 15 | 🇭🇰 香港02 | `xrayr-nodes-xxxxx.northflank.app` | 10015 | Shadowsocks | aes-128-gcm |
| 16 | 🇭🇰 香港03 | `xrayr-nodes-xxxxx.northflank.app` | 10016 | Shadowsocks | aes-128-gcm |
| 17 | 🇭🇰 香港04 | `xrayr-nodes-xxxxx.northflank.app` | 10017 | Shadowsocks | aes-128-gcm |
| 18 | 🇭🇰 香港05 | `xrayr-nodes-xxxxx.northflank.app` | 10018 | Shadowsocks | aes-128-gcm |
| 19 | 🇭🇰 香港06 | `xrayr-nodes-xxxxx.northflank.app` | 10019 | Shadowsocks | aes-128-gcm |
| 20 | 🇭🇰 香港07 | `xrayr-nodes-xxxxx.northflank.app` | 10020 | Shadowsocks | aes-128-gcm |
| 21 | 🇭🇰 香港08 | `xrayr-nodes-xxxxx.northflank.app` | 10021 | Shadowsocks | aes-128-gcm |
| 22 | 🇭🇰 香港09 | `xrayr-nodes-xxxxx.northflank.app` | 10022 | Shadowsocks | aes-128-gcm |
| 23 | 🇭🇰 香港10 | `xrayr-nodes-xxxxx.northflank.app` | 10023 | Shadowsocks | aes-128-gcm |
| 24 | 🇭🇰 香港11 | `xrayr-nodes-xxxxx.northflank.app` | 10024 | Shadowsocks | aes-128-gcm |
| 25 | 🇭🇰 香港12 | `xrayr-nodes-xxxxx.northflank.app` | 10025 | Shadowsocks | aes-128-gcm |
| 26 | 🇭🇰 香港13 | `xrayr-nodes-xxxxx.northflank.app` | 10026 | Shadowsocks | aes-128-gcm |

**注意**：
- 密码由 XBoard 自动生成，无需手动设置
- 加密方式统一为 `aes-128-gcm`
- 节点 21-26 支持 TLS（自动启用）

---

## ✅ 验证部署

### 1. 查看日志

在 Northflank 控制台点击 Service → **Logs**，应该看到：

```
==========================================
🚀 XrayR Northflank 多节点启动脚本
==========================================
时间: 2026-03-23 ...

📋 环境变量:
  - XBOARD_API_HOST: https://...
  - LOG_LEVEL: info

📝 生成 config.yml...
📝 生成 custom_outbound.json...
✅ 配置文件生成完成

🚀 启动 XrayR...
==========================================
```

### 2. 检查健康状态

Service 状态应为 **Running**，健康检查应通过。

### 3. 测试节点连通性

```bash
# 测试节点 14
curl -v https://xrayr-nodes-xxxxx.northflank.app:10014

# 测试节点 21 (TLS)
curl -vk https://xrayr-nodes-xxxxx.northflank.app:10021
```

### 4. 在 XBoard 面板验证

登录 XBoard → 节点管理，13 个节点状态应为 **在线**。

---

## 🔧 故障排查

### 问题 1：Service 启动失败

**检查日志**：查看是否缺少必填环境变量。

### 问题 2：节点显示离线

**可能原因**：
- API Host 地址错误
- API Key 无效
- Northflank 无法访问 XBoard（检查网络策略）

**解决**：
```bash
# 在 Northflank 控制台测试连接
curl ${XBOARD_API_HOST}/api/v1/node/14/info
```

### 问题 3：端口无法访问

**检查**：
1. 确认 Northflank 端口映射正确
2. 确认 Public Access 已开启
3. 检查防火墙规则

### 问题 4：TLS 证书错误

XrayR 会自动处理 TLS，无需额外配置。如果遇到证书错误：
- 确认 `custom_outbound.json.template` 中 TLS 配置正确
- 检查目标服务器证书是否有效

---

## 📊 资源对比

| 部署方式 | 容器数量 | CPU | 内存 | 端口数 | 管理复杂度 |
|----------|----------|-----|------|--------|------------|
| 多容器方案 | 13 | 6.5 | 13GB | 13 | 高 |
| **单容器多节点** | **1** | **0.5** | **1GB** | **13** | **低** |

**节省 92% 资源！**

---

## 🔐 安全建议

1. **使用 Northflank Secrets**
   - 将 `XBOARD_API_KEY` 存储在 Secrets 中
   - 不要硬编码在代码里

2. **限制访问**
   - 可选：在 Northflank 配置 IP 白名单
   - 只允许 XBoard 面板 IP 访问

3. **定期更新**
   - 定期拉取最新 XrayR 镜像
   - 重新部署获取安全更新

---

## 📚 文件清单

| 文件 | 说明 |
|------|------|
| `Dockerfile` | 基于官方 XrayR 镜像 |
| `entrypoint.sh` | 启动脚本，生成配置 |
| `config.yml.template` | 主配置模板 |
| `custom_outbound.json.template` | 节点路由模板 |
| `route.json` | 路由规则 |
| `DEPLOY.md` | 本文档 |

---

## 🎯 下一步

1. ✅ 推送代码到 GitHub
2. ✅ 在 Northflank 创建 Service
3. ✅ 配置环境变量和端口
4. ✅ 等待部署完成
5. ✅ 在 XBoard 更新节点地址
6. ✅ 测试客户端连接

---

**预计总耗时**：30 分钟

需要帮助？查看 [Northflank 文档](https://northflank.com/docs) 或联系技术支持。
