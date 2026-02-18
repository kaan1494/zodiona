class AdminCredential {
  const AdminCredential({required this.id, required this.email});

  final String id;
  final String email;
}

const List<AdminCredential> adminCredentials = [
  AdminCredential(
    id: String.fromEnvironment(
      'ADMIN_ID_1',
      defaultValue: '',
    ),
    email: String.fromEnvironment(
      'ADMIN_EMAIL_1',
      defaultValue: '',
    ),
  ),
];

AdminCredential? findAdminById(String id) {
  final normalizedId = id.trim();
  for (final c in adminCredentials) {
    if (c.id.trim().isNotEmpty && c.email.trim().isNotEmpty && c.id == normalizedId) {
      return c;
    }
  }
  return null;
}

bool isKnownAdminId(String id) {
  return adminCredentials.any(
    (c) => c.id == id.trim(),
  );
}
