import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/availability_provider.dart';
import '../providers/active_mission_provider.dart';
import '../providers/schedule_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import '../../../../core/widgets/user_avatar.dart';
import '../../../../core/storage/secure_storage_service.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final availabilityState = ref.watch(availabilityProvider);
    final activeMissionState = ref.watch(activeMissionProvider);
    final todayScheduleAsync = ref.watch(todayScheduleProvider);
    final upcomingSchedulesAsync = ref.watch(upcomingSchedulesProvider);
    final profileAsync = ref.watch(profileProvider);

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: UserAvatar(
            size: 40,
            onTap: () {
              context.push('/profile');
            },
          ),
        ),
        title: const Text('EMT Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () async {
                        Navigator.pop(context); // Close dialog
                        await ref.read(authProvider.notifier).logout();
                        if (context.mounted) {
                          context.go('/login');
                        }
                      },
                      child: Text(
                        'Logout',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Refresh Case Number
          await ref.read(activeMissionProvider.notifier).loadActiveMission();

          // Refresh schedule data
          ref.invalidate(scheduleProvider);
          ref.invalidate(todayScheduleProvider);
          ref.invalidate(upcomingSchedulesProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Welcome Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: FutureBuilder<String?>(
                    future: ref
                        .read(secureStorageServiceProvider)
                        .getUserName(),
                    builder: (context, snapshot) {
                      final userName =
                          authState.user?.name ?? snapshot.data ?? 'EMT';
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome back,',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            userName,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            authState.user?.roleDisplayName ?? 'EMT',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Availability Toggle
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(
                        availabilityState.isOnline
                            ? Icons.check_circle
                            : Icons.cancel,
                        color: availabilityState.isOnline
                            ? Colors.green
                            : Colors.grey,
                        size: 32,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Duty Status',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                              availabilityState.isOnline ? 'Online' : 'Offline',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: availabilityState.isOnline
                                        ? Colors.green
                                        : Colors.grey,
                                  ),
                            ),
                            if (availabilityState.error != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  availabilityState.error!,
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.error,
                                      ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      if (availabilityState.isLoading)
                        const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      else
                        Switch(
                          value: availabilityState.isOnline,
                          onChanged: (value) async {
                            // If going online, show confirmation with today's schedule
                            if (!availabilityState.isOnline) {
                              final todaySchedule = await ref.read(
                                todayScheduleProvider.future,
                              );

                              if (todaySchedule != null && context.mounted) {
                                _showOnlineConfirmation(
                                  context,
                                  ref,
                                  todaySchedule,
                                );
                              } else if (context.mounted) {
                                // No schedule for today, show error
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'No schedule found for today. Please contact admin.',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: Colors.orange,
                                  ),
                                );
                              }
                            } else {
                              // Going offline, no confirmation needed
                              ref
                                  .read(availabilityProvider.notifier)
                                  .toggleAvailability();
                            }
                          },
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Case Number Card
              if (activeMissionState.isLoading)
                const Center(child: CircularProgressIndicator())
              else if (activeMissionState.mission != null)
                Card(
                  color: Theme.of(context).colorScheme.primary,
                  child: InkWell(
                    onTap: () {
                      context.push(
                        '/mission-details/${activeMissionState.mission!.id}',
                      );
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.emergency, color: Colors.white),
                              const SizedBox(width: 8),
                              Text(
                                'Case Number',
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            activeMissionState.mission!.missionNumber,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(color: Colors.white),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            activeMissionState
                                .mission!
                                .emergencyTypeDisplayName,
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(color: Colors.white),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Status: ${activeMissionState.mission!.statusDisplayName}',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: Colors.white),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton.icon(
                            onPressed: () {
                              context.push(
                                '/mission-details/${activeMissionState.mission!.id}',
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Theme.of(
                                context,
                              ).colorScheme.primary,
                            ),
                            icon: const Icon(Icons.arrow_forward),
                            label: const Text('View Mission'),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Icon(Icons.inbox, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          'No Case Number',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          availabilityState.isOnline
                              ? 'Waiting for assignment...'
                              : 'Go online to receive missions',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 16),

              // Today's Schedule Card
              todayScheduleAsync.when(
                loading: () => const Card(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ),
                error: (error, stack) => const SizedBox.shrink(),
                data: (todaySchedule) {
                  if (todaySchedule == null) {
                    return const SizedBox.shrink();
                  }

                  return Card(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Today\'s Schedule',
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.secondary,
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildScheduleDetails(
                            context,
                            todaySchedule,
                            textColor: Theme.of(context).colorScheme.onSurface,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              // Upcoming Schedules
              upcomingSchedulesAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (error, stack) => const SizedBox.shrink(),
                data: (schedules) {
                  if (schedules.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Upcoming Shifts',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      ...schedules.map(
                        (schedule) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Card(
                            child: InkWell(
                              onTap: () {
                                _showScheduleDetails(context, schedule);
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primaryContainer,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            schedule.date.split('/')[0],
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge
                                                ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                          Text(
                                            _getMonthName(
                                              schedule.date.split('/')[1],
                                            ),
                                            style: Theme.of(
                                              context,
                                            ).textTheme.bodySmall,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            schedule.shiftDisplayName,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${schedule.ambulanceVehicle} • ${schedule.ambulancePlate}',
                                            style: Theme.of(
                                              context,
                                            ).textTheme.bodyMedium,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      Icons.chevron_right,
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                    ],
                  );
                },
              ),

              const SizedBox(height: 16),

              // Quick Actions
              // Text(
              //   'Quick Actions',
              //   style: Theme.of(
              //     context,
              //   ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              // ),
              // const SizedBox(height: 12),
              // Row(
              //   children: [
              //     Expanded(
              //       child: Card(
              //         child: InkWell(
              //           onTap: () => context.push('/ambulance-assignment'),
              //           borderRadius: BorderRadius.circular(12),
              //           child: Padding(
              //             padding: const EdgeInsets.all(16),
              //             child: Column(
              //               children: [
              //                 Icon(
              //                   Icons.local_shipping,
              //                   size: 40,
              //                   color: Theme.of(context).colorScheme.primary,
              //                 ),
              //                 const SizedBox(height: 8),
              //                 Text(
              //                   'Ambulance',
              //                   textAlign: TextAlign.center,
              //                   style: Theme.of(context).textTheme.bodyMedium,
              //                 ),
              //               ],
              //             ),
              //           ),
              //         ),
              //       ),
              //     ),
              //     const SizedBox(width: 12),
              //     Expanded(
              //       child: Card(
              //         child: InkWell(
              //           onTap: () => context.push('/profile'),
              //           borderRadius: BorderRadius.circular(12),
              //           child: Padding(
              //             padding: const EdgeInsets.all(16),
              //             child: Column(
              //               children: [
              //                 Icon(
              //                   Icons.person,
              //                   size: 40,
              //                   color: Theme.of(context).colorScheme.primary,
              //                 ),
              //                 const SizedBox(height: 8),
              //                 Text(
              //                   'Profile',
              //                   textAlign: TextAlign.center,
              //                   style: Theme.of(context).textTheme.bodyMedium,
              //                 ),
              //               ],
              //             ),
              //           ),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Show loading indicator
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Row(
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  SizedBox(width: 16),
                  Text('Refreshing data...'),
                ],
              ),
              duration: Duration(seconds: 2),
            ),
          );

          // Refresh Case Number
          await ref.read(activeMissionProvider.notifier).loadActiveMission();

          // Refresh schedule data
          ref.invalidate(scheduleProvider);
          ref.invalidate(todayScheduleProvider);
          ref.invalidate(upcomingSchedulesProvider);

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.white),
                    SizedBox(width: 16),
                    Text('Data refreshed successfully!'),
                  ],
                ),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );
          }
        },
        tooltip: 'Refresh',
        child: const Icon(Icons.refresh),
      ),
    );
  }

  void _showOnlineConfirmation(BuildContext context, WidgetRef ref, schedule) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Go Online?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Confirm your team for today:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildTeamInfo(
              context,
              Icons.drive_eta,
              'Driver',
              schedule.driverNameSafe,
            ),
            const SizedBox(height: 12),
            _buildTeamInfo(
              context,
              Icons.medical_services,
              'Doctor',
              schedule.doctorNameSafe,
            ),
            const SizedBox(height: 16),
            Text(
              'Ambulance: ${schedule.ambulanceVehicle} ${schedule.ambulancePlate}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);

              final success = await ref
                  .read(availabilityProvider.notifier)
                  .toggleAvailability();

              if (context.mounted) {
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'You are now online!',
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  final error = ref.read(availabilityProvider).error;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        error ?? 'Failed to go online',
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamInfo(
    BuildContext context,
    IconData icon,
    String role,
    String name,
  ) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 12),
        Text(
          '$role: ',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
        ),
        Expanded(
          child: Text(name, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    );
  }

  Widget _buildScheduleDetails(
    BuildContext context,
    schedule, {
    Color textColor = Colors.black,
  }) {
    return Column(
      children: [
        _buildInfoRow(
          context,
          Icons.access_time,
          'Shift',
          schedule.shiftDisplayName,
          textColor: textColor,
        ),
        const SizedBox(height: 12),
        _buildInfoRow(
          context,
          Icons.local_shipping,
          'Ambulance',
          '${schedule.ambulanceVehicle} ${schedule.ambulanceModel}',
          textColor: textColor,
        ),
        const SizedBox(height: 12),
        _buildInfoRow(
          context,
          Icons.badge,
          'Plate',
          schedule.ambulancePlate,
          textColor: textColor,
        ),
        Divider(height: 24, color: textColor.withOpacity(0.3)),
        Text(
          'Team Members',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        const SizedBox(height: 12),
        if (schedule.driverName != false)
          _buildTeamMember(
            context,
            Icons.drive_eta,
            'Driver',
            schedule.driverNameSafe,
            textColor: textColor,
          ),
        if (schedule.doctorName != false)
          _buildTeamMember(
            context,
            Icons.medical_services,
            'Doctor',
            schedule.doctorNameSafe,
            textColor: textColor,
          ),
        if (schedule.nurseName != false)
          _buildTeamMember(
            context,
            Icons.local_hospital,
            'Nurse',
            schedule.nurseNameSafe,
            textColor: textColor,
          ),
        if (schedule.emtName != false)
          _buildTeamMember(
            context,
            Icons.emergency,
            'EMT',
            schedule.emtNameSafe,
            textColor: textColor,
          ),
      ],
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value, {
    Color textColor = Colors.black,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: textColor),
        const SizedBox(width: 12),
        Text(
          '$label: ',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: textColor),
          ),
        ),
      ],
    );
  }

  Widget _buildTeamMember(
    BuildContext context,
    IconData icon,
    String role,
    String name, {
    Color textColor = Colors.black,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: textColor),
          const SizedBox(width: 12),
          Text(
            '$role: ',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
          Expanded(
            child: Text(
              name,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: textColor),
            ),
          ),
        ],
      ),
    );
  }

  String _getMonthName(String month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final monthNum = int.tryParse(month);
    if (monthNum != null && monthNum >= 1 && monthNum <= 12) {
      return months[monthNum - 1];
    }
    return month;
  }

  void _showScheduleDetails(BuildContext context, schedule) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Schedule Details',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                schedule.date,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 24),
              _buildScheduleDetails(context, schedule),
            ],
          ),
        ),
      ),
    );
  }
}
