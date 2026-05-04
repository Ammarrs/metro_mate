import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/subscription/verify_identity/verify_identity_cubit.dart';
import '../services/verify_identity_service.dart';

// ─── Entry point ─────────────────────────────────────────────────────────────

class VerifyIdentityPage extends StatelessWidget {
  final String category;
  final String duration;
  final int zones;
  final String planId;

  const VerifyIdentityPage({
    super.key,
    required this.category,
    required this.duration,
    required this.zones,
    required this.planId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => VerifyIdentityCubit(
        repository: VerifyIdentityRepository(),
        category: category,
        duration: duration,
        zones: zones,
        planId: planId,
      ),
      child: const _VerifyIdentityScreen(),
    );
  }
}

// ─── Colors ───────────────────────────────────────────────────────────────────

const _kTeal = Color(0xFF2DC4A2);
const _kDarkBlue = Color(0xFF1E2D4E);
const _kBg = Color(0xFFF4F6FA);
const _kBorder = Color(0xFFDDE3EE);
const _kTextMuted = Color(0xFF7A8599);

// ─── Screen ──────────────────────────────────────────────────────────────────

class _VerifyIdentityScreen extends StatelessWidget {
  const _VerifyIdentityScreen();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VerifyIdentityCubit, VerifyIdentityState>(
      listenWhen: (p, c) =>
          c.isSubmitSuccess != p.isSubmitSuccess ||
          c.submitError != p.submitError,
      listener: (context, state) {
        if (state.isSubmitSuccess) {
          Navigator.pushNamed(context, '/payment'); // adjust route name
        }
        if (state.submitError != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.submitError!),
              backgroundColor: Colors.red.shade700,
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          );
          context.read<VerifyIdentityCubit>().clearError();
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: _kBg,
          appBar: _appBar(context),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _StepHeader(state: state),
                        const SizedBox(height: 20),

                        // ── Category badge ──────────────────────────────
                        _CategoryBadge(category: state.category),
                        const SizedBox(height: 20),

                        // ── Station & Office fields ─────────────────────
                        const _SectionLabel(label: 'Commute Details'),
                        const SizedBox(height: 10),
                        _StationFields(state: state),
                        const SizedBox(height: 20),

                        // ── Documents ───────────────────────────────────
                        const _SectionLabel(label: 'Identity Documents'),
                        const SizedBox(height: 10),

                        // Category-specific extra ID
                        if (state.isStudent) ...[
                          _DocumentCard(
                            icon: Icons.badge_outlined,
                            title: 'University ID',
                            subtitle:
                                'Front side with photo and expiration date',
                            documentFile: state.universityId,
                            onTap: () => context
                                .read<VerifyIdentityCubit>()
                                .pickUniversityId(),
                            showSelectButton: true,
                          ),
                          const SizedBox(height: 12),
                        ],
                        if (state.isMilitary) ...[
                          _DocumentCard(
                            icon: Icons.military_tech_outlined,
                            title: 'Military ID',
                            subtitle: 'Valid military or police ID card',
                            documentFile: state.militaryId,
                            onTap: () => context
                                .read<VerifyIdentityCubit>()
                                .pickMilitaryId(),
                            showSelectButton: true,
                          ),
                          const SizedBox(height: 12),
                        ],

                        // National ID — always required
                        _DocumentCard(
                          icon: Icons.add_a_photo_outlined,
                          title: 'National ID (Front)',
                          subtitle: 'REQUIRED',
                          documentFile: state.nationalIdFront,
                          onTap: () => context
                              .read<VerifyIdentityCubit>()
                              .pickNationalIdFront(),
                          isRequired: true,
                        ),
                        const SizedBox(height: 12),
                        _DocumentCard(
                          icon: Icons.add_a_photo_outlined,
                          title: 'National ID (Back)',
                          subtitle: 'REQUIRED',
                          documentFile: state.nationalIdBack,
                          onTap: () => context
                              .read<VerifyIdentityCubit>()
                              .pickNationalIdBack(),
                          isRequired: true,
                        ),
                        const SizedBox(height: 20),

                        const _PhotoGuidelinesCard(),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
                _BottomActions(state: state),
              ],
            ),
          ),
        );
      },
    );
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: _kBg,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: _kDarkBlue),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        'Metro Mate',
        style: TextStyle(
          color: _kDarkBlue,
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: CircleAvatar(
            radius: 18,
            backgroundColor: _kTeal.withOpacity(0.15),
            child: const Icon(Icons.person, color: _kTeal, size: 20),
          ),
        ),
      ],
    );
  }
}

// ─── Step header ──────────────────────────────────────────────────────────────

class _StepHeader extends StatelessWidget {
  final VerifyIdentityState state;
  const _StepHeader({required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'STEP 2 OF 3',
          style: TextStyle(
            color: _kTeal,
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Verify Identity',
          style: TextStyle(
            color: _kDarkBlue,
            fontSize: 26,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Upload clear photos of your official documents\nto activate your subscription.',
          textAlign: TextAlign.center,
          style: TextStyle(color: _kTextMuted, fontSize: 13.5, height: 1.5),
        ),
        const SizedBox(height: 18),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: 2 / 3,
            minHeight: 6,
            backgroundColor: _kBorder,
            valueColor: const AlwaysStoppedAnimation<Color>(_kTeal),
          ),
        ),
      ],
    );
  }
}

// ─── Category badge ──────────────────────────────────────────────────────────

class _CategoryBadge extends StatelessWidget {
  final String category;
  const _CategoryBadge({required this.category});

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

  IconData _icon(String cat) {
    switch (cat.toLowerCase()) {
      case 'students':
        return Icons.school_rounded;
      case 'military':
        return Icons.military_tech_rounded;
      case 'elderly':
        return Icons.elderly_rounded;
      case 'special needs':
        return Icons.accessible_rounded;
      case 'public':
        return Icons.people_rounded;
      default:
        return Icons.card_membership_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: _kDarkBlue.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _kDarkBlue.withOpacity(0.12)),
      ),
      child: Row(
        children: [
          Icon(_icon(category), color: _kDarkBlue, size: 22),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Selected Category',
                style: TextStyle(
                    color: _kTextMuted,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 2),
              Text(
                _capitalize(category),
                style: const TextStyle(
                    color: _kDarkBlue,
                    fontSize: 15,
                    fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Section label ────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: const TextStyle(
        color: _kTextMuted,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.0,
      ),
    );
  }
}

// ─── Station & Office fields ──────────────────────────────────────────────────

class _StationFields extends StatelessWidget {
  final VerifyIdentityState state;
  const _StationFields({required this.state});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<VerifyIdentityCubit>();
    return Column(
      children: [
        _InputField(
          label: 'Start Station',
          hint: 'e.g. Adly Mansour',
          icon: Icons.trip_origin_rounded,
          onChanged: cubit.startStationChanged,
        ),
        const SizedBox(height: 10),
        _InputField(
          label: 'End Station',
          hint: 'e.g. Abbassiya',
          icon: Icons.location_on_rounded,
          onChanged: cubit.endStationChanged,
        ),
        const SizedBox(height: 10),
        _InputField(
          label: 'Office',
          hint: 'e.g. El-Zahraa',
          icon: Icons.business_rounded,
          onChanged: cubit.officeChanged,
        ),
      ],
    );
  }
}

class _InputField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final void Function(String) onChanged;

  const _InputField({
    required this.label,
    required this.hint,
    required this.icon,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _kBorder),
      ),
      child: TextField(
        onChanged: onChanged,
        style: const TextStyle(
            color: _kDarkBlue, fontSize: 14, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          hintStyle: const TextStyle(color: _kTextMuted, fontSize: 13),
          labelStyle: const TextStyle(color: _kTextMuted, fontSize: 13),
          prefixIcon: Icon(icon, color: _kTeal, size: 20),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}

// ─── Document card ────────────────────────────────────────────────────────────

class _DocumentCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final DocumentFile documentFile;
  final VoidCallback onTap;
  final bool showSelectButton;
  final bool isRequired;

  const _DocumentCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.documentFile,
    required this.onTap,
    this.showSelectButton = false,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    final isUploaded = documentFile.status == UploadStatus.success;
    final isUploading = documentFile.status == UploadStatus.uploading;
    final hasError = documentFile.status == UploadStatus.error;

    return GestureDetector(
      onTap: isUploading ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: isUploaded
              ? _kTeal.withOpacity(0.06)
              : hasError
                  ? Colors.red.shade50
                  : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isUploaded
                ? _kTeal.withOpacity(0.4)
                : hasError
                    ? Colors.red.shade200
                    : _kBorder,
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            // Icon
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: isUploaded
                    ? _kTeal.withOpacity(0.15)
                    : hasError
                        ? Colors.red.shade100
                        : const Color(0xFFEFF2F8),
                shape: BoxShape.circle,
              ),
              child: isUploading
                  ? const Padding(
                      padding: EdgeInsets.all(13),
                      child: CircularProgressIndicator(
                          strokeWidth: 2.5, color: _kTeal),
                    )
                  : Icon(
                      isUploaded
                          ? Icons.check_circle_rounded
                          : hasError
                              ? Icons.error_outline_rounded
                              : icon,
                      color: isUploaded
                          ? _kTeal
                          : hasError
                              ? Colors.red.shade600
                              : _kTextMuted,
                      size: 24,
                    ),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                  color: _kDarkBlue, fontSize: 14, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 3),
            Text(
              isUploaded
                  ? documentFile.fileName ?? 'Uploaded'
                  : hasError
                      ? documentFile.errorMessage ?? 'Upload failed'
                      : isUploading
                          ? 'Uploading...'
                          : subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isUploaded
                    ? _kTeal
                    : hasError
                        ? Colors.red.shade600
                        : _kTextMuted,
                fontSize: isRequired && !isUploaded && !hasError ? 10.5 : 12,
                fontWeight: isRequired && !isUploaded && !hasError
                    ? FontWeight.w700
                    : FontWeight.w400,
                letterSpacing:
                    isRequired && !isUploaded && !hasError ? 0.8 : 0,
              ),
            ),
            if (showSelectButton && !isUploading) ...[
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: onTap,
                style: OutlinedButton.styleFrom(
                  foregroundColor: _kDarkBlue,
                  side: const BorderSide(color: _kBorder, width: 1.5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                ),
                child: Text(
                  isUploaded ? 'Change File' : 'Select File',
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 13),
                ),
              ),
            ],
            if (!showSelectButton && !isUploaded && !isUploading && !hasError) ...[
              const SizedBox(height: 8),
              Text(
                'Tap to upload',
                style: TextStyle(
                    color: _kTeal.withOpacity(0.8),
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── Photo guidelines card ────────────────────────────────────────────────────

class _PhotoGuidelinesCard extends StatelessWidget {
  const _PhotoGuidelinesCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF8FF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFBDE0F5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: const Color(0xFF2980B9).withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.info_outline_rounded,
                color: Color(0xFF2980B9), size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Photo Guidelines',
                  style: TextStyle(
                      color: _kDarkBlue,
                      fontWeight: FontWeight.w700,
                      fontSize: 13.5),
                ),
                const SizedBox(height: 8),
                ...[
                  'Max file size 5MB (JPG, PNG, PDF)',
                  'Ensure no glare or shadows over details',
                  'IDs must be valid and not expired',
                ].map(
                  (g) => Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle_rounded,
                            color: _kTeal, size: 15),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(g,
                              style: const TextStyle(
                                  color: Color(0xFF4A5568), fontSize: 12.5)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Bottom actions ───────────────────────────────────────────────────────────

class _BottomActions extends StatelessWidget {
  final VerifyIdentityState state;
  const _BottomActions({required this.state});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<VerifyIdentityCubit>();

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: const BoxDecoration(
        color: _kBg,
        border: Border(top: BorderSide(color: _kBorder)),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: state.canProceed && !state.isSubmitting
              ? cubit.continueToPayment
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: _kDarkBlue,
            disabledBackgroundColor: _kDarkBlue.withOpacity(0.35),
            foregroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            elevation: 0,
          ),
          child: state.isSubmitting
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 2.5),
                )
              : const Text(
                  'Continue to Payment',
                  style:
                      TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                ),
        ),
      ),
    );
  }
}