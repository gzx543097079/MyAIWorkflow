# 版本状态

当前版本进度：V0.6 已完成。

下一步版本：V0.7 分类管理版。

## V0.1 完成项

- Flutter 项目已创建。
- iOS 模拟器运行通过。
- Android 模拟器运行通过。
- Android debug APK 构建通过。
- `main.dart` 和 `app.dart` 已拆分。
- 基础主题和首页已创建。
- feature-first 目录结构已创建。
- 代码规范和 UI 规范已创建。
- 测试通过。

## V0.2 完成项

- 底部导航已创建。
- 首页展示静态月度汇总和最近记录。
- 明细页展示静态记账列表。
- 记一笔页展示静态表单预览。
- 统计页展示静态月度指标、分类概览和支出趋势。
- 设置页展示静态设置入口。
- V0.2 未接数据库。
- `dart format lib test` 通过。
- `flutter analyze` 通过。
- `flutter test` 通过。

## V0.3 完成项

- `Transaction` 领域模型已创建。
- `Category` 领域模型已创建。
- `TransactionType` 领域枚举已创建。
- 静态记账数据已改为使用类型明确的领域模型。
- UI 已通过 `Transaction` 和 `Category` 展示首页、明细和统计。
- 金额继续使用分为单位的整数。
- V0.3 未接数据库。
- `dart format lib test` 通过。
- `flutter analyze` 通过。
- `flutter test` 通过。

## V0.4 完成项

- 本地存储方案已选择 Hive。
- 已建立 `TransactionRepository` 抽象。
- 已建立 Hive 本地存储实现。
- App 启动时会加载本地交易记录。
- 首次启动会写入 V0.3 静态示例记录。
- 可以保存一条预览交易记录。
- 可以从明细页删除交易记录。
- App 重启后仍能加载已保存记录。
- `dart format lib test` 通过。
- `flutter analyze` 通过。
- `flutter test` 通过。
- `flutter build apk --debug` 通过。
- `flutter build ios --simulator` 通过。
- iOS 模拟器运行通过，未再出现 native assets SdkRoot 提示。
- Android 模拟器运行通过。

## V0.5 完成项

- 记一笔页面已从静态预览改为完整表单。
- 已支持金额输入，并按分为单位保存。
- 已支持收入或支出类型选择。
- 分类选择会根据收入或支出类型过滤。
- 已支持日期选择。
- 已支持备注输入。
- 已加入金额表单校验。
- 保存合法交易后会写入 Repository，并触发首页汇总和明细列表刷新。
- 保存完成后会清空表单并显示成功提示。
- 设置页版本名已更新为 `V0.5 记一笔流程版`。
- `dart format lib test` 通过。
- `flutter analyze` 通过。
- `flutter test` 通过。
- iOS 模拟器 `iPhone 17` 运行通过。
- Android 模拟器 `emulator-5554` 运行通过。

## V0.6 完成项

- 已新增 `MonthlyStatistics` 月度统计领域模型。
- 统计页月度收入、支出和结余已来自真实交易记录。
- 分类支出统计已按本月真实支出汇总并排序。
- 每日支出趋势已按本月真实支出记录动态生成。
- 统计页已加入本月无支出时的空状态。
- 设置页版本名已更新为 `V0.6 统计分析版`。
- 已新增统计逻辑单元测试。
- 已更新 widget 测试，覆盖统计页真实数据展示。
- `dart format lib test` 通过。
- `flutter analyze` 通过。
- `flutter test` 通过。
- iOS 模拟器 `iPhone 17` 运行通过。
- Android 模拟器 `emulator-5554` 运行通过。

## 下一步

从 V0.7 开始，实现：

- 默认收入分类和默认支出分类管理。
- 新增分类。
- 编辑分类。
- 删除分类。
- 记一笔流程接入可管理分类。

V0.7 阶段让用户可以自定义收入和支出分类。
