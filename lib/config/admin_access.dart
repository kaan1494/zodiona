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

AdminCredential? findAdminByEmail(String email) {
  final normalizedEmail = email.trim().toLowerCase();
  for (final c in adminCredentials) {
    if (c.id.trim().isNotEmpty &&
        c.email.trim().isNotEmpty &&
        c.email.toLowerCase() == normalizedEmail) {
      return c;
    }
  }
  return null;
}

AdminCredential? findAdminByIdOrEmail(String value) {
  return findAdminById(value) ?? findAdminByEmail(value);
}

bool isKnownAdminId(String id) {
  return adminCredentials.any(
    (c) => c.id == id.trim(),
  );
}
