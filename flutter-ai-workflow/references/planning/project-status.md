# 项目状态

最后更新：2026-05-02

当前项目：`money_flow`

## 当前版本

| 版本 | 状态 | 说明 |
|---|---|---|
| V0.1 项目初始化版 | 已完成 | Flutter 项目、iOS/Android 支持、基础首页、主题 token、规范约束、测试和提交已完成 |
| V0.2 静态 UI 版 | 已完成 | 底部导航、首页、明细、记一笔、统计、设置和静态数据展示已完成 |
| V0.3 领域模型版 | 已完成 | Transaction、Category、TransactionType 已定义，UI 已使用类型明确的领域模型 |
| V0.4 本地存储版 | 下一步 | 需要选择本地存储方案，并持久化交易记录 |

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

## 下一次开始位置

从 V0.4 开始。

目标：把交易记录持久化到本地。

优先任务：
1. 选择 Hive、Isar 或 Drift。
2. 建立 Repository 层。
3. 支持新增一笔交易。
4. 支持删除一笔交易。
5. App 重启后仍能加载记录。
6. 运行 `dart format lib test`、`flutter analyze`、`flutter test`。
