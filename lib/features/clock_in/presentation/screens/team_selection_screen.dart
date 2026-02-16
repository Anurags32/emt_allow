import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/team_selection_provider.dart';

class TeamSelectionScreen extends ConsumerStatefulWidget {
  final String ambulanceId;

  const TeamSelectionScreen({super.key, required this.ambulanceId});

  @override
  ConsumerState<TeamSelectionScreen> createState() =>
      _TeamSelectionScreenState();
}

class _TeamSelectionScreenState extends ConsumerState<TeamSelectionScreen> {
  String? selectedDoctorId;
  String? selectedNurseId;

  @override
  Widget build(BuildContext context) {
    final teamState = ref.watch(teamSelectionProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Select Team')),
      body: teamState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
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
                            Icons.group,
                            size: 48,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Select Your Team',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Choose the Doctor and Nurse for this shift',
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Doctor Selection
                  Text(
                    'Select Doctor',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...teamState.availableDoctors.map((doctor) {
                    final isSelected = selectedDoctorId == doctor.id;
                    return Card(
                      color: isSelected
                          ? Theme.of(context).colorScheme.secondaryContainer
                          : null,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: isSelected
                              ? Theme.of(context).colorScheme.secondary
                              : Colors.grey,
                          child: const Icon(
                            Icons.medical_services,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(doctor.name),
                        subtitle: Text('ID: ${doctor.employeeId}'),
                        trailing: isSelected
                            ? Icon(
                                Icons.check_circle,
                                color: Theme.of(context).colorScheme.secondary,
                              )
                            : null,
                        onTap: doctor.isAvailable
                            ? () {
                                setState(() {
                                  selectedDoctorId = doctor.id;
                                });
                              }
                            : null,
                        enabled: doctor.isAvailable,
                      ),
                    );
                  }).toList(),

                  const SizedBox(height: 24),

                  // Nurse Selection
                  Text(
                    'Select Nurse',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...teamState.availableNurses.map((nurse) {
                    final isSelected = selectedNurseId == nurse.id;
                    return Card(
                      color: isSelected
                          ? Theme.of(context).colorScheme.secondaryContainer
                          : null,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: isSelected
                              ? Theme.of(context).colorScheme.secondary
                              : Colors.grey,
                          child: const Icon(
                            Icons.local_hospital,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(nurse.name),
                        subtitle: Text('ID: ${nurse.employeeId}'),
                        trailing: isSelected
                            ? Icon(
                                Icons.check_circle,
                                color: Theme.of(context).colorScheme.secondary,
                              )
                            : null,
                        onTap: nurse.isAvailable
                            ? () {
                                setState(() {
                                  selectedNurseId = nurse.id;
                                });
                              }
                            : null,
                        enabled: nurse.isAvailable,
                      ),
                    );
                  }).toList(),

                  const SizedBox(height: 24),

                  ElevatedButton.icon(
                    onPressed:
                        selectedDoctorId == null || selectedNurseId == null
                        ? null
                        : () async {
                            final success = await ref
                                .read(teamSelectionProvider.notifier)
                                .assignTeam(
                                  widget.ambulanceId,
                                  selectedDoctorId!,
                                  selectedNurseId!,
                                );

                            if (!mounted) return;

                            if (success) {
                              // Navigate to daily checklist
                              context.push(
                                '/daily-checklist/${widget.ambulanceId}',
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Failed to assign team'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('Continue to Checklist'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
