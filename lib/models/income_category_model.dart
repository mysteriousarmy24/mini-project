import 'package:flutter/material.dart';

enum IncomeCategory { freelance, salary, passive, sales, Other }

//category images
final Map<IncomeCategory, String> incomeCategoryImages = {
  IncomeCategory.freelance: "assets/images/freelance.png",
  IncomeCategory.passive: "assets/images/passive.png",
  IncomeCategory.salary: "assets/images/salary.png",
  IncomeCategory.sales: "assets/images/sales.png",
  IncomeCategory.Other: "assets/images/sales.png",
};
//category colors
final Map<IncomeCategory, Color> incomeCategoryColors = {
  IncomeCategory.freelance: const Color(0xFFE57373),
  IncomeCategory.passive: const Color(0xFF81C784),
  IncomeCategory.sales: const Color(0xFF64B5F6),
  IncomeCategory.salary: const Color(0xFFFFD54F),
  IncomeCategory.Other: const Color.fromARGB(255, 152, 79, 255),
};

class Income {
  final String id;
  final String title;
  final double amount;
  final IncomeCategory category;
  final DateTime date;
  final DateTime time;
  final String userId;

  Income({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    required this.time,
    required this.userId,
  });
  //JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'description': userId,
      'category': category.index,
      'date': date.toIso8601String(),
      'time': time.toIso8601String(),
    };
  }

  //JSON deserialization
  factory Income.fromJSON(Map<String, dynamic> json) {
    return Income(
      id: json['id'],
      title: json['title'],
      amount: json['amount'],
      category: IncomeCategory.values[json['category']],
      date: DateTime.parse(json['date']),
      time: DateTime.parse(json['time']),
      userId: json['description'],
    );
  }
}
