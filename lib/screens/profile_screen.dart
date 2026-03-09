import 'package:flutter/material.dart';

class ProfileFormData {
  const ProfileFormData({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.address,
    required this.company,
  });

  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String address;
  final String company;
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.address,
    required this.company,
    required this.onSaveProfile,
    required this.onStartAssessment,
    required this.onOpenExistingAssessment,
    required this.onLogout,
  });

  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String address;
  final String company;
  final Future<String?> Function(ProfileFormData data) onSaveProfile;
  final VoidCallback onStartAssessment;
  final VoidCallback onOpenExistingAssessment;
  final VoidCallback onLogout;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ProfileFormData _profile;

  @override
  void initState() {
    super.initState();
    _profile = ProfileFormData(
      firstName: widget.firstName,
      lastName: widget.lastName,
      email: widget.email,
      password: widget.password,
      address: widget.address,
      company: widget.company,
    );
  }

  String get _displayName {
    final fullName = '${_profile.firstName} ${_profile.lastName}'.trim();
    return fullName.isEmpty ? 'Nicht hinterlegt' : fullName;
  }

  Future<void> _openEditDialog() async {
    final firstNameController = TextEditingController(text: _profile.firstName);
    final lastNameController = TextEditingController(text: _profile.lastName);
    final emailController = TextEditingController(text: _profile.email);
    final passwordController = TextEditingController(text: _profile.password);
    final addressController = TextEditingController(text: _profile.address);
    final companyController = TextEditingController(text: _profile.company);
    final formKey = GlobalKey<FormState>();

    final edited = await showDialog<ProfileFormData>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Profil bearbeiten'),
          content: SizedBox(
            width: 520,
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: firstNameController,
                      decoration: const InputDecoration(labelText: 'Vorname'),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: lastNameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration:
                          const InputDecoration(labelText: 'E-Mail-Adresse'),
                      validator: (value) {
                        final email = (value ?? '').trim();
                        if (email.isEmpty) {
                          return 'Bitte E-Mail-Adresse eingeben.';
                        }
                        if (!email.contains('@') || !email.contains('.')) {
                          return 'Bitte gültige E-Mail-Adresse eingeben.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Passwort'),
                      validator: (value) {
                        final password = value ?? '';
                        if (password.length < 8) {
                          return 'Passwort muss mindestens 8 Zeichen haben.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: addressController,
                      decoration: const InputDecoration(labelText: 'Adresse'),
                      minLines: 1,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: companyController,
                      decoration: const InputDecoration(labelText: 'Firma'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Abbrechen'),
            ),
            FilledButton(
              onPressed: () {
                if (!formKey.currentState!.validate()) {
                  return;
                }
                Navigator.pop(
                  dialogContext,
                  ProfileFormData(
                    firstName: firstNameController.text.trim(),
                    lastName: lastNameController.text.trim(),
                    email: emailController.text.trim().toLowerCase(),
                    password: passwordController.text,
                    address: addressController.text.trim(),
                    company: companyController.text.trim(),
                  ),
                );
              },
              child: const Text('Speichern'),
            ),
          ],
        );
      },
    );

    if (edited == null) {
      return;
    }

    final error = await widget.onSaveProfile(edited);
    if (!mounted) {
      return;
    }

    if (error != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error)));
      return;
    }

    setState(() => _profile = edited);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profil aktualisiert.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil des Prüfers')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Benutzerprofil',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 12),
                    _ProfileInfoRow(
                        label: 'Vorname', value: _profile.firstName),
                    _ProfileInfoRow(label: 'Name', value: _profile.lastName),
                    _ProfileInfoRow(label: 'Anzeigename', value: _displayName),
                    _ProfileInfoRow(label: 'E-Mail', value: _profile.email),
                    _ProfileInfoRow(label: 'Adresse', value: _profile.address),
                    _ProfileInfoRow(label: 'Firma', value: _profile.company),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: _openEditDialog,
                      child: const Text('Profil bearbeiten'),
                    ),
                    const SizedBox(height: 20),
                    FilledButton(
                      onPressed: widget.onStartAssessment,
                      child: const Text('Prüfung starten'),
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton(
                      onPressed: widget.onOpenExistingAssessment,
                      child: const Text('Zu bestehender Prüfung'),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: widget.onLogout,
                      child: const Text('Abmelden'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileInfoRow extends StatelessWidget {
  const _ProfileInfoRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final displayValue = value.trim().isEmpty ? 'Nicht hinterlegt' : value;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(displayValue)),
        ],
      ),
    );
  }
}
