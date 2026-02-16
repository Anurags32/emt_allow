import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/assessment_provider.dart';

class EMTAssessmentScreen extends ConsumerStatefulWidget {
  final String missionId;

  const EMTAssessmentScreen({super.key, required this.missionId});

  @override
  ConsumerState<EMTAssessmentScreen> createState() =>
      _EMTAssessmentScreenState();
}

class _EMTAssessmentScreenState extends ConsumerState<EMTAssessmentScreen> {
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, String> _answers = {};

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final assessmentState = ref.watch(assessmentProvider(widget.missionId));

    return Scaffold(
      appBar: AppBar(title: const Text('EMT Assessment')),
      body: assessmentState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $error'),
            ],
          ),
        ),
        data: (data) {
          final questions = data['questions'] as List;
          final callCenterAssessment = data['callCenterAssessment'];
          final emtAssessment = data['emtAssessment'];

          return Column(
            children: [
              // Info Banner
              Container(
                padding: const EdgeInsets.all(16),
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Your assessment will be saved separately from the call center assessment',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),

              // Call Center Assessment (Read-only)
              if (callCenterAssessment != null) ...[
                ExpansionTile(
                  leading: const Icon(Icons.phone),
                  title: const Text('Call Center Assessment'),
                  subtitle: const Text('Tap to view'),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      color: Colors.grey[100],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: callCenterAssessment.answers.map<Widget>((
                          answer,
                        ) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  answer.question,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(answer.answer),
                                if (answer.notes != null) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    'Notes: ${answer.notes}',
                                    style: const TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                const Divider(),
              ],

              // EMT Assessment Form
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: questions.length,
                  itemBuilder: (context, index) {
                    final question = questions[index];

                    // Initialize controller if not exists
                    if (!_controllers.containsKey(question.id)) {
                      _controllers[question.id] = TextEditingController();
                    }

                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '${index + 1}. ${question.question}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                if (question.isRequired)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.red[100],
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      'Required',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // Different input types
                            if (question.type == 'yes_no')
                              Row(
                                children: [
                                  Expanded(
                                    child: RadioListTile<String>(
                                      title: const Text('Yes'),
                                      value: 'Yes',
                                      groupValue: _answers[question.id],
                                      onChanged: (value) {
                                        setState(() {
                                          _answers[question.id] = value!;
                                        });
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: RadioListTile<String>(
                                      title: const Text('No'),
                                      value: 'No',
                                      groupValue: _answers[question.id],
                                      onChanged: (value) {
                                        setState(() {
                                          _answers[question.id] = value!;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              )
                            else if (question.type == 'multiple_choice' &&
                                question.options != null)
                              ...question.options!.map((option) {
                                return RadioListTile<String>(
                                  title: Text(option),
                                  value: option,
                                  groupValue: _answers[question.id],
                                  onChanged: (value) {
                                    setState(() {
                                      _answers[question.id] = value!;
                                    });
                                  },
                                );
                              }).toList()
                            else
                              TextField(
                                controller: _controllers[question.id],
                                maxLines: question.type == 'text' ? 3 : 1,
                                keyboardType: question.type == 'number'
                                    ? TextInputType.number
                                    : TextInputType.text,
                                decoration: InputDecoration(
                                  hintText: 'Enter your answer...',
                                  border: const OutlineInputBorder(),
                                ),
                                onChanged: (value) {
                                  _answers[question.id] = value;
                                },
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Submit Button
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
                child: ElevatedButton.icon(
                  onPressed: () async {
                    // Validate required fields
                    final questions = data['questions'] as List;
                    final missingRequired = questions.where(
                      (q) => q.isRequired && (_answers[q.id]?.isEmpty ?? true),
                    );

                    if (missingRequired.isNotEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please answer all required questions'),
                          backgroundColor: Colors.orange,
                        ),
                      );
                      return;
                    }

                    final success = await ref
                        .read(assessmentProvider(widget.missionId).notifier)
                        .submitEMTAssessment(_answers);

                    if (!context.mounted) return;

                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Assessment submitted successfully'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Failed to submit assessment'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.save),
                  label: const Text('Submit Assessment'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
