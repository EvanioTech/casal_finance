import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/transaction_model.dart';
import '../models/goal_model.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Transactions
  Future<void> addTransaction(TransactionModel transaction) async {
    await _db.collection('transactions').add(transaction.toMap());
  }

  Stream<List<TransactionModel>> getTransactions(String coupleId) {
    return _db
        .collection('transactions')
        .where('coupleId', isEqualTo: coupleId)
        .snapshots()
        .map((snapshot) {
      var list = snapshot.docs.map((doc) => TransactionModel.fromMap(doc.id, doc.data())).toList();
      list.sort((a, b) => b.date.compareTo(a.date));
      return list;
    });
  }

  Future<void> deleteTransaction(String id) async {
    await _db.collection('transactions').doc(id).delete();
  }

  // Goals
  Future<void> addGoal(GoalModel goal) async {
    await _db.collection('goals').add(goal.toMap());
  }

  Stream<List<GoalModel>> getGoals(String coupleId) {
    return _db
        .collection('goals')
        .where('coupleId', isEqualTo: coupleId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => GoalModel.fromMap(doc.id, doc.data())).toList();
    });
  }

  Future<void> updateGoalProgress(String id, double additionalAmount) async {
    await _db.collection('goals').doc(id).update({
      'savedAmount': FieldValue.increment(additionalAmount),
    });
  }
}
