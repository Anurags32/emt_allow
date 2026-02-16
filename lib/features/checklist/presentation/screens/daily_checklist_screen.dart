import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/checklist_provider.dart';

class DailyChecklistScreen extends ConsumerWidget {
  final String ambulanceId;

  const DailyChecklistScreen({super.key, required this.ambulanceId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checklistState = ref.watch(checklistProvider(ambulanceId));

    return Scaffold(
      appBar: AppBar(title: const Text('Daily Checklist')),
      body: checklistState.when(
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
        data: (checklist) {
          final groupedItems = <String, List<dynamic>>{};
          for (var item in checklist.items) {
            if (!groupedItems.containsKey(item.category)) {
              groupedItems[item.category] = [];
            }
            groupedItems[item.category]!.add(item);
          }

          return Column(
            children: [
              // Progress Header
              Container(
                padding: const EdgeInsets.all(16),
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Completion Progress',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${checklist.completedCount}/${checklist.totalCount}',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: checklist.completionPercentage / 100,
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${checklist.completionPercentage.toStringAsFixed(0)}% Complete',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),

              // Checklist Items
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: groupedItems.length,
                  itemBuilder: (context, index) {
                    final category = groupedItems.keys.elementAt(index);
                    final items = groupedItems[category]!;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Icon(
                                  _getCategoryIcon(category),
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  category,
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          const Divider(height: 1),
                          ...items.map((item) {
                            return CheckboxListTile(
                              value: item.isChecked,
                              onChanged: (value) {
                                ref
                                    .read(
                                      checklistProvider(ambulanceId).notifier,
                                    )
                                    .toggleItem(item.id);
                              },
                              title: Text(item.name),
                              subtitle: item.isRequired
                                  ? const Text(
                                      'Required',
                                      style: TextStyle(color: Colors.red),
                                    )
                                  : null,
                              secondary: item.isChecked
                                  ? Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                    )
                                  : Icon(
                                      Icons.circle_outlined,
                                      color: Colors.grey,
                                    ),
                            );
                          }).toList(),
                        ],
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (!checklist.isCompleted &&
                        checklist.completionPercentage < 100)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.errorContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.warning,
                              color: Theme.of(context).colorScheme.error,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Please complete all required items',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: checklist.completionPercentage == 100
                          ? () async {
                              final success = await ref
                                  .read(checklistProvider(ambulanceId).notifier)
                                  .submitChecklist();

                              if (!context.mounted) return;

                              if (success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Checklist completed!'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                                context.go('/home');
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Failed to submit checklist'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          : null,
                      icon: const Icon(Icons.check),
                      label: const Text('Complete Checklist'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'medical equipment':
        return Icons.medical_services;
      case 'safety equipment':
        return Icons.security;
      case 'vehicle':
        return Icons.local_shipping;
      case 'communication':
        return Icons.phone;
      default:
        return Icons.checklist;
    }
  }
}
