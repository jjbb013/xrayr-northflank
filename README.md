# XrayR Northflank 单节点部署

## 快速部署

### 1. 环境变量
在 Northflank 添加：

| 变量 | 值 |
|------|-----|
| `XBOARD_API_HOST` | `https://p01--xboard--m2cwcvt4zs8p.code.run` |
| `XBOARD_API_KEY` | `Outline2025Outline2025` |

### 2. 端口映射
- 端口: `10014` (TCP, Public Access)

### 3. 资源配置
- CPU: 0.25 vCPU
- Memory: 256 MiB

### 4. 部署
选择分支 `northflank-deploy`，Dockerfile 路径 `Dockerfile`

## 节点配置

部署成功后，在 Xboard 面板配置节点 14：

| 字段 | 值 |
|------|-----|
| 地址 | `your-service.northflank.app` |
| 端口 | 10014 |
| 类型 | Shadowsocks |
| 加密 | aes-128-gcm |

## 验证

查看日志确认启动成功：
```
🚀 XrayR Northflank 启动脚本 (单节点)
✅ 配置文件生成完成
🚀 启动 XrayR...
```
