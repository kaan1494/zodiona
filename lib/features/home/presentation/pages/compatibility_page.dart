import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'add_friend_flow_page.dart';
import '../../../../services/astro_api_service.dart';
import '../../../../utils/zodiac.dart';

class CompatibilityPage extends StatefulWidget {
  const CompatibilityPage({super.key});

  @override
  State<CompatibilityPage> createState() => _CompatibilityPageState();
}

class _CompatibilityPageState extends State<CompatibilityPage> {
  final _astroApiService = const AstroApiService();
  static const _friendAstroRetryInterval = Duration(seconds: 20);
  final Set<String> _inFlightFriendRequests = <String>{};
  final Map<String, DateTime> _lastFriendAstroAttemptAt = <String, DateTime>{};
  Timer? _friendAstroRetryTicker;

  @override
  void initState() {
    super.initState();
    _friendAstroRetryTicker = Timer.periodic(_friendAstroRetryInterval, (_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _friendAstroRetryTicker?.cancel();
    super.dispose();
  }

  bool _hasCompatibilityFriends(dynamic friendsData) {
    if (friendsData is Map<String, dynamic>) {
      return friendsData.isNotEmpty;
    }
    if (friendsData is List) {
      return friendsData.isNotEmpty;
    }
    return false;
  }

  bool _isKnownAstroValue(String? value) {
    final normalized = value?.trim();
    if (normalized == null || normalized.isEmpty) {
      return false;
    }
    return normalized != 'Bilinmiyor' && normalized != 'Yukleniyor...';
  }

  DateTime? _buildLocalBirthDateTime({
    required DateTime? birthDate,
    required String? birthTime,
  }) {
    if (birthDate == null || birthTime == null || birthTime.trim().isEmpty) {
      return null;
    }

    final parts = birthTime.trim().split(':');
    if (parts.length != 2) {
      return null;
    }

    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) {
      return null;
    }
    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
      return null;
    }

    return DateTime(
      birthDate.year,
      birthDate.month,
      birthDate.day,
      hour,
      minute,
    );
  }

  double? _asDouble(dynamic value) {
    if (value is double) {
      return value;
    }
    if (value is int) {
      return value.toDouble();
    }
    if (value is String) {
      return double.tryParse(value);
    }
    return null;
  }

  Future<void> _refreshFriendAstro({
    required String uid,
    required String friendId,
    required DateTime localBirthDateTime,
    required double latitude,
    required double longitude,
    required String requestToken,
  }) async {
    if (_inFlightFriendRequests.contains(requestToken)) {
      return;
    }

    _inFlightFriendRequests.add(requestToken);
    _lastFriendAstroAttemptAt[requestToken] = DateTime.now();

    try {
      final astro = await _astroApiService.calculate(
        localBirthDateTime: localBirthDateTime,
        latitude: latitude,
        longitude: longitude,
      );

      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'compatibilityFriends': {
          friendId: {
            'zodiacSign': astro.sunSign,
            'moonSign': astro.moonSign,
            'risingSign': astro.ascendant,
            'birthTimezone': astro.timezone,
            'updatedAt': FieldValue.serverTimestamp(),
          },
        },
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (_) {
      // Sessiz gec: sonraki retry turunda tekrar denenir.
    } finally {
      _inFlightFriendRequests.remove(requestToken);
    }
  }

  void _scheduleMissingFriendAstroRefresh({
    required String uid,
    required dynamic friendsData,
  }) {
    final friends = <MapEntry<String, Map<String, dynamic>>>[];

    if (friendsData is Map<String, dynamic>) {
      for (final entry in friendsData.entries) {
        final value = entry.value;
        if (value is Map<String, dynamic>) {
          friends.add(MapEntry(entry.key, value));
        }
      }
    } else if (friendsData is List) {
      for (final item in friendsData) {
        if (item is Map<String, dynamic>) {
          final id = (item['id'] as String?)?.trim();
          if (id != null && id.isNotEmpty) {
            friends.add(MapEntry(id, item));
          }
        }
      }
    }

    for (final entry in friends) {
      final friendId = entry.key;
      final friend = entry.value;

      final hasMoon = _isKnownAstroValue(
        (friend['moonSign'] as String?)?.trim(),
      );
      final hasRising = _isKnownAstroValue(
        (friend['risingSign'] as String?)?.trim(),
      );
      if (hasMoon && hasRising) {
        continue;
      }

      final birthDateRaw = friend['birthDate'];
      final birthDate = birthDateRaw is Timestamp
          ? birthDateRaw.toDate()
          : null;
      final birthTime = (friend['birthTime'] as String?)?.trim();
      final localBirthDateTime = _buildLocalBirthDateTime(
        birthDate: birthDate,
        birthTime: birthTime,
      );
      final latitude = _asDouble(friend['birthPlaceLat']);
      final longitude = _asDouble(friend['birthPlaceLon']);

      if (localBirthDateTime == null || latitude == null || longitude == null) {
        continue;
      }

      final requestToken =
          '$friendId|${localBirthDateTime.toIso8601String()}|$latitude|$longitude';
      final attemptedAt = _lastFriendAstroAttemptAt[requestToken];
      final canRetryNow =
          attemptedAt == null ||
          DateTime.now().difference(attemptedAt) >= _friendAstroRetryInterval;

      if (!canRetryNow || _inFlightFriendRequests.contains(requestToken)) {
        continue;
      }

      _lastFriendAstroAttemptAt[requestToken] = DateTime.now();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _refreshFriendAstro(
          uid: uid,
          friendId: friendId,
          localBirthDateTime: localBirthDateTime,
          latitude: latitude,
          longitude: longitude,
          requestToken: requestToken,
        );
      });
    }
  }

  Future<void> _onMyAvatarTap(
    BuildContext context, {
    required String? uid,
    required String currentAvatarId,
  }) async {
    if (uid == null || uid.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kullanici oturumu bulunamadi.')),
      );
      return;
    }

    final selectedAvatarId = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AvatarPickerSheet(initialAvatarId: currentAvatarId),
    );

    if (selectedAvatarId == null || selectedAvatarId == currentAvatarId) {
      return;
    }

    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'avatarId': selectedAvatarId,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> _onAddFriendTap(
    BuildContext context, {
    required String? uid,
  }) async {
    if (uid == null || uid.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kullanici oturumu bulunamadi.')),
      );
      return;
    }

    await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => AddCompatibilityFriendPage(uid: uid)),
    );
  }

  Future<void> _onDeleteFriendTap(
    BuildContext context, {
    required String? uid,
    required String friendId,
    required String friendName,
  }) async {
    if (uid == null || uid.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kullanici oturumu bulunamadi.')),
      );
      return;
    }

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Arkadas silinsin mi?'),
          content: Text('$friendName kalici olarak silinecek.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Vazgec'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Sil'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) {
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'compatibilityFriends': {friendId: FieldValue.delete()},
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Arkadas silinirken hata olustu.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final userStream = uid == null
        ? null
        : FirebaseFirestore.instance.collection('users').doc(uid).snapshots();

    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/onboarding/home_page.png',
            fit: BoxFit.cover,
            alignment: Alignment.center,
            repeat: ImageRepeat.repeatY,
          ),
        ),
        const Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0x220B1026),
                  Color(0x7A0B1026),
                  Color(0xC51B1F3B),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 0.62, 1.0],
              ),
            ),
          ),
        ),
        StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: userStream,
          builder: (context, snapshot) {
            final data = snapshot.data?.data() ?? <String, dynamic>{};
            if (uid != null) {
              _scheduleMissingFriendAstroRefresh(
                uid: uid,
                friendsData: data['compatibilityFriends'],
              );
            }
            final sign = _normalizeSign(
              (data['zodiacSign'] as String?)?.trim(),
            );
            final rawName = (data['name'] as String?)?.trim();
            final fallbackName = FirebaseAuth.instance.currentUser?.displayName
                ?.trim();
            final resolvedName = _capitalizeNameInitial(
              (rawName?.isNotEmpty ?? false)
                  ? rawName!
                  : ((fallbackName?.isNotEmpty ?? false)
                        ? fallbackName!
                        : 'Sen'),
            );
            final hasAnyFriend = _hasCompatibilityFriends(
              data['compatibilityFriends'],
            );
            final rawAvatarId = (data['avatarId'] as String?)?.trim();
            final avatarId = _isValidAvatarId(rawAvatarId)
                ? rawAvatarId!
                : _defaultAvatarIdForSign(sign);

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _CompatibilityUserHeader(),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Text(
                          'Uyum',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 34 / 2,
                              ),
                        ),
                        if (hasAnyFriend) ...[
                          const Spacer(),
                          _CompactAddFriendButton(
                            onTap: () => _onAddFriendTap(context, uid: uid),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Arkadaslarini, partnerini veya istedigin birini ekle.\n'
                      'Iliski uyumunuzu, haftalik iliski yorumlarini, burc\n'
                      'analizlerini ve daha fazlasini kesfet.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white.withValues(alpha: 0.82),
                        height: 1.28,
                        fontWeight: FontWeight.w400,
                        fontSize: 28 / 2,
                      ),
                    ),
                    SizedBox(height: hasAnyFriend ? 10 : 20),
                    Expanded(
                      child: hasAnyFriend
                          ? _CompatibilityFriendList(
                              uid: uid,
                              currentUserName: resolvedName,
                              currentUserData: data,
                              friendsData: data['compatibilityFriends'],
                              onDeleteFriend: (friendId, friendName) {
                                return _onDeleteFriendTap(
                                  context,
                                  uid: uid,
                                  friendId: friendId,
                                  friendName: friendName,
                                );
                              },
                            )
                          : Column(
                              children: [
                                Align(
                                  alignment: const Alignment(0, -0.45),
                                  child: SizedBox(
                                    width: 340,
                                    height: 300,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        const Positioned.fill(
                                          child: IgnorePointer(
                                            child: CustomPaint(
                                              painter:
                                                  _CompatibilityLinkPainter(),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 250,
                                          height: 250,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.transparent,
                                            border: Border.all(
                                              color: const Color(0xA0F5E6C7),
                                              width: 2,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          left: 16,
                                          child: _CircleProfileNode(
                                            title: 'Sen',
                                            child: GestureDetector(
                                              onTap: () => _onMyAvatarTap(
                                                context,
                                                uid: uid,
                                                currentAvatarId: avatarId,
                                              ),
                                              child: _ProfileAvatarBadge(
                                                avatarId: avatarId,
                                                size: 98,
                                                borderColor: const Color(
                                                  0xB1A8B7D9,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          right: 10,
                                          top: 58,
                                          child: _CircleProfileNode(
                                            title: 'Arkadas Ekle',
                                            child: _AddFriendNode(
                                              onTap: () => _onAddFriendTap(
                                                context,
                                                uid: uid,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Expanded(
                                  child: _CompatibilityFriendList(
                                    uid: uid,
                                    currentUserName: resolvedName,
                                    currentUserData: data,
                                    friendsData: data['compatibilityFriends'],
                                    onDeleteFriend: (friendId, friendName) {
                                      return _onDeleteFriendTap(
                                        context,
                                        uid: uid,
                                        friendId: friendId,
                                        friendName: friendName,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _CircleProfileNode extends StatelessWidget {
  const _CircleProfileNode({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: const Color(0xE5FFFFFF),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

class _AddFriendNode extends StatelessWidget {
  const _AddFriendNode({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(60),
          child: Container(
            width: 98,
            height: 98,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0x8FB3AFCA),
              border: Border.all(color: const Color(0x99D4C8F2), width: 3),
            ),
            child: const Icon(Icons.add, color: Color(0xEE5A5874), size: 44),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: 106,
          height: 34,
          child: ElevatedButton.icon(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0x70979AB3),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              textStyle: const TextStyle(fontWeight: FontWeight.w600),
            ),
            icon: const Icon(Icons.add, size: 16),
            label: const Text('Ekle'),
          ),
        ),
      ],
    );
  }
}

class _CompactAddFriendButton extends StatelessWidget {
  const _CompactAddFriendButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.12),
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFF2C98A)),
        ),
        child: const Icon(Icons.add, size: 18, color: Color(0xFFF2C98A)),
      ),
    );
  }
}

class _CompatibilityLinkPainter extends CustomPainter {
  const _CompatibilityLinkPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final secondaryPaint = Paint()
      ..color = const Color(0x7AE9DFC8)
      ..strokeWidth = 1.15
      ..style = PaintingStyle.stroke;

    final left = Offset(size.width * 0.24, size.height * 0.54);
    final right = Offset(size.width * 0.76, size.height * 0.54);

    final topArc = Path()
      ..moveTo(left.dx, left.dy - 3)
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height * 0.40,
        right.dx,
        right.dy - 3,
      );
    canvas.drawPath(topArc, secondaryPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CompatibilityBondPainter extends CustomPainter {
  const _CompatibilityBondPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final area = Offset.zero & size;
    final bondPath = Path()
      ..moveTo(1, size.height * 0.5)
      ..quadraticBezierTo(
        size.width * 0.20,
        size.height * 0.26,
        size.width * 0.38,
        size.height * 0.50,
      )
      ..quadraticBezierTo(
        size.width * 0.56,
        size.height * 0.74,
        size.width * 0.74,
        size.height * 0.50,
      )
      ..quadraticBezierTo(
        size.width * 0.88,
        size.height * 0.32,
        size.width - 1,
        size.height * 0.50,
      );
    final echoPath = Path()
      ..moveTo(4, size.height * 0.58)
      ..quadraticBezierTo(
        size.width * 0.24,
        size.height * 0.42,
        size.width * 0.46,
        size.height * 0.58,
      )
      ..quadraticBezierTo(
        size.width * 0.70,
        size.height * 0.74,
        size.width - 4,
        size.height * 0.58,
      );

    final glowPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0x45F5DEB6), Color(0xD9FFE6B6), Color(0x45F5DEB6)],
      ).createShader(area)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 9
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);

    final linePaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xB2F6D9A1), Color(0xFFFFF1D2), Color(0xB2F6D9A1)],
      ).createShader(area)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.8;

    final echoPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0x00F8E7C0), Color(0x99F8E7C0), Color(0x00F8E7C0)],
      ).createShader(area)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1.6;

    final pulseCorePaint = Paint()..color = const Color(0xFFFFF3D8);
    final pulseHaloPaint = Paint()
      ..color = const Color(0x90FFE7BE)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    canvas.drawPath(bondPath, glowPaint);
    canvas.drawPath(bondPath, linePaint);
    canvas.drawPath(echoPath, echoPaint);

    final center = Offset(size.width * 0.5, size.height * 0.5);
    canvas.drawCircle(center, 8, pulseHaloPaint);
    canvas.drawCircle(center, 3.2, pulseCorePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CompatibilityFriendList extends StatelessWidget {
  const _CompatibilityFriendList({
    required this.uid,
    required this.currentUserName,
    required this.currentUserData,
    required this.friendsData,
    required this.onDeleteFriend,
  });

  final String? uid;
  final String currentUserName;
  final Map<String, dynamic> currentUserData;
  final dynamic friendsData;
  final Future<void> Function(String friendId, String friendName)
  onDeleteFriend;

  @override
  Widget build(BuildContext context) {
    final friendEntries = <Map<String, dynamic>>[];

    if (friendsData is Map<String, dynamic>) {
      for (final entry in friendsData.entries) {
        final value = entry.value;
        if (value is Map<String, dynamic>) {
          friendEntries.add({'id': entry.key, ...value});
        }
      }
    } else if (friendsData is List) {
      for (final item in friendsData) {
        if (item is Map<String, dynamic>) {
          friendEntries.add(item);
        }
      }
    }

    friendEntries.sort((a, b) {
      final aUpdated = a['updatedAt'];
      final bUpdated = b['updatedAt'];
      if (aUpdated is Timestamp && bUpdated is Timestamp) {
        return bUpdated.compareTo(aUpdated);
      }
      return 0;
    });

    if (friendEntries.isEmpty) {
      return Center(
        child: Text(
          'Henuz eklenmis bir arkadas yok.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.white60,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }

    final currentSun = _displaySign(
      _normalizeSign((currentUserData['zodiacSign'] as String?) ?? ''),
    );
    final currentMoon = _displaySign(
      (currentUserData['moonSign'] as String?) ?? 'Bilinmiyor',
    );
    final currentRising = _displaySign(
      (currentUserData['risingSign'] as String?) ?? 'Bilinmiyor',
    );
    final rawCurrentAvatarId = (currentUserData['avatarId'] as String?)?.trim();
    final currentAvatarId = _isValidAvatarId(rawCurrentAvatarId)
        ? rawCurrentAvatarId!
        : _defaultAvatarIdForSign(currentSun);

    return ListView.separated(
      itemCount: friendEntries.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final map = friendEntries[index];
        final friendIdRaw = (map['id'] as String?)?.trim();
        final friendId = (friendIdRaw?.isNotEmpty ?? false)
            ? friendIdRaw!
            : null;
        final nameRaw = (map['name'] as String?)?.trim();
        final name = _capitalizeNameInitial(
          (nameRaw?.isNotEmpty ?? false) ? nameRaw! : 'Arkadas',
        );
        final friendSun = _displaySign(
          (map['zodiacSign'] as String?) ?? 'Bilinmiyor',
        );
        final friendMoon = _displaySign(
          (map['moonSign'] as String?) ?? 'Bilinmiyor',
        );
        final friendRising = _displaySign(
          (map['risingSign'] as String?) ?? 'Bilinmiyor',
        );

        final friendSignKey = _normalizeSign(
          (map['zodiacSign'] as String?) ?? '',
        );
        final friendAvatarId = _defaultAvatarIdForSign(friendSignKey);

        return InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => CompatibilityFriendDetailPage(
                  currentUserName: currentUserName,
                  currentUserAvatarId: currentAvatarId,
                  friendAvatarId: friendAvatarId,
                  currentUserSigns: {
                    'sun': currentSun,
                    'moon': currentMoon,
                    'rising': currentRising,
                  },
                  friendData: map,
                ),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Spacer(),
                    IconButton(
                      onPressed: (uid == null || friendId == null)
                          ? null
                          : () => onDeleteFriend(friendId, name),
                      visualDensity: VisualDensity.compact,
                      splashRadius: 18,
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.white70,
                        size: 20,
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: Colors.white70),
                  ],
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 104,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 64,
                                  child: Text(
                                    currentUserName,
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                _ProfileAvatarBadge(
                                  avatarId: _defaultAvatarIdForSign(currentSun),
                                  size: 64,
                                  borderColor: const Color(0xD2F2D9A3),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Column(
                            children: [
                              SizedBox(height: 27),
                              SizedBox(
                                width: 38,
                                height: 68,
                                child: CustomPaint(
                                  painter: _CompatibilityBondPainter(),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 4),
                          SizedBox(
                            width: 104,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 72,
                                  child: Text(
                                    name,
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                _ProfileAvatarBadge(
                                  avatarId: friendAvatarId,
                                  size: 64,
                                  borderColor: const Color(0xD2F2D9A3),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 128,
                            child: Text(
                              '☉$currentSun☾$currentMoon↑$currentRising',
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 11,
                                  ),
                            ),
                          ),
                          const SizedBox(width: 18),
                          SizedBox(
                            width: 128,
                            child: Text(
                              '☉$friendSun☾$friendMoon↑$friendRising',
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 11,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CompatibilityUserHeader extends StatefulWidget {
  const _CompatibilityUserHeader();

  @override
  State<_CompatibilityUserHeader> createState() =>
      _CompatibilityUserHeaderState();
}

class _CompatibilityUserHeaderState extends State<_CompatibilityUserHeader> {
  final _astroApiService = const AstroApiService();
  static const _astroRetryInterval = Duration(seconds: 20);
  bool _isRefreshingAstro = false;
  String? _lastAstroRequestKey;
  DateTime? _lastAstroAttemptAt;
  Timer? _astroRetryTicker;

  @override
  void initState() {
    super.initState();
    _astroRetryTicker = Timer.periodic(_astroRetryInterval, (_) {
      if (!mounted || _isRefreshingAstro) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _astroRetryTicker?.cancel();
    super.dispose();
  }

  bool _isKnownAstroValue(String? value) {
    final normalized = value?.trim();
    if (normalized == null || normalized.isEmpty) {
      return false;
    }
    return normalized != 'Bilinmiyor' && normalized != 'Yukleniyor...';
  }

  DateTime? _buildLocalBirthDateTime({
    required DateTime? birthDate,
    required String? birthTime,
  }) {
    if (birthDate == null || birthTime == null || birthTime.trim().isEmpty) {
      return null;
    }

    final parts = birthTime.trim().split(':');
    if (parts.length != 2) {
      return null;
    }

    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) {
      return null;
    }
    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
      return null;
    }

    return DateTime(
      birthDate.year,
      birthDate.month,
      birthDate.day,
      hour,
      minute,
    );
  }

  double? _asDouble(dynamic value) {
    if (value is double) {
      return value;
    }
    if (value is int) {
      return value.toDouble();
    }
    if (value is String) {
      return double.tryParse(value);
    }
    return null;
  }

  Future<void> _refreshAstro({
    required String uid,
    required String requestKey,
    required DateTime localBirthDateTime,
    required double latitude,
    required double longitude,
  }) async {
    if (_isRefreshingAstro) {
      return;
    }

    setState(() {
      _isRefreshingAstro = true;
      _lastAstroRequestKey = requestKey;
      _lastAstroAttemptAt = DateTime.now();
    });

    try {
      final astro = await _astroApiService.calculate(
        localBirthDateTime: localBirthDateTime,
        latitude: latitude,
        longitude: longitude,
      );

      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'zodiacSign': astro.sunSign,
        'moonSign': astro.moonSign,
        'risingSign': astro.ascendant,
        'birthTimezone': astro.timezone,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (_) {
      // Sessiz gec.
    } finally {
      if (mounted) {
        setState(() => _isRefreshingAstro = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final stream = uid == null
        ? null
        : FirebaseFirestore.instance.collection('users').doc(uid).snapshots();

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: stream,
      builder: (context, snapshot) {
        final data = snapshot.data?.data() ?? <String, dynamic>{};

        final name = (data['name'] as String?)?.trim();
        final fallbackName = FirebaseAuth.instance.currentUser?.displayName
            ?.trim();
        final resolvedName = _capitalizeNameInitial(
          (name?.isNotEmpty ?? false)
              ? name!
              : ((fallbackName?.isNotEmpty ?? false)
                    ? fallbackName!
                    : 'Kullanici'),
        );

        final timestamp = data['birthDate'];
        final birthDate = timestamp is Timestamp ? timestamp.toDate() : null;
        final sunSignRaw = (data['zodiacSign'] as String?)?.trim();
        final sunSign = (sunSignRaw?.isNotEmpty ?? false)
            ? sunSignRaw!
            : (birthDate != null ? calculateZodiac(birthDate) : 'Bilinmiyor');

        final moonSignRaw = (data['moonSign'] as String?)?.trim();
        final hasMoonSign = _isKnownAstroValue(moonSignRaw);
        final moonSign = hasMoonSign ? moonSignRaw! : 'Bilinmiyor';

        final risingSignRaw = (data['risingSign'] as String?)?.trim();
        final hasRisingSign = _isKnownAstroValue(risingSignRaw);
        final risingSign = hasRisingSign ? risingSignRaw! : 'Bilinmiyor';

        final birthTime = (data['birthTime'] as String?)?.trim();
        final lat = _asDouble(data['birthPlaceLat']);
        final lon = _asDouble(data['birthPlaceLon']);
        final localBirthDateTime = _buildLocalBirthDateTime(
          birthDate: birthDate,
          birthTime: birthTime,
        );

        final canRefreshAstro =
            uid != null &&
            localBirthDateTime != null &&
            lat != null &&
            lon != null;
        final needsAstroRefresh =
            canRefreshAstro && (!hasMoonSign || !hasRisingSign);
        final requestKey = canRefreshAstro
            ? '${localBirthDateTime.toIso8601String()}|$lat|$lon'
            : null;
        final canRetryNow =
            _lastAstroAttemptAt == null ||
            DateTime.now().difference(_lastAstroAttemptAt!) >=
                _astroRetryInterval;

        if (needsAstroRefresh &&
            !_isRefreshingAstro &&
            requestKey != null &&
            (requestKey != _lastAstroRequestKey || canRetryNow)) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _refreshAstro(
              uid: uid,
              requestKey: requestKey,
              localBirthDateTime: localBirthDateTime,
              latitude: lat,
              longitude: lon,
            );
          });
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Merhaba, $resolvedName',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 10,
              runSpacing: 4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _SignChip(icon: '☉', text: _displaySign(sunSign)),
                _SignChip(
                  icon: '☾',
                  text: _displaySign(
                    hasMoonSign
                        ? moonSign
                        : (needsAstroRefresh || _isRefreshingAstro
                              ? 'Yukleniyor...'
                              : moonSign),
                  ),
                ),
                _SignChip(
                  icon: '↑',
                  text: _displaySign(
                    hasRisingSign
                        ? risingSign
                        : (needsAstroRefresh || _isRefreshingAstro
                              ? 'Yukleniyor...'
                              : risingSign),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _SignChip extends StatelessWidget {
  const _SignChip({required this.icon, required this.text});

  final String icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      '$icon $text',
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: Colors.white70,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

String _capitalizeNameInitial(String value) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) {
    return trimmed;
  }
  const trUpperMap = {
    'i': 'İ',
    'ı': 'I',
    'ş': 'Ş',
    'ğ': 'Ğ',
    'ü': 'Ü',
    'ö': 'Ö',
    'ç': 'Ç',
  };
  final first = trimmed[0];
  final upperFirst = trUpperMap[first] ?? first.toUpperCase();
  return '$upperFirst${trimmed.substring(1)}';
}

String _displaySign(String value) {
  switch (value) {
    case 'Koc':
      return 'Koç';
    case 'Boga':
      return 'Boğa';
    case 'Ikizler':
      return 'İkizler';
    case 'Yengec':
      return 'Yengeç';
    case 'Basak':
      return 'Başak';
    case 'Oglak':
      return 'Oğlak';
    case 'Bilinmiyor':
      return 'Bilinmiyor';
    default:
      return value;
  }
}

class _AvatarPickerSheet extends StatefulWidget {
  const _AvatarPickerSheet({required this.initialAvatarId});

  final String initialAvatarId;

  @override
  State<_AvatarPickerSheet> createState() => _AvatarPickerSheetState();
}

class _AvatarPickerSheetState extends State<_AvatarPickerSheet> {
  late String _selectedAvatarId;

  @override
  void initState() {
    super.initState();
    _selectedAvatarId =
        _avatarOptions.any((option) => option.id == widget.initialAvatarId)
        ? widget.initialAvatarId
        : _avatarOptions.first.id;
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(8, 8, 8, 8 + bottomInset),
        child: Container(
          constraints: const BoxConstraints(maxHeight: 760),
          decoration: BoxDecoration(
            color: const Color(0xFFE8E8EC),
            borderRadius: BorderRadius.circular(26),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              children: [
                Row(
                  children: [
                    const Spacer(),
                    TextButton(
                      onPressed: () =>
                          Navigator.of(context).pop(_selectedAvatarId),
                      child: Text(
                        'Tamam',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: const Color(0xFF161616),
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                SizedBox(
                  height: 124,
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      _ProfileAvatarBadge(
                        avatarId: _selectedAvatarId,
                        size: 92,
                      ),
                      Positioned(
                        top: 10,
                        right: 8,
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.withValues(alpha: 0.75),
                          ),
                          child: IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(
                              Icons.close,
                              color: Colors.white70,
                            ),
                            padding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDFDFE2),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Profil Gorselini Sec',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                color: const Color(0xFF232323),
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: GridView.builder(
                            itemCount: _avatarOptions.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  mainAxisSpacing: 12,
                                  crossAxisSpacing: 12,
                                  childAspectRatio: 1,
                                ),
                            itemBuilder: (context, index) {
                              final option = _avatarOptions[index];
                              final selected = option.id == _selectedAvatarId;
                              return GestureDetector(
                                onTap: () {
                                  setState(() => _selectedAvatarId = option.id);
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 180),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: selected
                                          ? const Color(0xFFE2C27D)
                                          : Colors.transparent,
                                      width: 3,
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(2),
                                  child: _ProfileAvatarBadge(
                                    avatarId: option.id,
                                    size: 88,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileAvatarBadge extends StatelessWidget {
  const _ProfileAvatarBadge({
    required this.avatarId,
    required this.size,
    this.borderColor = const Color(0xFFE9C77E),
  });

  final String avatarId;
  final double size;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    final option = _avatarOptions.firstWhere(
      (item) => item.id == avatarId,
      orElse: () => _avatarOptions.first,
    );

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 3),
        color: const Color(0xFF08193F),
      ),
      child: ClipOval(
        child: Image.asset(
          option.assetPath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: const Color(0xFF0E2152),
              alignment: Alignment.center,
              child: Icon(
                Icons.person,
                color: Colors.white70,
                size: size * 0.5,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _AvatarOption {
  const _AvatarOption(this.id, this.assetPath);

  final String id;
  final String assetPath;
}

String _normalizeSign(String? sign) {
  final value = (sign ?? '').trim();
  if (value.isEmpty || value == 'Bilinmiyor') {
    return 'Yukleniyor...';
  }
  switch (value) {
    case 'Koc':
      return 'Koç';
    case 'Boga':
      return 'Boğa';
    case 'Ikizler':
      return 'İkizler';
    case 'Yengec':
      return 'Yengeç';
    case 'Basak':
      return 'Başak';
    case 'Oglak':
      return 'Oğlak';
    default:
      return value;
  }
}

bool _isValidAvatarId(String? id) {
  if (id == null || id.isEmpty) {
    return false;
  }
  return _avatarOptions.any((option) => option.id == id);
}

String _defaultAvatarIdForSign(String sign) {
  const signToAvatar = <String, String>{
    'Koç': 'koc',
    'Boğa': 'boga',
    'İkizler': 'ikizler',
    'Yengeç': 'yengec',
    'Aslan': 'aslan',
    'Başak': 'basak',
    'Terazi': 'terazi',
    'Akrep': 'akrep',
    'Yay': 'yay',
    'Oğlak': 'oglak',
    'Kova': 'kova',
    'Balık': 'balik',
  };
  return signToAvatar[sign] ?? 'terazi';
}

const List<_AvatarOption> _avatarOptions = <_AvatarOption>[
  _AvatarOption('kova', 'assets/burclar/kova.png'),
  _AvatarOption('balik', 'assets/burclar/balık.png'),
  _AvatarOption('terazi', 'assets/burclar/terazi.png'),
  _AvatarOption('aslan', 'assets/burclar/aslan.png'),
  _AvatarOption('ikizler', 'assets/burclar/ikizler.png'),
  _AvatarOption('oglak', 'assets/burclar/oglak.png'),
  _AvatarOption('yengec', 'assets/burclar/yengec.png'),
  _AvatarOption('koc', 'assets/burclar/koc.png'),
  _AvatarOption('yay', 'assets/burclar/yay.png'),
  _AvatarOption('akrep', 'assets/burclar/akrep.png'),
  _AvatarOption('boga', 'assets/burclar/boga.png'),
  _AvatarOption('basak', 'assets/burclar/basak.png'),
];
