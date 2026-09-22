import 'package:expenz/models/expenses_models.dart';
import 'package:expenz/models/income_category_model.dart';

class UserModel {
  final String email;
  final String password;
  final String name;
  final String uid;
  final String? profileImageUrl;
  final double targetAmount;
  final List<Income> incomes;
  final List<Expense> expenses;

  UserModel({
    required this.email,
    required this.password,
    required this.name,
    required this.uid,
    required this.profileImageUrl,
    required this.targetAmount,
    required this.incomes,
    required this.expenses,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'password': password,
      'uid': uid,
      'profileImageUrl': profileImageUrl,
      'targetAmount': targetAmount,
      'incomes': incomes.map((income) => income.toJson()).toList(),
      'expenses': expenses.map((expense) => expense.toJson()).toList(),
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'],
      password: json['password'],
      name: json['name'],
      uid: json['uid'],
      profileImageUrl: json['profileImageUrl'],
      targetAmount: json['targetAmount'],
      incomes: (json['incomes'] as List<dynamic>)
          .map((incomeJson) => Income.fromJSON(incomeJson))
          .toList(),
      expenses: (json['expenses'] as List<dynamic>)
          .map((expenseJson) => Expense.fromJSON(expenseJson))
          .toList(),
    );
  }
}
