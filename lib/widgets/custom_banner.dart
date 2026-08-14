import 'package:flutter/material.dart';

/// ---------------------------------------------------------------------
/// DESIGN TOKENS
/// Clinical, calm palette — deep teal for "resolved" states,
/// warm clay for "not found / needs action" states.
/// ---------------------------------------------------------------------
class PatientBannerColors {
  static const ink = Color(0xFF1F2A2E);
  static const inkMuted = Color(0xFF5C6B6E);
  static const border = Color(0xFFE3DFD6);
  static const white = Color(0xFFFFFFFF);

  static const teal = Color(0xFF0F6B5C);
  static const tealSoft = Color(0xFFE4F1EE);

  static const clay = Color(0xFFB5522F);
  static const claySoft = Color(0xFFFBEAE3);
}

/// ---------------------------------------------------------------------
/// WIDGET 1 — Feedback Already Submitted (banner)
///
/// Shows confirmation that IP (in-patient) feedback was already
/// collected for a named patient.
///
/// Required:
///   patientName
///
/// Optional customization:
///   patientId, department, submittedAt, title, message,
///   accentColor, accentSoft, showIcon, onClose, onViewFeedback,
///   dense (tighter padding), maxWidth
/// ---------------------------------------------------------------------
class FeedbackAlreadySubmittedBanner extends StatelessWidget {
  final String patientName;
  final String? patientId;
  final String? department;
  final DateTime? submittedAt;
  final String? title;
  final String? message;
  final Color accentColor;
  final Color accentSoft;
  final bool showIcon;
  final VoidCallback? onClose;
  final VoidCallback? onViewFeedback;
  final bool dense;
  final double? maxWidth;

  const FeedbackAlreadySubmittedBanner({
    super.key,
    required this.patientName,
    this.patientId,
    this.department,
    this.submittedAt,
    this.title,
    this.message,
    this.accentColor = PatientBannerColors.teal,
    this.accentSoft = PatientBannerColors.tealSoft,
    this.showIcon = true,
    this.onClose,
    this.onViewFeedback,
    this.dense = false,
    this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    final heading = title ?? 'Feedback already submitted';
    final body =
        message ??
        "IP feedback for $patientName has already been recorded. "
            "A new submission isn't required.";

    return _StatusBanner(
      accentColor: accentColor,
      accentSoft: accentSoft,
      showIcon: showIcon,
      icon: Icons.check_circle_rounded,
      heading: heading,
      body: body,
      dense: dense,
      maxWidth: maxWidth,
      onClose: onClose,
      meta: _MetaRow(
        patientId: patientId,
        department: department,
        date: submittedAt,
      ),
      action: onViewFeedback != null
          ? _SecondaryButton(
              label: 'View submitted feedback',
              icon: Icons.arrow_forward_rounded,
              color: accentColor,
              onPressed: onViewFeedback!,
            )
          : null,
    );
  }
}

/// ---------------------------------------------------------------------
/// WIDGET 2 — No Patient Found (banner)
///
/// Shown when a lookup (by name / MRN / room) returns nothing.
///
/// Optional customization:
///   searchTerm, title, message, accentColor, accentSoft,
///   showIcon, onRetry, onClose, dense, maxWidth
/// ---------------------------------------------------------------------
class NoPatientFoundBanner extends StatelessWidget {
  final String? searchTerm;
  final String? title;
  final String? message;
  final Color accentColor;
  final Color accentSoft;
  final bool showIcon;
  final VoidCallback? onRetry;
  final VoidCallback? onClose;
  final bool dense;
  final double? maxWidth;

  const NoPatientFoundBanner({
    super.key,
    this.searchTerm,
    this.title,
    this.message,
    this.accentColor = PatientBannerColors.clay,
    this.accentSoft = PatientBannerColors.claySoft,
    this.showIcon = true,
    this.onRetry,
    this.onClose,
    this.dense = false,
    this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    final heading = title ?? 'No patient found';
    final body =
        message ??
        (searchTerm != null && searchTerm!.isNotEmpty
            ? 'We couldn\'t find a patient matching "$searchTerm". '
                  'Check the spelling or try a different ID.'
            : 'We couldn\'t find a matching patient record. Check the details and try again.');

    return _StatusBanner(
      accentColor: accentColor,
      accentSoft: accentSoft,
      showIcon: showIcon,
      icon: Icons.person_off_rounded,
      heading: heading,
      body: body,
      dense: dense,
      maxWidth: maxWidth,
      onClose: onClose,
      action: onRetry != null
          ? _SecondaryButton(
              label: 'Search again',
              icon: Icons.refresh_rounded,
              color: accentColor,
              onPressed: onRetry!,
            )
          : null,
    );
  }
}

/// ---------------------------------------------------------------------
/// Shared internal banner shell — left accent strip, icon chip,
/// heading, body, optional meta row, optional action, optional close.
/// ---------------------------------------------------------------------
class _StatusBanner extends StatelessWidget {
  final Color accentColor;
  final Color accentSoft;
  final bool showIcon;
  final IconData icon;
  final String heading;
  final String body;
  final bool dense;
  final double? maxWidth;
  final VoidCallback? onClose;
  final Widget? meta;
  final Widget? action;

  const _StatusBanner({
    required this.accentColor,
    required this.accentSoft,
    required this.showIcon,
    required this.icon,
    required this.heading,
    required this.body,
    required this.dense,
    required this.maxWidth,
    this.onClose,
    this.meta,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final content = Container(
      constraints: maxWidth != null
          ? BoxConstraints(maxWidth: maxWidth!)
          : null,
      padding: EdgeInsets.symmetric(
        horizontal: dense ? 12 : 16,
        vertical: dense ? 10 : 14,
      ),
      decoration: BoxDecoration(
        color: PatientBannerColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: PatientBannerColors.border, width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A1F2A2E),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // left accent strip
            Container(
              width: 4,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            if (showIcon) ...[
              Container(
                width: dense ? 28 : 32,
                height: dense ? 28 : 32,
                margin: const EdgeInsets.only(top: 2),
                decoration: BoxDecoration(
                  color: accentSoft,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: dense ? 16 : 18, color: accentColor),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    heading,
                    style: TextStyle(
                      fontSize: dense ? 14 : 15,
                      fontWeight: FontWeight.w600,
                      color: PatientBannerColors.ink,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    body,
                    style: TextStyle(
                      fontSize: dense ? 12.5 : 13.5,
                      color: PatientBannerColors.inkMuted,
                      height: 1.5,
                    ),
                  ),
                  if (meta != null) meta!,
                  if (action != null) ...[const SizedBox(height: 10), action!],
                ],
              ),
            ),
            if (onClose != null) ...[
              const SizedBox(width: 6),
              InkWell(
                onTap: onClose,
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    Icons.close_rounded,
                    size: 16,
                    color: PatientBannerColors.inkMuted,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );

    return content;
  }
}

class _MetaRow extends StatelessWidget {
  final String? patientId;
  final String? department;
  final DateTime? date;

  const _MetaRow({this.patientId, this.department, this.date});

  @override
  Widget build(BuildContext context) {
    if (patientId == null && department == null && date == null) {
      return const SizedBox.shrink();
    }
    final parts = <Widget>[];

    if (patientId != null) {
      parts.add(_metaChip('ID: $patientId'));
    }
    if (department != null) {
      parts.add(_metaChip(department!));
    }
    if (date != null) {
      parts.add(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.access_time_rounded,
              size: 12,
              color: PatientBannerColors.inkMuted,
            ),
            const SizedBox(width: 4),
            Text(_formatDate(date!), style: _metaStyle),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Wrap(spacing: 14, runSpacing: 4, children: parts),
    );
  }

  Widget _metaChip(String text) => Text(text, style: _metaStyle);

  static const _metaStyle = TextStyle(
    fontSize: 12,
    color: PatientBannerColors.inkMuted,
  );

  String _formatDate(DateTime d) {
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
    final hour = d.hour % 12 == 0 ? 12 : d.hour % 12;
    final ampm = d.hour >= 12 ? 'PM' : 'AM';
    final minute = d.minute.toString().padLeft(2, '0');
    return '${d.day} ${months[d.month - 1]} ${d.year} · $hour:$minute $ampm';
  }
}

class _SecondaryButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _SecondaryButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(7),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: PatientBannerColors.border),
          borderRadius: BorderRadius.circular(7),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: PatientBannerColors.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ---------------------------------------------------------------------
/// DEMO SCREEN — shows both banners with sample data.
/// Delete this in your app; import the two widgets above instead.
/// ---------------------------------------------------------------------
class PatientStatusBannersDemo extends StatefulWidget {
  const PatientStatusBannersDemo({super.key});

  @override
  State<PatientStatusBannersDemo> createState() =>
      _PatientStatusBannersDemoState();
}

class _PatientStatusBannersDemoState extends State<PatientStatusBannersDemo> {
  bool showFeedback = true;
  bool showNotFound = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F1),
      appBar: AppBar(
        title: const Text('Patient status banners'),
        backgroundColor: const Color(0xFFF7F5F1),
        foregroundColor: PatientBannerColors.ink,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showFeedback)
              FeedbackAlreadySubmittedBanner(
                patientName: '',
                patientId: '',
                department: '',
                submittedAt: DateTime.now(),
                onClose: () => setState(() => showFeedback = false),
                onViewFeedback: () {},
              ),
            const SizedBox(height: 16),
            if (showNotFound)
              NoPatientFoundBanner(
                searchTerm: 'Arvind Selvam',
                onClose: () => setState(() => showNotFound = false),
                onRetry: () {},
              ),
          ],
        ),
      ),
    );
  }
}
