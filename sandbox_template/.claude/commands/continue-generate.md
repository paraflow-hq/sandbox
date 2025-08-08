# /continue-generate

## commands 功能
在应用模板已完成的基础上，继续实现剩余原型功能

## commands 调用方式
- /continue-generate

## commands 任务（严格按照下面的步骤规划 TODO List）
1. 继续完成对剩余原型功能的实现
  - 确保功能无误，体现应用原型能力，UI 部分直接按照 Html 的样式生成
2. 通过 `pnpm build` 保证编译不报错即可
3. 调用 sh deploy.sh -n {应用文件夹名} -d {描述} 来上传到 github（我已经提供了可用的 token & gh cli），直接执行即可。将部署好的 github repo 和 pages 地址返回给我

## React 注意事项
- 在 import 类型时使用 import type
- 在 react 函数组件中如果一个变量没有使用到则不要添加

## 依赖安装
- 只能使用 pnpm 安装依赖，不能使用 npm