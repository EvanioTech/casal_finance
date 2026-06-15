import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/transaction_model.dart';
import '../models/goal_model.dart';
import '../models/notification_model.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Transactions
  Future<void> addTransaction(TransactionModel transaction) async {
    await _db.collection('transactions').add(transaction.toMap());
    
    // Disparar notificação
    final notif = NotificationModel(
      id: '',
      title: transaction.isExpense ? 'Nova Despesa Adicionada' : 'Nova Receita Adicionada',
      subtitle: 'Uma transação de R\$ ${transaction.amount.toStringAsFixed(2)} foi adicionada em ${transaction.category}.',
      iconName: transaction.isExpense ? 'shopping_cart_outlined' : 'account_balance_wallet_outlined',
      date: DateTime.now(),
      coupleId: transaction.coupleId,
    );
    await addNotification(notif);
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

    DocumentSnapshot goalDoc = await _db.collection('goals').doc(id).get();
    if (goalDoc.exists) {
      final goalData = goalDoc.data() as Map<String, dynamic>;
      final notif = NotificationModel(
        id: '',
        title: 'Progresso na Meta!',
        subtitle: 'Foram guardados mais R\$ ${additionalAmount.toStringAsFixed(2)} para a meta "${goalData['title']}".',
        iconName: 'emoji_events_outlined',
        date: DateTime.now(),
        coupleId: goalData['coupleId'] ?? '',
      );
      await addNotification(notif);
    }
  }

  // Notificações
  Future<void> addNotification(NotificationModel notification) async {
    await _db.collection('notifications').add(notification.toMap());
  }

  Stream<List<NotificationModel>> getNotifications(String coupleId) {
    return _db
        .collection('notifications')
        .where('coupleId', isEqualTo: coupleId)
        .snapshots()
        .map((snapshot) {
      var list = snapshot.docs.map((doc) => NotificationModel.fromMap(doc.id, doc.data())).toList();
      list.sort((a, b) => b.date.compareTo(a.date));
      return list;
    });
  }

  // Preferências
  Future<void> updateUserPreferences(String uid, {bool? pushEnabled, bool? emailEnabled, bool? darkMode}) async {
    Map<String, dynamic> updates = {};
    if (pushEnabled != null) updates['pushEnabled'] = pushEnabled;
    if (emailEnabled != null) updates['emailEnabled'] = emailEnabled;
    if (darkMode != null) updates['darkMode'] = darkMode;
    
    if (updates.isNotEmpty) {
      await _db.collection('users').doc(uid).update(updates);
    }
  }

  // Sincronização de Casal
  Future<String?> connectToPartner(String myUid, String partnerCode) async {
    try {
      if (myUid == partnerCode) return 'Você não pode conectar consigo mesmo.';
      
      DocumentSnapshot partnerDoc = await _db.collection('users').doc(partnerCode).get();
      if (!partnerDoc.exists) {
        return 'Código de parceiro inválido ou usuário não encontrado.';
      }

      DocumentSnapshot myDoc = await _db.collection('users').doc(myUid).get();
      if (!myDoc.exists) return 'Erro ao carregar seu perfil.';
      
      String oldCoupleId = (myDoc.data() as Map<String,dynamic>)['coupleId'] ?? myUid;

      // Se já estão conectados, não faz nada
      if (oldCoupleId == partnerCode) return 'Vocês já estão conectados!';

      // 1. Atualizar meu coupleId
      await _db.collection('users').doc(myUid).update({
        'coupleId': partnerCode,
      });

      // 2. Migrar minhas transações antigas para o novo coupleId
      QuerySnapshot txSnapshot = await _db.collection('transactions')
        .where('coupleId', isEqualTo: oldCoupleId)
        .where('createdBy', isEqualTo: myUid)
        .get();
        
      WriteBatch batch = _db.batch();
      for (var doc in txSnapshot.docs) {
        batch.update(doc.reference, {'coupleId': partnerCode});
      }

      // 3. Migrar minhas metas antigas (apenas se o oldCoupleId era o meu próprio UID, indicando que eu não estava em um casal antes)
      if (oldCoupleId == myUid) {
        QuerySnapshot goalSnapshot = await _db.collection('goals')
          .where('coupleId', isEqualTo: oldCoupleId)
          .get();
          
        for (var doc in goalSnapshot.docs) {
          batch.update(doc.reference, {'coupleId': partnerCode});
        }
      }

      await batch.commit();
      return null; // Sucesso
    } catch (e) {
      return 'Ocorreu um erro ao conectar: \$e';
    }
  }
}
