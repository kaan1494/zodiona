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
    required this.unreadByUser,
    required this.updatedAt,
    required this.userProfile,
    required this.status,
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
      unreadByUser: data['unreadByUser'] as bool? ?? false,
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
      userProfile: data['userProfile'] as Map<String, dynamic>? ?? {},
      status: data['status'] as String? ?? 'open',
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
  final bool unreadByUser;
  final DateTime? updatedAt;
  final Map<String, dynamic> userProfile;
  final String status; // 'open' | 'closed'

  bool get isClosed => status == 'closed';
}

/// Ãœcretsiz danÄ±ÅŸmanlÄ±k eriÅŸim kaydÄ±.
class FreeConsultationGrant {
  const FreeConsultationGrant({
    required this.id,
    required this.userId,
    required this.userEmail,
    required this.productId,
    required this.consultationType,
    required this.advisorName,
    required this.grantedAt,
    required this.used,
    this.chatId,
  });

  factory FreeConsultationGrant.fromDoc(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    return FreeConsultationGrant(
      id: doc.id,
      userId: data['userId'] as String? ?? '',
      userEmail: data['userEmail'] as String? ?? '',
      productId: data['productId'] as String? ?? '',
      consultationType: data['consultationType'] as String? ?? '',
      advisorName: data['advisorName'] as String? ?? '',
      grantedAt: (data['grantedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      used: data['used'] as bool? ?? false,
      chatId: data['chatId'] as String?,
    );
  }

  final String id;
  final String userId;
  final String userEmail;
  final String productId;
  final String consultationType;
  final String advisorName;
  final DateTime grantedAt;
  final bool used;
  final String? chatId;
}

class AdvisorChatService {
  AdvisorChatService({FirebaseFirestore? firestore, FirebaseAuth? auth})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  CollectionReference<Map<String, dynamic>> get _chatsRef =>
      _firestore.collection('advisor_chats');

  CollectionReference<Map<String, dynamic>> get _grantsRef =>
      _firestore.collection('free_consultations');

  /// KullanÄ±cÄ±nÄ±n bu danÄ±ÅŸmanla aÃ§Ä±k bir konuÅŸmasÄ± varsa dÃ¶ndÃ¼rÃ¼r,
  /// yoksa yeni bir konuÅŸma oluÅŸturur.
  Future<String> getOrCreateChat({
    required String advisorName,
    required String consultationType,
    required Map<String, dynamic> userProfile,
  }) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception('Oturum aÃ§Ä±lmamÄ±ÅŸ.');

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

  /// KullanÄ±cÄ± tarafÄ±: mesaj akÄ±ÅŸÄ±
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

  /// Chat durum akÄ±ÅŸÄ± (open / closed).
  Stream<String> chatStatusStream(String chatId) {
    return _chatsRef
        .doc(chatId)
        .snapshots()
        .map((snap) => snap.data()?['status'] as String? ?? 'open');
  }

  /// Mesaj gÃ¶nder â€” senderType: 'user' veya 'admin'
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

  /// Admin: sohbeti sonlandÄ±r.
  Future<void> closeChat(String chatId) async {
    await _chatsRef.doc(chatId).update({
      'status': 'closed',
      'closedAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Admin: sohbeti yeniden aÃ§.
  Future<void> reopenChat(String chatId) async {
    await _chatsRef.doc(chatId).update({
      'status': 'open',
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Admin: tÃ¼m konuÅŸmalarÄ± listele
  Stream<List<AdvisorChatSummary>> allChatsStream() {
    return _chatsRef
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((d) => AdvisorChatSummary.fromDoc(d)).toList(),
        );
  }

  /// KullanÄ±cÄ±: kendi konuÅŸmalarÄ±nÄ± listele
  Stream<List<AdvisorChatSummary>> userChatsStream(String userId) {
    return _chatsRef.where('userId', isEqualTo: userId).snapshots().map((snap) {
      final list = snap.docs.map((d) => AdvisorChatSummary.fromDoc(d)).toList();
      list.sort((a, b) {
        if (a.updatedAt == null && b.updatedAt == null) return 0;
        if (a.updatedAt == null) return 1;
        if (b.updatedAt == null) return -1;
        return b.updatedAt!.compareTo(a.updatedAt!);
      });
      return list;
    });
  }

  /// Admin: belirli chat'i okundu iÅŸaretle
  Future<void> markReadByAdmin(String chatId) async {
    await _chatsRef.doc(chatId).update({'unreadByAdmin': false});
  }

  // â”€â”€ Ãœcretsiz EriÅŸim YÃ¶netimi â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  /// Admin: belirli bir kullanıcı için (UID ile) direkt sohbet oluşturur.
  Future<String> adminCreateChatForUser({
    required String userId,
    required String userEmail,
    required String advisorName,
    required String consultationType,
    required Map<String, dynamic> userProfile,
  }) async {
    final docRef = await _chatsRef.add({
      'userId': userId,
      'userEmail': userEmail,
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

  /// Admin: kullanıcıya ücretsiz danışmanlık erişimi ver.
  Future<String> grantFreeConsultation({
    required String userId,
    required String userEmail,
    required String productId,
    required String consultationType,
    required String advisorName,
  }) async {
    final doc = await _grantsRef.add({
      'userId': userId,
      'userEmail': userEmail,
      'productId': productId,
      'consultationType': consultationType,
      'advisorName': advisorName,
      'grantedAt': FieldValue.serverTimestamp(),
      'used': false,
      'chatId': null,
    });
    return doc.id;
  }

  /// KullanÄ±cÄ±: belirli bir Ã¼rÃ¼n iÃ§in kullanÄ±lmamÄ±ÅŸ Ã¼cretsiz eriÅŸimi kontrol et.
  Future<FreeConsultationGrant?> checkFreeGrant({
    required String userId,
    required String productId,
  }) async {
    final snap = await _grantsRef
        .where('userId', isEqualTo: userId)
        .where('productId', isEqualTo: productId)
        .where('used', isEqualTo: false)
        .limit(1)
        .get();

    if (snap.docs.isEmpty) return null;
    return FreeConsultationGrant.fromDoc(snap.docs.first);
  }

  /// Ücretsiz erişimi kullanÄ±ldÄ± olarak iÅŸaretle ve chatId'yi kaydet.
  Future<void> markGrantUsed(String grantId, String chatId) async {
    await _grantsRef.doc(grantId).update({
      'used': true,
      'chatId': chatId,
      'usedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Admin: tÃ¼m Ã¼cretsiz eriÅŸim kayÄ±tlarÄ±nÄ± listele.
  Stream<List<FreeConsultationGrant>> allGrantsStream() {
    return _grantsRef
        .orderBy('grantedAt', descending: true)
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((d) => FreeConsultationGrant.fromDoc(d)).toList(),
        );
  }

  /// Admin: belirli bir kullanÄ±cÄ±nÄ±n Ã¼cretsiz eriÅŸim kayÄ±tlarÄ±.
  Stream<List<FreeConsultationGrant>> userGrantsStream(String userId) {
    return _grantsRef
        .where('userId', isEqualTo: userId)
        .orderBy('grantedAt', descending: true)
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((d) => FreeConsultationGrant.fromDoc(d)).toList(),
        );
  }

  /// Admin: Ã¼cretsiz eriÅŸim kaydÄ±nÄ± sil.
  Future<void> deleteGrant(String grantId) async {
    await _grantsRef.doc(grantId).delete();
  }
}
