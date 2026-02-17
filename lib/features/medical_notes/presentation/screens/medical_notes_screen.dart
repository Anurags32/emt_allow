import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import '../providers/medical_notes_provider.dart';
import '../../domain/providers/mission_lock_provider.dart';

class MedicalNotesScreen extends ConsumerStatefulWidget {
  final String missionId;

  const MedicalNotesScreen({super.key, required this.missionId});

  @override
  ConsumerState<MedicalNotesScreen> createState() => _MedicalNotesScreenState();
}

class _MedicalNotesScreenState extends ConsumerState<MedicalNotesScreen> {
  final _noteController = TextEditingController();
  final List<String> _attachments = [];

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _attachments.add(image.path);
      });
    }
  }

  Future<void> _pickDocument() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      setState(() {
        _attachments.add(result.files.single.path!);
      });
    }
  }

  Future<void> _saveNote() async {
    if (_noteController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter a note')));
      return;
    }

    // Show dialog to get case_id
    final caseId = await showDialog<String>(
      context: context,
      builder: (context) {
        final caseIdController = TextEditingController(text: 'CASE/26/00024');
        return AlertDialog(
          title: const Text('Enter Case ID'),
          content: TextField(
            controller: caseIdController,
            decoration: const InputDecoration(
              labelText: 'Case ID',
              hintText: 'e.g., CASE/26/00024',
              border: OutlineInputBorder(),
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final value = caseIdController.text.trim();
                if (value.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Case ID cannot be empty')),
                  );
                  return;
                }
                Navigator.pop(context, value);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    // If user cancelled, return
    if (caseId == null || caseId.isEmpty) return;

    if (kDebugMode) {
      debugPrint(
        '[MEDICAL NOTES SCREEN] Saving note with ${_attachments.length} attachments',
      );
      debugPrint('[MEDICAL NOTES SCREEN] Case ID: $caseId');
      for (var i = 0; i < _attachments.length; i++) {
        debugPrint('[MEDICAL NOTES SCREEN] Attachment $i: ${_attachments[i]}');
      }
    }

    final success = await ref
        .read(medicalNotesProvider(widget.missionId).notifier)
        .addNote(_noteController.text.trim(), _attachments, caseId);

    if (!mounted) return;

    if (success) {
      _noteController.clear();
      setState(() {
        _attachments.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Note saved successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to save note'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final notesState = ref.watch(medicalNotesProvider(widget.missionId));
    final isLocked = ref.watch(missionLockProvider(widget.missionId));

    return Scaffold(
      appBar: AppBar(title: const Text('Medical Notes')),
      body: Column(
        children: [
          // Notes List
          Expanded(
            child: notesState.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text('Error: $error'),
                  ],
                ),
              ),
              data: (notes) {
                if (notes.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.note_add, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          'No medical notes yet',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Add your first note below',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    final note = notes[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 16,
                                  child: Text(
                                    note.authorName[0].toUpperCase(),
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        note.authorName,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      Text(
                                        '${note.authorRole} • ${DateFormat('MMM dd, HH:mm').format(note.createdAt)}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              note.content,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            if (note.attachments.isNotEmpty) ...[
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: note.attachments.map((attachment) {
                                  return Chip(
                                    avatar: Icon(
                                      attachment.type.toString().contains(
                                            'image',
                                          )
                                          ? Icons.image
                                          : Icons.description,
                                      size: 16,
                                    ),
                                    label: Text(attachment.fileName),
                                  );
                                }).toList(),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // Add Note Section
          if (isLocked.when(
            data: (locked) => locked,
            loading: () => false,
            error: (_, __) => false,
          ))
            Container(
              padding: const EdgeInsets.all(16),
              color: Theme.of(context).colorScheme.errorContainer,
              child: Row(
                children: [
                  Icon(Icons.lock, color: Theme.of(context).colorScheme.error),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Mission is locked. No more notes can be added.',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_attachments.isNotEmpty) ...[
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _attachments.map((path) {
                        return Chip(
                          label: Text(path.split('/').last),
                          onDeleted: () {
                            setState(() {
                              _attachments.remove(path);
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 12),
                  ],
                  TextField(
                    controller: _noteController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: 'Add medical note...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      IconButton(
                        onPressed: _pickImage,
                        icon: const Icon(Icons.camera_alt),
                        tooltip: 'Add Photo',
                      ),
                      IconButton(
                        onPressed: _pickDocument,
                        icon: const Icon(Icons.attach_file),
                        tooltip: 'Add Document',
                      ),
                      const Spacer(),
                      ElevatedButton.icon(
                        onPressed: notesState.isLoading ? null : _saveNote,
                        icon: const Icon(Icons.save),
                        label: const Text('Save Note'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
