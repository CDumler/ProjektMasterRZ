import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    required this.email,
    required this.onStartAssessment,
    required this.onOpenExistingAssessment,
    required this.onLogout,
  });

  final String email;
  final VoidCallback onStartAssessment;
  final VoidCallback onOpenExistingAssessment;
  final VoidCallback onLogout;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _profileImagePath;
  final ImagePicker _imagePicker = ImagePicker();

  Future<void> _addProfileImage() async {
    final source = await showModalBottomSheet<_ImageSourceChoice>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Aus Fotos auswählen'),
                onTap: () => Navigator.pop(context, _ImageSourceChoice.photos),
              ),
              ListTile(
                leading: const Icon(Icons.folder_open),
                title: const Text('Aus Dateien auswählen'),
                onTap: () => Navigator.pop(context, _ImageSourceChoice.files),
              ),
              ListTile(
                leading: const Icon(Icons.close),
                title: const Text('Abbrechen'),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );

    if (source == null) {
      return;
    }

    switch (source) {
      case _ImageSourceChoice.photos:
        await _pickFromPhotos();
      case _ImageSourceChoice.files:
        await _pickFromFiles();
    }
  }

  Future<void> _pickFromPhotos() async {
    try {
      final picked = await _imagePicker.pickImage(source: ImageSource.gallery);
      if (picked == null) {
        return;
      }
      setState(() => _profileImagePath = picked.path);
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Fotos konnten nicht geöffnet werden. Bitte Berechtigung in iOS-Einstellungen prüfen.',
          ),
        ),
      );
    }
  }

  Future<void> _pickFromFiles() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      allowedExtensions: const ['png', 'jpg', 'jpeg'],
    );

    final path = (result == null || result.files.isEmpty) ? null : result.files.first.path;
    if (path == null) {
      return;
    }

    setState(() => _profileImagePath = path);
  }

  @override
  Widget build(BuildContext context) {
    final imageProvider = _profileImagePath == null ? null : FileImage(File(_profileImagePath!));

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
                    CircleAvatar(
                      radius: 52,
                      backgroundColor: const Color(0xFFCCFBF1),
                      foregroundImage: imageProvider,
                      child: imageProvider == null
                          ? const Icon(Icons.person, size: 56, color: Color(0xFF0F766E))
                          : null,
                    ),
                    const SizedBox(height: 12),
                    TextButton.icon(
                      onPressed: _addProfileImage,
                      icon: const Icon(Icons.add_a_photo_outlined),
                      label: const Text('Profilbild hinzufügen'),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Angemeldetes Konto',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.email,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    FilledButton.icon(
                      onPressed: widget.onStartAssessment,
                      icon: const Icon(Icons.play_circle_outline),
                      label: const Text('Prüfung starten'),
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton.icon(
                      onPressed: widget.onOpenExistingAssessment,
                      icon: const Icon(Icons.folder_open),
                      label: const Text('Zu bestehender Prüfung'),
                    ),
                    const SizedBox(height: 10),
                    TextButton.icon(
                      onPressed: widget.onLogout,
                      icon: const Icon(Icons.logout),
                      label: const Text('Abmelden'),
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

enum _ImageSourceChoice { photos, files }
