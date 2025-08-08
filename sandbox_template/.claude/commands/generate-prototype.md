# /generate-prototype

## commands 功能
- 以 HTML 和产品描述生成 React 原型 APP

## commands 调用方式
- /generate-prototype

## commands 任务（严格按照下面的步骤规划 TODO List）
1. 理解文件夹中的 product_plan.md / screen_plan.md 想实现的功能以及 html 页面想实现的页面样式
2. 执行 sh scripts/create-project.sh 创建应用模板(我已经验证过这个 shell 的内容和兼容性问题，可以直接执行).这一步创建的模板会自带一个 hash，不需要变更模板的名字或文件夹名
3. 进入应用模板，理解其中的 React 模板结构
4. 先选择一个最核心的页面来实现应用原型功能
  - 确保功能无误，体现应用原型能力，UI 部分直接按照 Html 的样式生成
  - 需要保证路由和导航可用

## React 注意事项
- 在 import 类型时使用 import type
- 在 react 函数组件中如果一个变量没有使用到则不要添加

## 依赖安装
- 只能使用 pnpm 安装依赖，不能使用 npm