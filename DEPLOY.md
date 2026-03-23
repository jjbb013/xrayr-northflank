# XrayR Northflank 部署指南

## 📦 项目结构

```
xrayr-northflank/
├── Dockerfile           # 构建镜像 (支持环境变量配置)
├── entrypoint.sh        # 启动脚本 (动态生成 config.yml)
├── docker-compose.yml   # 本地测试用
├── .env.example         # 环境变量模板
└── DEPLOY.md            # 本文档
```

## 🚀 Northflank 一键部署

### 步骤 1: 推送代码到 GitHub

```bash
cd /Users/will/.openclaw/workspace-frank/xrayr-northflank
git init
git add .
git commit -m "feat: XrayR Northflank deployment with env config"
git remote add origin https://github.com/jjbb013/xrayr-northflank.git
git push -u origin main
```

### 步骤 2: 在 Northflank 创建 Service

1. **创建项目** (如果还没有)
   - 登录 Northflank
   - 点击 "Create Project"
   - 名称: `xrayr-deployment`

2. **添加 Service**
   - 点击 "Add Service" → "Service"
   - 选择 "Build and Deploy from Git Repository"

3. **配置 Git 仓库**
   - Repository URL: `https://github.com/jjbb013/xrayr-northflank.git`
   - Branch: `main`
   - Build: 使用 Dockerfile (自动检测)

4. **配置环境变量** (每个节点独立配置)

   点击 "Environment Variables" 添加：

   | 变量名 | 值 | 说明 |
   |--------|-----|------|
   | `XBOARD_API_HOST` | `https://p01--xboard--xxxxx.code.run` | XBoard 面板地址 |
   | `XBOARD_API_KEY` | `Outline2025Outline2025` | API Key |
   | `NODE_ID` | `84` | 节点 ID |
   | `OUTBOUND_ADDRESS` | `yg1.ygkkk.dpdns.org` | 目标服务器地址 |
   | `OUTBOUND_PORT` | `80` | 目标服务器端口 |
   | `OUTBOUND_UUID` | `3c4dd06f-7ede-47ba-b83d-ca16a023cc4f` | UUID |
   | `OUTBOUND_PATH` | `/?ed=2560` | WebSocket 路径 |
   | `OUTBOUND_HOST` | `wboard.will-pan.workers.dev` | WebSocket Host |
   | `ENABLE_TLS` | `false` | 是否启用 TLS |

   **可选配置：**
   | 变量名 | 默认值 | 说明 |
   |--------|--------|------|
   | `NODE_TYPE` | `Vless` | 节点类型 |
   | `PANEL_TYPE` | `NewV2board` | 面板类型 |
   | `LOG_LEVEL` | `warning` | 日志级别 |
   | `UPDATE_PERIODIC` | `60` | 更新周期(秒) |
   | `LISTEN_IP` | `0.0.0.0` | 监听地址 |

5. **配置端口映射**
   - 在 "Ports" 部分，添加节点使用的端口
   - 例如: `80`, `443`, `8080` 等
   - 选择协议: TCP

6. **资源配置**
   - CPU: 0.25 (最小)
   - Memory: 256Mi (最小)

7. **点击 "Create Service"**

### 步骤 3: 创建多个节点服务

重复步骤 2，为每个节点创建独立的 Service，修改以下环境变量：

| 节点 | NODE_ID | OUTBOUND_ADDRESS | OUTBOUND_PORT | ENABLE_TLS |
|------|---------|------------------|---------------|------------|
| 84 | 84 | yg1.ygkkk.dpdns.org | 80 | false |
| 85 | 85 | yg2.ygkkk.dpdns.org | 8080 | false |
| 86 | 86 | yg3.ygkkk.dpdns.org | 8880 | false |
| 87 | 87 | yg4.ygkkk.dpdns.org | 2052 | false |
| 88 | 88 | yg5.ygkkk.dpdns.org | 2082 | false |
| 89 | 89 | yg6.ygkkk.dpdns.org | 2086 | false |
| 90 | 90 | yg7.ygkkk.dpdns.org | 2095 | false |
| 91 | 91 | yg8.ygkkk.dpdns.org | 443 | true |
| 92 | 92 | yg9.ygkkk.dpdns.org | 8443 | true |
| 93 | 93 | yg10.ygkkk.dpdns.org | 2053 | true |
| 94 | 94 | yg11.ygkkk.dpdns.org | 2083 | true |
| 95 | 95 | yg12.ygkkk.dpdns.org | 2087 | true |
| 96 | 96 | yg13.ygkkk.dpdns.org | 2096 | true |

### 步骤 4: 验证部署

1. **查看日志**
   - 在 Northflank 控制台点击 Service
   - 进入 "Logs" 标签
   - 应该看到类似输出：
     ```
     🚀 XrayR Northflank 启动脚本
     ✅ 配置文件生成完成
     🚀 启动 XrayR...
     ```

2. **检查健康状态**
   - Service 状态应为 "Running"
   - 健康检查应通过

3. **在 XBoard 面板验证**
   - 登录 XBoard 管理面板
   - 进入节点管理
   - 应该看到节点状态为 "在线"

## 🔧 高级配置

### 自定义 Outbound 配置 (多节点负载均衡)

如果需要配置多个 outbound 节点（负载均衡/故障转移），可以设置 `OUTBOUND_NODES` 环境变量为 JSON 字符串：

```json
{
  "outbounds": [
    {
      "tag": "node-84",
      "protocol": "vless",
      "settings": {
        "vnext": [{
          "address": "yg1.ygkkk.dpdns.org",
          "port": 80,
          "users": [{"id": "YOUR_UUID", "encryption": "none", "flow": ""}]
        }]
      },
      "streamSettings": {
        "network": "ws",
        "security": "none",
        "wsSettings": {
          "path": "/?ed=2560",
          "headers": {"Host": "wboard.will-pan.workers.dev"}
        }
      }
    }
  ]
}
```

### 自定义路由规则

设置 `ROUTE_CONFIG` 环境变量为 JSON 字符串：

```json
{
  "rules": [
    {
      "type": "field",
      "outboundTag": "direct",
      "domain": ["geosite:cn"]
    }
  ]
}
```

### 使用 Secrets 管理敏感信息

Northflank 支持 Secrets 管理：
1. 在项目设置中创建 Secret
2. 在环境变量中引用：`${SECRET_NAME}`

## 📊 监控和日志

### 查看日志
```bash
# 在 Northflank Web 控制台查看
# 或通过 API 获取
```

### 查看性能指标
Northflank 提供内置监控：
- CPU 使用率
- 内存使用率
- 网络流量

## 🐛 故障排查

### 问题 1: Service 启动失败

**检查日志：**
```
❌ 错误: XBOARD_API_HOST 未设置
```

**解决：** 确保环境变量已正确配置。

### 问题 2: 节点显示离线

**可能原因：**
- API Host 地址错误
- API Key 无效
- 网络连接问题

**解决：**
1. 在 Northflank Service 中测试网络：
   ```bash
   curl ${XBOARD_API_HOST}/api/v1/node/84/info
   ```
2. 检查 XBoard 面板是否允许 Northflank IP 访问

### 问题 3: 端口被占用

**解决：** 每个 Service 使用独立的端口，确保 Northflank 端口映射正确。

### 问题 4: TLS 证书错误

如果启用 TLS 但证书无效：
- 设置 `ENABLE_TLS=false` 使用 HTTP
- 或配置有效的证书（通过 CertConfig）

## 🔐 安全建议

1. **不要在代码中硬编码敏感信息**
   - 所有配置通过环境变量注入
   - 使用 Northflank Secrets 管理密码

2. **最小权限原则**
   - 每个 Service 只暴露必要的端口
   - 使用 Northflank 网络策略限制访问

3. **定期更新**
   - 定期重新部署获取最新 XrayR 版本
   - 更新 UUID 和 API Key

## 📚 相关文档

- [XrayR 官方文档](https://github.com/XrayR-project/XrayR)
- [Northflank 文档](https://northflank.com/docs)
- [XBoard API 文档](https://github.com/XTLS/XrayR)

## 🎯 下一步

1. 创建 13 个 Service（每个节点一个）
2. 配置对应的环境变量
3. 在 XBoard 面板查看节点状态
4. 测试客户端连接

需要帮助？查看日志或联系技术支持。
