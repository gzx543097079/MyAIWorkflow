# 代码规范约束

本项目使用 feature-first 架构。所有代码改动必须满足以下约束。

## 目录约束

- `lib/main.dart` 只负责启动 App。
- `lib/app.dart` 只负责应用根组件、主题和路由入口。
- `lib/core/` 存放跨功能共享的常量、主题、工具和通用组件。
- `lib/features/<feature>/domain/` 存放模型和领域规则。
- `lib/features/<feature>/data/` 存放本地存储、Repository 和数据转换。
- `lib/features/<feature>/presentation/` 存放页面、组件和状态控制器。

## Dart 约束

- 使用 `flutter_lints`，并开启严格类型推断。
- 禁止无必要的 `dynamic`。
- 禁止在业务代码里使用 `print`。
- 优先使用 `const`。
- 局部变量默认使用 `final`。
- import 按 Dart、Flutter、package、相对路径分组排序。
- 公开 API 命名必须表达业务含义，避免 `Page1`、`WidgetA` 这类临时名称。

## 状态和数据约束

- V0.1 到 V0.2 可以使用静态数据。
- 从 V0.3 开始必须引入类型明确的 domain model。
- UI 不直接访问数据库。
- 数据读写必须通过 Repository。
- 金额计算不得使用浮点数直接承载最终业务金额；进入持久化前应考虑用分为单位或专门金额类型。

## 验证约束

每次功能改动后至少运行：

```bash
dart format lib test
flutter analyze
flutter test
```

涉及 Android 构建时运行：

```bash
flutter build apk --debug
```
