# 项目创建脚本

## 使用方法

在 `react-vite-tailwind4-template` 根目录下运行：

```bash
# 使用scripts目录的脚本（推荐）
bash scripts/create-project.sh <项目名称> [8位hash]

# 给脚本添加执行权限后直接运行
chmod +x scripts/create-project.sh
./scripts/create-project.sh <项目名称> [8位hash]
```

## 参数说明

- `项目名称`: 必需，英文项目名称
- `8位hash`: 可选，8位字符，不提供则自动生成

## 示例

```bash
# 自动生成hash
bash scripts/create-project.sh my-awesome-app

# 指定hash
bash scripts/create-project.sh my-awesome-app abcd1234

# 查看帮助
bash scripts/create-project.sh --help
```

## 脚本功能

1. **复制模板**: 将 `template` 目录复制为新项目
2. **统一替换**: 自动查找所有相关文件，将 `TEMPLATE_NAME` 占位符替换为实际项目名
   - 支持的文件类型：`.json`, `.ts`, `.tsx`, `.html`, `.js`, `.jsx`
   - 一次性替换所有配置文件中的项目名称和路径
   - 自动清理替换过程中的备份文件

## 模板占位符

模板中使用统一的 `TEMPLATE_NAME` 占位符，脚本会自动替换为：
- `package.json` → `"name": "项目名-hash"`
- `vite.config.ts` → `base: '/项目名-hash/'`
- `src/App.tsx` → `basename: '/项目名-hash'`
- `index.html` → `<title>项目名-hash</title>`

## 创建后的步骤

```bash
# 进入项目目录
cd <项目名称>-<hash>

# 安装依赖
pnpm install

# 启动开发服务器
pnpm dev

# 构建生产版本
pnpm build

# 预览构建结果
pnpm preview
```

## 部署到 GitHub Pages

1. 在 GitHub 创建同名仓库（如：`my-awesome-app-abcd1234`）
2. 推送代码到仓库
3. 在仓库设置中启用 GitHub Pages，选择 "GitHub Actions" 作为源
4. 应用会自动部署到：`https://username.github.io/my-awesome-app-abcd1234/`

## 脚本特性

- ✅ 彩色输出，直观易读
- ✅ 参数验证，防止错误输入
- ✅ 路径检查，避免覆盖现有项目
- ✅ 统一替换，简化配置管理
- ✅ 自动清理，无冗余文件
- ✅ 完整提示，指导后续操作