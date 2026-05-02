import 'package:flutter/material.dart';

enum StaticTransactionType { income, expense }

class StaticTransaction {
  const StaticTransaction({
    required this.title,
    required this.category,
    required this.amountCents,
    required this.type,
    required this.dateLabel,
    required this.icon,
  });

  final String title;
  final String category;
  final int amountCents;
  final StaticTransactionType type;
  final String dateLabel;
  final IconData icon;

  bool get isIncome => type == StaticTransactionType.income;
}

const staticTransactions = [
  StaticTransaction(
    title: '午餐',
    category: '餐饮',
    amountCents: 3800,
    type: StaticTransactionType.expense,
    dateLabel: '05-02',
    icon: Icons.restaurant_outlined,
  ),
  StaticTransaction(
    title: '地铁',
    category: '交通',
    amountCents: 600,
    type: StaticTransactionType.expense,
    dateLabel: '05-02',
    icon: Icons.directions_subway_outlined,
  ),
  StaticTransaction(
    title: '工资',
    category: '收入',
    amountCents: 1280000,
    type: StaticTransactionType.income,
    dateLabel: '05-01',
    icon: Icons.payments_outlined,
  ),
  StaticTransaction(
    title: '咖啡',
    category: '餐饮',
    amountCents: 2200,
    type: StaticTransactionType.expense,
    dateLabel: '05-01',
    icon: Icons.local_cafe_outlined,
  ),
  StaticTransaction(
    title: '房租',
    category: '居住',
    amountCents: 320000,
    type: StaticTransactionType.expense,
    dateLabel: '04-30',
    icon: Icons.home_outlined,
  ),
];

int staticIncomeTotalCents() {
  return staticTransactions
      .where((transaction) => transaction.isIncome)
      .fold(0, (sum, transaction) => sum + transaction.amountCents);
}

int staticExpenseTotalCents() {
  return staticTransactions
      .where((transaction) => !transaction.isIncome)
      .fold(0, (sum, transaction) => sum + transaction.amountCents);
}
