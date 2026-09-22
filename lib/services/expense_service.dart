import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenz/models/expenses_models.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ExpenseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> _currentUserId() async {
    return FirebaseAuth.instance.currentUser?.uid;
  }

  Future<void> saveExpenses(Expense expense, BuildContext context) async {
    try {
      final userId = await _currentUserId();
      if (userId == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please sign in to save expenses.')),
          );
        }
        return;
      }

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('expenses')
          .doc(expense.category.toString())
          .set(expense.toJson());

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Expenses added successfully...')),
        );
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Error...')));
      }
    }
  }

  Future<List<Expense>> loadExpense() async {
    final userId = await _currentUserId();
    if (userId == null) return [];

    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('expenses')
        .get();

    return snapshot.docs.map((doc) => Expense.fromJSON(doc.data())).toList();
  }

  Future<void> deleteExpenses(int id, BuildContext context) async {
    try {
      final userId = await _currentUserId();
      if (userId == null) return;

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('expenses')
          .doc(id.toString())
          .delete();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Expense deleted successfully'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Error...')));
      }
    }
  }

  Future<void> deleAllExpenses(BuildContext contex) async {
    try {
      final userId = await _currentUserId();
      if (userId == null) return;

      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('expenses')
          .get();

      for (final doc in snapshot.docs) {
        await doc.reference.delete();
      }

      if (contex.mounted) {
        ScaffoldMessenger.of(
          contex,
        ).showSnackBar(const SnackBar(content: Text('All expenses deleted')));
      }
    } catch (err) {
      if (contex.mounted) {
        ScaffoldMessenger.of(
          contex,
        ).showSnackBar(const SnackBar(content: Text('Error')));
      }
    }
  }
}
