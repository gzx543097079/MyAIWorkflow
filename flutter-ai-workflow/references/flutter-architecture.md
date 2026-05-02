# Flutter 架构

记账 App 使用 feature-first 目录结构。

```text
lib/
  main.dart
  app.dart
  core/
    constants/
    theme/
    utils/
  features/
    transaction/
      data/
      domain/
      presentation/
    category/
      data/
      domain/
      presentation/
    statistics/
      presentation/
    settings/
      presentation/
```

## 推荐技术栈

- Flutter
- Riverpod
- go_router
- Hive、Isar 或 Drift
- fl_chart
- intl
- uuid

## 数据流

```text
Page
-> Controller / Notifier
-> Repository
-> Local Database
```

## 规则

- UI 与持久化逻辑分离。
- 模型放在 `domain`。
- 数据库代码放在 `data`。
- Widget 和页面放在 `presentation`。
- 优先使用类型明确的模型，不要长期依赖 Map。
- 只有当前版本目标需要时，才添加新依赖。
- 除非用户明确要求，否则 V1.0 之前不要添加云同步。

## 存储选择

如果目标是快速实现简单本地持久化，使用 Hive。

如果应用需要更强的筛选、报表或查询性能，使用 Isar 或 Drift。

对于第一个 V1.0 记账 App，优先选择最简单、可靠、代码可读的本地存储方案。
