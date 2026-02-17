import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool appLock = false;
  bool hashChain = true;
  bool encryptionEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Einstellungen & Sicherheit')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('App-Sperre (PIN/Biometrie optional v2)'),
            value: appLock,
            onChanged: (v) => setState(() => appLock = v),
          ),
          SwitchListTile(
            title: const Text('Audit-Hashkette aktiv'),
            value: hashChain,
            onChanged: (v) => setState(() => hashChain = v),
          ),
          SwitchListTile(
            title: const Text('Verschlüsselung at-rest aktiv'),
            subtitle: const Text('SQLCipher via sqflite_sqlcipher'),
            value: encryptionEnabled,
            onChanged: (v) => setState(() => encryptionEnabled = v),
          ),
          const ListTile(
            title: Text('Lokales Profil'),
            subtitle: Text('local_user (offline)'),
          ),
        ],
      ),
    );
  }
}
