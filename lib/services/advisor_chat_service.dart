import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdvisorChatMessage {
  const AdvisorChatMessage({
    required this.id,
    required this.text,
    required this.senderType,
    required this.createdAt,
  });

  factory AdvisorChatMessage.fromDoc(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};
    return AdvisorChatMessage(
      id: doc.id,
      text: data['text'] as String? ?? '',
      senderType: data['senderType'] as String? ?? 'user',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  final String id;
  final String text;
  final String senderType; // 'user' | 'admin'
  final DateTime createdAt;

  bool get isFromUser => senderType == 'user';
}

class AdvisorChatSummary {
  const AdvisorChatSummary({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.advisorName,
    required this.consultationType,
    required this.lastMessage,
    required this.unreadByAdmin,
    required this.updatedAt,
    required this.userProfile,
  });

  factory AdvisorChatSummary.fromDoc(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    return AdvisorChatSummary(
      id: doc.id,
      userId: data['userId'] as String? ?? '',
      userName: data['userName'] as String? ?? '',
      userEmail: data['userEmail'] as String? ?? '',
      advisorName: data['advisorName'] as String? ?? '',
      consultationType: data['consultationType'] as String? ?? '',
      lastMessage: data['lastMessage'] as String? ?? '',
      unreadByAdmin: data['unreadByAdmin'] as bool? ?? false,
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
      userProfile: data['userProfile'] as Map<String, dynamic>? ?? {},
    );
  }

  final String id;
  final String userId;
  final String userName;
  final String userEmail;
  final String advisorName;
  final String consultationType;
  final String lastMessage;
  final bool unreadByAdmin;
  final DateTime? updatedAt;
  final Map<String, dynamic> userProfile;
}

class AdvisorChatService {
  AdvisorChatService({FirebaseFirestore? firestore, FirebaseAuth? auth})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  CollectionReference<Map<String, dynamic>> get _chatsRef =>
      _firestore.collection('advisor_chats');

  /// Kullanıcının bu danışmanla açık bir konuşması varsa döndürür,
  /// yoksa yeni bir konuşma oluşturur.
  Future<String> getOrCreateChat({
    required String advisorName,
    required String consultationType,
    required Map<String, dynamic> userProfile,
  }) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception('Oturum açılmamış.');

    final existing = await _chatsRef
        .where('userId', isEqualTo: uid)
        .where('advisorName', isEqualTo: advisorName)
        .where('status', isEqualTo: 'open')
        .limit(1)
        .get();

    if (existing.docs.isNotEmpty) {
      return existing.docs.first.id;
    }

    final docRef = await _chatsRef.add({
      'userId': uid,
      'userEmail': _auth.currentUser?.email ?? '',
      'userName': userProfile['name'] ?? '',
      'advisorName': advisorName,
      'consultationType': consultationType,
      'status': 'open',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'lastMessage': '',
      'unreadByAdmin': false,
      'userProfile': userProfile,
    });

    return docRef.id;
  }

  /// Kullanıcı tarafı: mesaj akışı
  Stream<List<AdvisorChatMessage>> messagesStream(String chatId) {
    return _chatsRef
        .doc(chatId)
        .collection('messages')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((d) => AdvisorChatMessage.fromDoc(d)).toList(),
        );
  }

  /// Mesaj gönder — senderType: 'user' veya 'admin'
  Future<void> sendMessage({
    required String chatId,
    required String text,
    required String senderType,
  }) async {
    final batch = _firestore.batch();

    final msgRef = _chatsRef.doc(chatId).collection('messages').doc();
    batch.set(msgRef, {
      'text': text,
      'senderType': senderType,
      'createdAt': FieldValue.serverTimestamp(),
      'read': false,
    });

    batch.update(_chatsRef.doc(chatId), {
      'lastMessage': text,
      'updatedAt': FieldValue.serverTimestamp(),
      'unreadByAdmin': senderType == 'user',
      'unreadByUser': senderType == 'admin',
    });

    await batch.commit();
  }

  /// Admin: tüm konuşmaları listele
  Stream<List<AdvisorChatSummary>> allChatsStream() {
    return _chatsRef
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((d) => AdvisorChatSummary.fromDoc(d)).toList(),
        );
  }

  /// Admin: belirli chat'i okundu işaretle
  Future<void> markReadByAdmin(String chatId) async {
    await _chatsRef.doc(chatId).update({'unreadByAdmin': false});
  }
}
