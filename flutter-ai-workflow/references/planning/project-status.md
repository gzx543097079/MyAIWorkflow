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
| V0.6 统计分析版 | 已完成 | 统计页已使用真实交易数据展示月度汇总、分类支出和每日趋势 |
| V0.7 分类管理版 | 已完成 | 分类已支持本地存储、新增、编辑、删除，并接入记一笔流程 |
| V0.8 状态管理重构版 | 已完成 | 已新增应用级状态控制器，收拢交易和分类状态拼装 |
| V0.9 体验优化版 | 下一步 | 需要补齐空状态、加载状态、错误状态、筛选和深色模式 |

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
- iOS 模拟器 `iPhone 17` 运行：通过。
- Android 模拟器 `emulator-5554` 运行：通过。
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

## V0.6 完成记录

完成内容：
- 新增 `MonthlyStatistics` 领域模型。
- 统计页的月度收入、支出和结余来自真实交易记录。
- 分类支出统计按本月真实支出汇总，并按金额降序展示。
- 每日支出趋势按本月真实支出记录动态生成。
- 统计页加入无分类统计和无趋势数据的空状态。
- 更新设置页版本名为 `V0.6 统计分析版`。
- 新增统计逻辑单元测试。
- 更新 widget 测试，覆盖真实统计数据展示。

验证结果：
- `dart format lib test`：通过。
- `flutter analyze`：通过。
- `flutter test`：通过。
- iOS 模拟器 `iPhone 17` 运行：通过。
- Android 模拟器 `emulator-5554` 运行：通过。

## V0.7 完成记录

完成内容：
- 新增分类 Repository 抽象和 Hive 本地存储实现。
- 新增 `CategoryController` 管理分类加载、保存和删除。
- App 启动时加载默认收入和支出分类。
- 设置页支持新增、编辑和删除分类。
- 删除分类时保留每种类型至少一个分类。
- 记一笔流程使用当前分类列表。
- 首页、明细和统计页使用当前分类列表解析分类名称。
- 更新设置页版本名为 `V0.7 分类管理版`。
- 新增分类 Repository 测试。
- 更新 widget 测试，覆盖新增分类后记一笔流程可使用该分类。

验证结果：
- `dart format lib test`：通过。
- `flutter analyze`：通过。
- `flutter test`：通过。
- iOS 模拟器 `iPhone 17` 运行：通过。
- Android 模拟器 `emulator-5554` 运行：通过。

## V0.8 完成记录

完成内容：
- 评估 Riverpod：当前阶段继续沿用既有 `ChangeNotifier + Repository` 模式，避免为状态边界重构引入额外依赖。
- 新增 `AppStateController` 应用级状态控制器。
- 交易和分类状态加载已集中到 `AppStateController`。
- 交易新增、删除和分类保存、删除入口已通过 `AppStateController` 统一转发。
- `_AppShell` 已减少状态拼装逻辑，只保留导航状态和页面装配。
- UI 仍不直接访问数据库。
- 新增应用状态控制器测试，覆盖加载、交易更新、分类更新和默认分类回退。
- 更新设置页版本名为 `V0.8 状态管理重构版`。

验证结果：
- `dart format lib test`：通过。
- `flutter analyze`：通过。
- `flutter test`：通过。
- iOS 模拟器 `iPhone 17` 运行：通过。
- Android 模拟器 `emulator-5554` 运行：通过。

## 下一次开始位置

从 V0.9 开始。

目标：提升真实产品使用体验和异常状态处理。

优先任务：
1. 补齐空状态和加载状态。
2. 增加错误状态处理。
3. 完善删除确认和错误提示。
4. 增加日期筛选。
5. 增加月份切换。
6. 支持深色模式。
7. 运行 `dart format lib test`、`flutter analyze`、`flutter test`。
8. 运行 iOS 模拟器和 Android 模拟器验证。
