---
name: flutter-ai-workflow
description: 指导 Codex 使用可复用、分版本的 AI 工作流来规划、构建、审查和迭代 Flutter iOS/Android 应用。适用于用户想创建 Flutter 项目、按 V0.1 到 V1.0 阶段目标推进、开发记账 App、设计应用架构、生成开发提示词、检查发布准备情况，或判断下一步应该做什么。
---

# Flutter AI 工作流

使用这个 Skill，把一个 Flutter 移动应用从想法推进到可发布版本。工作方式是：小版本、明确目标、可执行任务、可验证结果。

如果用户没有指定产品方向，默认使用“个人记账 App”作为示例项目。

## 工作循环

处理每个请求时，按这个顺序工作：

1. 读取 `references/project-status.md` 判断当前版本，或帮助用户选择应该进入的版本。
2. 读取最相关、最小范围的参考文件。
3. 说明当前版本目标和完成标准。
4. 规划或实现一个最小可用的下一步改动。
5. 使用 Flutter 命令、测试或人工检查完成验证。
6. 总结结果，并指出下一步建议。

## 修改代码前置规则

当修改当前仓库里的 `money_flow` Flutter 项目代码时，必须先读取项目约束：

- `money_flow/docs/constraints/code-standards.md`
- `money_flow/docs/constraints/ui-standards.md`

修改代码时必须遵守这些约束：

- 遵循 feature-first 架构。
- 优先使用已有 theme、spacing、radii、strings 等 token。
- 不在页面中新增重复的裸写颜色、间距、圆角或业务文案。
- 不提前加入当前版本目标之外的依赖和功能。

修改完成后必须在 `money_flow` 目录运行：

```bash
dart format lib test
flutter analyze
flutter test
```

如果改动涉及 Android 构建、原生配置或平台兼容性，再运行：

```bash
flutter build apk --debug
```

## 参考文件导航

当用户询问这些内容时，读取 `references/version-roadmap.md`：

- V0.1 到 V1.0 规划
- 功能范围
- 版本目标
- 完成标准
- 下一步应该做什么

当用户询问当前进度、下一步、从哪里继续时，优先读取 `references/project-status.md`。

当用户询问这些内容时，读取 `references/flutter-architecture.md`：

- Flutter 目录结构
- Riverpod、Repository、Controller 设计
- 本地存储选择
- feature-first 模块划分
- iOS 和 Android 项目注意事项

当用户询问这些内容时，读取 `references/prompt-templates.md`：

- 可复用 AI 提示词
- 版本规划提示词
- 功能实现提示词
- 代码审查提示词
- 测试提示词

当用户询问这些内容时，读取 `references/release-checklist.md`：

- V1.0 发布准备
- iOS 和 Android 验证
- 数据安全检查
- UI 和测试检查
- 发布前准备

## 默认产品

当使用记账 App 示例时，默认包含这些核心功能：

- 收入和支出记录
- 分类管理
- 明细列表
- 月度统计
- 本地持久化
- iOS 和 Android 支持
- V1.0 之后再考虑 AI 消费分析

除非用户明确要求，否则 V1.0 之前不要加入登录、云同步、订阅会员或复杂 AI 分析。
