import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../data/profile_provider.dart';
import '../../dashboard/data/dashboard_provider.dart';
import '../domain/achievement_definitions.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileControllerProvider);
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final isDark = theme.brightness == Brightness.dark;

    final cardColor = isDark ? Colors.white.withOpacity(0.05) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.white54 : Colors.black54;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'PROFILE',
          style: GoogleFonts.jetBrainsMono(
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
            color: textColor,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
      ),
      body: profileAsync.when(
        data: (profile) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: primary, width: 2),
                      color: cardColor,
                    ),
                    child: Icon(Icons.person, size: 50, color: primary),
                  ),
                ).animate().scale(),
                const SizedBox(height: 32),

                Text(
                  'IDENTITY',
                  style: GoogleFonts.jetBrainsMono(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 16),

                // Username
                TextFormField(
                  initialValue: profile.username,
                  style: GoogleFonts.inter(color: textColor),
                  decoration: InputDecoration(
                    labelText: 'CODENAME',
                    labelStyle: GoogleFonts.jetBrainsMono(color: subTextColor),
                    filled: true,
                    fillColor: cardColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: Icon(Icons.badge_outlined, color: subTextColor),
                  ),
                  onChanged: (value) {
                    // Debounce or save on submit? For now, simplistic approach
                    if (value.isNotEmpty) {
                      ref
                          .read(profileControllerProvider.notifier)
                          .updateProfile(username: value);
                    }
                  },
                ),
                const SizedBox(height: 24),

                // Theme Toggle
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            profile.isDarkMode
                                ? Icons.dark_mode
                                : Icons.light_mode,
                            color: subTextColor,
                          ),
                          const SizedBox(width: 16),
                          Text(
                            'SYSTEM THEME',
                            style: GoogleFonts.jetBrainsMono(
                              color: textColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Switch(
                        value: profile.isDarkMode,
                        activeColor: primary,
                        onChanged: (val) {
                          ref
                              .read(profileControllerProvider.notifier)
                              .updateProfile(isDarkMode: val);
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.format_quote, color: subTextColor),
                          const SizedBox(width: 16),
                          GestureDetector(
                            onTap: () async {
                              final now = TimeOfDay(
                                  hour: profile.motivationHour,
                                  minute: profile.motivationMinute);
                              final picked = await showTimePicker(
                                context: context,
                                initialTime: now,
                                builder: (context, child) {
                                  return Theme(
                                    data: isDark
                                        ? ThemeData.dark().copyWith(
                                            colorScheme: ColorScheme.dark(
                                              primary: primary,
                                              onPrimary: Colors.black,
                                              surface: const Color(0xFF222222),
                                              onSurface: Colors.white,
                                            ),
                                          )
                                        : ThemeData.light(),
                                    child: child!,
                                  );
                                },
                              );

                              if (picked != null) {
                                ref
                                    .read(profileControllerProvider.notifier)
                                    .updateProfile(
                                        motivationHour: picked.hour,
                                        motivationMinute: picked.minute);
                              }
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'DAILY MOTIVATION',
                                  style: GoogleFonts.jetBrainsMono(
                                    color: textColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Sent at ${TimeOfDay(hour: profile.motivationHour, minute: profile.motivationMinute).format(context)}',
                                      style: GoogleFonts.inter(
                                        color: Colors.grey,
                                        fontSize: 10,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Icon(Icons.edit, size: 10, color: primary),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Switch(
                        value: profile.dailyQuotesEnabled,
                        activeColor: primary,
                        onChanged: (val) {
                          ref
                              .read(profileControllerProvider.notifier)
                              .updateProfile(dailyQuotesEnabled: val);
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Achievements Section
                Text(
                  'ACHIEVEMENTS',
                  style: GoogleFonts.jetBrainsMono(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 16),

                Column(
                  children: allAchievements.map((achievement) {
                    final isUnlocked =
                        profile.completedAchievements.contains(achievement.id);
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color:
                            isUnlocked ? primary.withOpacity(0.1) : cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: isUnlocked
                            ? Border.all(color: primary.withOpacity(0.3))
                            : null,
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isUnlocked
                                  ? primary
                                  : Colors.grey.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isUnlocked ? Icons.emoji_events : Icons.lock,
                              color: isUnlocked ? Colors.black : Colors.grey,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  achievement.title,
                                  style: GoogleFonts.jetBrainsMono(
                                    fontWeight: FontWeight.bold,
                                    color: isUnlocked ? textColor : Colors.grey,
                                  ),
                                ),
                                Text(
                                  achievement.description,
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: subTextColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isUnlocked)
                            Text(
                              "+${achievement.xpReward} XP",
                              style: GoogleFonts.jetBrainsMono(
                                color: primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                        ],
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 32),
                // Stats / Calibration Header
                Consumer(
                  builder: (context, ref, child) {
                    final timeFilter = ref.watch(dashboardTimeFilterProvider);
                    final statsAsync = ref.watch(dashboardRadarStatsProvider);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'RADAR CALIBRATION',
                                  style: GoogleFonts.jetBrainsMono(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // Time Filter Dropdown
                                Container(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                    color: cardColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<DashboardTimeFilter>(
                                      value: timeFilter,
                                      dropdownColor: const Color(0xFF222222),
                                      style: GoogleFonts.jetBrainsMono(
                                          fontSize: 10, color: textColor),
                                      icon: const Icon(
                                          Icons.keyboard_arrow_down,
                                          size: 14),
                                      isDense: true,
                                      onChanged: (val) {
                                        if (val != null) {
                                          ref
                                              .read(dashboardTimeFilterProvider
                                                  .notifier)
                                              .state = val;
                                        }
                                      },
                                      items:
                                          DashboardTimeFilter.values.map((f) {
                                        return DropdownMenuItem(
                                          value: f,
                                          child: Text(f.name.toUpperCase()),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (profile.radarLabels.length < 8)
                              InkWell(
                                onTap: () {
                                  // Show prompt
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        final controller =
                                            TextEditingController();
                                        return AlertDialog(
                                          backgroundColor:
                                              const Color(0xFF222222),
                                          title: Text('NEW AXIS',
                                              style: GoogleFonts.jetBrainsMono(
                                                  color: Colors.white)),
                                          content: TextField(
                                            controller: controller,
                                            style: GoogleFonts.inter(
                                                color: Colors.white),
                                            decoration: const InputDecoration(
                                              hintText:
                                                  'Axis Name (e.g. Focus)',
                                              hintStyle: TextStyle(
                                                  color: Colors.white30),
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color:
                                                              Colors.white24)),
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.white)),
                                            ),
                                            autofocus: true,
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: const Text('CANCEL'),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                if (controller.text.isEmpty)
                                                  return;
                                                final navigator =
                                                    Navigator.of(context);

                                                final success = await ref
                                                    .read(
                                                        profileControllerProvider
                                                            .notifier)
                                                    .addRadarAxis(
                                                        controller.text.trim());

                                                navigator.pop();

                                                if (!success &&
                                                    context.mounted) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                          'Could not add axis (Duplicate or limit reached)',
                                                          style:
                                                              GoogleFonts.inter(
                                                                  color: Colors
                                                                      .white)),
                                                      backgroundColor:
                                                          Colors.redAccent,
                                                    ),
                                                  );
                                                }
                                              },
                                              child: Text('ADD',
                                                  style: TextStyle(
                                                      color: primary)),
                                            ),
                                          ],
                                        );
                                      });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Text(
                                    '+ ADD AXIS',
                                    style: GoogleFonts.jetBrainsMono(
                                      color: primary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Radar Configs / Stats List
                        statsAsync.when(
                          data: (stats) {
                            // If we have valid stats, use them. Otherwise fallback to 0.
                            final values = stats;

                            return Column(
                              children: List.generate(
                                  profile.radarLabels.length, (index) {
                                // Safe value access
                                final val =
                                    (index < values.length) ? values[index] : 0;

                                final isSelfDev = profile.radarLabels[index] ==
                                    'Self Development';

                                return _RadarConfigTile(
                                  index: index,
                                  label: profile.radarLabels[index],
                                  value: val,
                                  primary: primary,
                                  cardColor: cardColor,
                                  textColor: textColor,
                                  // Disable remove for Self Development or if < 3 items
                                  canRemove: !isSelfDev &&
                                      profile.radarLabels.length > 3,
                                  onRemove: isSelfDev
                                      ? null
                                      : () {
                                          showDialog(
                                            context: context,
                                            builder: (ctx) => AlertDialog(
                                              backgroundColor:
                                                  const Color(0xFF222222),
                                              title: Text('REMOVE AXIS?',
                                                  style:
                                                      GoogleFonts.jetBrainsMono(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                              content: Text(
                                                  'Are you sure you want to remove ${profile.radarLabels[index]}? Linked habits will lose their attribute.',
                                                  style: GoogleFonts.inter(
                                                      color: Colors.white70)),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(ctx),
                                                  child: const Text('CANCEL'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    ref
                                                        .read(
                                                            profileControllerProvider
                                                                .notifier)
                                                        .removeRadarAxis(index);
                                                    Navigator.pop(ctx);
                                                  },
                                                  child: Text('REMOVE',
                                                      style: TextStyle(
                                                          color: Colors
                                                              .redAccent)),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                );
                              }),
                            );
                          },
                          loading: () =>
                              const Center(child: LinearProgressIndicator()),
                          error: (e, s) => Text('Error loading stats',
                              style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 80),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
            child:
                Text('Error: $err', style: const TextStyle(color: Colors.red))),
      ),
    );
  }
}

class _RadarConfigTile extends ConsumerStatefulWidget {
  final int index;
  final String label;
  final int value;
  final Color primary;
  final Color cardColor;
  final Color textColor;
  final bool canRemove;
  final VoidCallback? onRemove;

  const _RadarConfigTile({
    required this.index,
    required this.label,
    required this.value,
    required this.primary,
    required this.cardColor,
    required this.textColor,
    required this.canRemove,
    required this.onRemove,
  });

  @override
  ConsumerState<_RadarConfigTile> createState() => _RadarConfigTileState();
}

class _RadarConfigTileState extends ConsumerState<_RadarConfigTile> {
  late TextEditingController _labelController;

  @override
  void initState() {
    super.initState();
    _labelController = TextEditingController(text: widget.label);
  }

  @override
  void didUpdateWidget(covariant _RadarConfigTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.label != widget.label) {
      _labelController.text = widget.label;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: widget.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: widget.cardColor),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _labelController,
                  style: GoogleFonts.inter(
                      color: widget.textColor, fontWeight: FontWeight.w600),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                  ),
                  onFieldSubmitted: (val) async {
                    final success = await ref
                        .read(profileControllerProvider.notifier)
                        .updateRadarChart(widget.index, val, widget.value);

                    if (!success && mounted) {
                      // Duplicate name or error
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Name already exists!',
                            style: GoogleFonts.inter(color: Colors.white)),
                        backgroundColor: Colors.redAccent,
                        duration: const Duration(seconds: 2),
                      ));
                      // Revert text
                      _labelController.text = widget.label;
                    }
                  },
                ),
              ),
              if (widget.canRemove)
                IconButton(
                  icon: const Icon(Icons.close, size: 16),
                  color: Colors.redAccent.withOpacity(0.7),
                  onPressed: widget.onRemove,
                  constraints: const BoxConstraints(),
                  padding: const EdgeInsets.only(right: 8),
                  splashRadius: 20,
                ),
              Text(
                '${widget.value}%',
                style: GoogleFonts.jetBrainsMono(color: widget.primary),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: widget.value / 100.0,
              backgroundColor: widget.textColor.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(widget.primary),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}
