# 项目状态

最后更新：2026-05-02

当前项目：`money_flow`

## 当前版本

| 版本 | 状态 | 说明 |
|---|---|---|
| V0.1 项目初始化版 | 已完成 | Flutter 项目、iOS/Android 支持、基础首页、主题 token、规范约束、测试和提交已完成 |
| V0.2 静态 UI 版 | 已完成 | 底部导航、首页、明细、记一笔、统计、设置和静态数据展示已完成 |
| V0.3 领域模型版 | 已完成 | Transaction、Category、TransactionType 已定义，UI 已使用类型明确的领域模型 |
| V0.4 本地存储版 | 已完成 | 已选择 Hive，交易记录可本地保存、加载和删除，iOS/Android 模拟器运行通过 |
| V0.5 记一笔流程版 | 已完成 | 完整记一笔表单、金额校验、分类/日期/备注输入和保存后数据刷新已完成 |
| V0.6 统计分析版 | 下一步 | 需要让统计页使用真实交易数据展示月度和分类洞察 |

## V0.1 完成记录

完成内容：
- 创建 `money_flow` Flutter 项目。
- 支持 iOS 和 Android。
- 添加 `main.dart`、`app.dart`。
- 添加基础主题和首页。
- 建立 feature-first 目录结构。
- 添加代码规范和 UI 规范。
- 添加 `flutter-ai-workflow` Skill。
- 添加通用 `.gitignore`。
- 创建并验证 Android 模拟器 `money_flow_pixel`。
- 完成 Git 提交。

验证结果：
- `flutter doctor -v`：通过。
- `dart format lib test`：通过。
- `flutter analyze`：通过。
- `flutter test`：通过。
- iOS 模拟器运行：通过。
- Android 模拟器运行：通过。
- Android debug APK 构建：通过。

提交记录：

```text
d64ef46 chore: initialize flutter workflow and app
```

## V0.5 完成记录

完成内容：
- 将新增记录页从静态预览改为完整表单。
- 支持金额、收入/支出类型、分类、日期和备注。
- 分类选项会根据交易类型过滤。
- 金额使用文本解析后转为分，避免用浮点数保存业务金额。
- 保存后通过 `TransactionController` 写入 Repository，并刷新首页与明细数据。
- 表单保存成功后清空输入并显示提示。
- 更新设置页版本名为 `V0.5 记一笔流程版`。
- 更新 widget 测试，覆盖真实填写表单后保存交易。

验证结果：
- `dart format lib test`：通过。
- `flutter analyze`：通过。
- `flutter test`：通过。
- iOS 模拟器 `iPhone 17` 运行：通过。
- Android 模拟器 `emulator-5554` 运行：通过。

## 下一次开始位置

从 V0.6 开始。

目标：让统计页展示来自真实交易记录的分析结果。

优先任务：
1. 计算月度收入、支出和结余。
2. 计算分类支出占比或排行。
3. 计算每日趋势。
4. 将统计页改为读取真实交易数据。
5. 补充统计逻辑测试。
6. 运行 `dart format lib test`、`flutter analyze`、`flutter test`。
7. 运行 iOS 模拟器和 Android 模拟器验证。
