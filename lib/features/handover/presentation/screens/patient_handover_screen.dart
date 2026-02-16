import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/handover_provider.dart';

class PatientHandoverScreen extends ConsumerStatefulWidget {
  final String missionId;

  const PatientHandoverScreen({super.key, required this.missionId});

  @override
  ConsumerState<PatientHandoverScreen> createState() =>
      _PatientHandoverScreenState();
}

class _PatientHandoverScreenState extends ConsumerState<PatientHandoverScreen> {
  final _formKey = GlobalKey<FormState>();
  final _remarksController = TextEditingController();
  bool _clinicConfirmed = false;

  @override
  void dispose() {
    _remarksController.dispose();
    super.dispose();
  }

  Future<void> _submitHandover() async {
    if (!_clinicConfirmed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please confirm clinic arrival'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final success = await ref
        .read(handoverProvider.notifier)
        .submitHandover(widget.missionId, _remarksController.text.trim());

    if (!mounted) return;

    if (success) {
      context.go('/mission-completed/${widget.missionId}');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to submit handover'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final handoverState = ref.watch(handoverProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Patient Handover')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Icon(
                        Icons.handshake,
                        size: 64,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Patient Handover',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Complete the handover process to transfer patient care to the clinic',
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Handover Checklist',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      CheckboxListTile(
                        value: _clinicConfirmed,
                        onChanged: (value) {
                          setState(() {
                            _clinicConfirmed = value ?? false;
                          });
                        },
                        title: const Text('Arrived at clinic'),
                        subtitle: const Text(
                          'Confirm that you have arrived at the destination clinic',
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Handover Remarks (Optional)',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _remarksController,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          hintText:
                              'Add any additional remarks or observations for the clinic staff...',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Card(
                color: Theme.of(context).colorScheme.secondaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Once submitted, the mission will be marked as completed and locked. No further changes can be made.',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: handoverState.isLoading ? null : _submitHandover,
                icon: handoverState.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.check_circle),
                label: const Text('Submit Handover'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
