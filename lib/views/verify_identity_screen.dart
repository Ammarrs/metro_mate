import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/subscription/verify_identity/verify_identity_cubit.dart';
import '../services/verify_identity_service.dart';

// ─── Entry point ──────────────────────────────────────────────────────────────

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
      child: const _VerifyIdentityView(),
    );
  }
}

// ─── Thin StatefulWidget wrapper — triggers loadDropdowns once ────────────────

class _VerifyIdentityView extends StatefulWidget {
  const _VerifyIdentityView();

  @override
  State<_VerifyIdentityView> createState() => _VerifyIdentityViewState();
}

class _VerifyIdentityViewState extends State<_VerifyIdentityView> {
  @override
  void initState() {
    super.initState();
    context.read<VerifyIdentityCubit>().loadDropdowns();
  }

  @override
  Widget build(BuildContext context) => const _VerifyIdentityScreen();
}

// ─── Screen ───────────────────────────────────────────────────────────────────

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
          Navigator.pushNamed(context, 'Screen3');
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
          backgroundColor: const Color(0xFFF4F6FA),
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

                        _CategoryBadge(category: state.category),
                        const SizedBox(height: 20),

                        const _SectionLabel(label: 'Commute Details'),
                        const SizedBox(height: 10),
                        _StationFields(state: state),
                        const SizedBox(height: 20),

                        const _SectionLabel(label: 'Identity Documents'),
                        const SizedBox(height: 10),

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
      backgroundColor: const Color(0xFFF4F6FA),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Color(0xFF1E2D4E)),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        'Metro Mate',
        style: TextStyle(
          color: Color(0xFF1E2D4E),
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: CircleAvatar(
            radius: 18,
            backgroundColor: Color(0x262DC4A2),
            child: const Icon(Icons.person, color: Color(0xFF2DC4A2), size: 20),
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
            color: Color(0xFF2DC4A2),
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Verify Identity',
          style: TextStyle(
            color: Color(0xFF1E2D4E),
            fontSize: 26,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Upload clear photos of your official documents\nto activate your subscription.',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Color(0xFF7A8599), fontSize: 13.5, height: 1.5),
        ),
        const SizedBox(height: 18),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: const LinearProgressIndicator(
            value: 2 / 3,
            minHeight: 6,
            backgroundColor: Color(0xFFDDE3EE),
            valueColor:
                AlwaysStoppedAnimation<Color>(Color(0xFF2DC4A2)),
          ),
        ),
      ],
    );
  }
}

// ─── Category badge ───────────────────────────────────────────────────────────

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
        color: const Color(0xFF1E2D4E).withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF1E2D4E).withOpacity(0.12)),
      ),
      child: Row(
        children: [
          Icon(_icon(category), color: const Color(0xFF1E2D4E), size: 22),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Selected Category',
                style: TextStyle(
                    color: Color(0xFF7A8599),
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 2),
              Text(
                _capitalize(category),
                style: const TextStyle(
                    color: Color(0xFF1E2D4E),
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
        color: Color(0xFF7A8599),
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
    final loading = state.isLoadingDropdowns;

    final stationNames = state.stations.map((s) => s.name).toList();
    final officeNames = state.offices.map((o) => o.name).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Retry banner — only visible on error, fields always stay rendered
        if (state.dropdownError != null)
          _RetryBanner(onRetry: cubit.loadDropdowns),

        _DropdownField(
          label: 'Start Station',
          hint: 'Select start station',
          icon: Icons.trip_origin_rounded,
          items: stationNames,
          value: state.startStation.isEmpty ? null : state.startStation,
          isLoading: loading,
          onChanged: cubit.startStationChanged,
        ),
        const SizedBox(height: 10),
        _DropdownField(
          label: 'End Station',
          hint: 'Select end station',
          icon: Icons.location_on_rounded,
          items: stationNames,
          value: state.endStation.isEmpty ? null : state.endStation,
          isLoading: loading,
          onChanged: cubit.endStationChanged,
        ),
        const SizedBox(height: 10),
        _DropdownField(
          label: 'Office',
          hint: 'Select subscription office',
          icon: Icons.business_rounded,
          items: officeNames,
          value: state.office.isEmpty ? null : state.office,
          isLoading: loading,
          onChanged: cubit.officeChanged,
        ),
      ],
    );
  }
}

// ─── Retry banner ─────────────────────────────────────────────────────────────

class _RetryBanner extends StatelessWidget {
  final VoidCallback onRetry;
  const _RetryBanner({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.wifi_off_rounded, color: Colors.red.shade500, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Could not load stations. Tap to retry.',
              style:
                  TextStyle(color: Colors.red.shade700, fontSize: 12.5),
            ),
          ),
          GestureDetector(
            onTap: onRetry,
            child: Icon(Icons.refresh_rounded,
                color: Colors.red.shade500, size: 20),
          ),
        ],
      ),
    );
  }
}

// ─── Dropdown field with search bottom sheet ──────────────────────────────────

class _DropdownField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final List<String> items;
  final String? value;
  final bool isLoading;
  final void Function(String) onChanged;

  const _DropdownField({
    required this.label,
    required this.hint,
    required this.icon,
    required this.items,
    required this.value,
    required this.isLoading,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading || items.isEmpty
          ? null
          : () => _openSearchSheet(context),
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFDDE3EE)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF2DC4A2), size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: isLoading
                  ? const _ShimmerLine()
                  : value != null
                      ? Text(
                          value!,
                          style: const TextStyle(
                            color: Color(0xFF1E2D4E),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      : Text(
                          hint,
                          style: const TextStyle(
                              color: Color(0xFF7A8599), fontSize: 13),
                        ),
            ),
            if (isLoading)
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Color(0xFF2DC4A2)),
              )
            else
              const Icon(Icons.keyboard_arrow_down_rounded,
                  color: Color(0xFF7A8599), size: 22),
          ],
        ),
      ),
    );
  }

  void _openSearchSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _SearchBottomSheet(
        title: label,
        items: items,
        selectedValue: value,
        onSelected: (picked) {
          onChanged(picked);
          Navigator.pop(context);
        },
      ),
    );
  }
}

// ─── Shimmer loading line inside the field ────────────────────────────────────

class _ShimmerLine extends StatefulWidget {
  const _ShimmerLine();

  @override
  State<_ShimmerLine> createState() => _ShimmerLineState();
}

class _ShimmerLineState extends State<_ShimmerLine>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        height: 12,
        width: 140,
        decoration: BoxDecoration(
          color: Color.fromRGBO(
              221, 227, 238, 0.4 + _anim.value * 0.5),
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    );
  }
}

// ─── Search bottom sheet ──────────────────────────────────────────────────────

class _SearchBottomSheet extends StatefulWidget {
  final String title;
  final List<String> items;
  final String? selectedValue;
  final void Function(String) onSelected;

  const _SearchBottomSheet({
    required this.title,
    required this.items,
    required this.selectedValue,
    required this.onSelected,
  });

  @override
  State<_SearchBottomSheet> createState() => _SearchBottomSheetState();
}

class _SearchBottomSheetState extends State<_SearchBottomSheet> {
  late List<String> _filtered;
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filtered = widget.items;
  }

  void _onSearch(String query) {
    final q = query.trim().toLowerCase();
    setState(() {
      _filtered = q.isEmpty
          ? widget.items
          : widget.items
              .where((s) => s.toLowerCase().contains(q))
              .toList();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sheetHeight = MediaQuery.of(context).size.height * 0.75;

    return Container(
      height: sheetHeight,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Handle
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFDDE3EE),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),

          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.title,
                style: const TextStyle(
                  color: Color(0xFF1E2D4E),
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Search box
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF4F6FA),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFDDE3EE)),
              ),
              child: TextField(
                controller: _controller,
                autofocus: true,
                onChanged: _onSearch,
                style: const TextStyle(
                    color: Color(0xFF1E2D4E), fontSize: 14),
                decoration: const InputDecoration(
                  hintText: 'Search...',
                  hintStyle:
                      TextStyle(color: Color(0xFF7A8599), fontSize: 13),
                  prefixIcon: Icon(Icons.search_rounded,
                      color: Color(0xFF7A8599), size: 20),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 12, vertical: 12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Result count
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${_filtered.length} result${_filtered.length == 1 ? '' : 's'}',
                style: const TextStyle(
                    color: Color(0xFF7A8599), fontSize: 11.5),
              ),
            ),
          ),

          // List
          Expanded(
            child: _filtered.isEmpty
                ? const Center(
                    child: Text(
                      'No matches found',
                      style: TextStyle(
                          color: Color(0xFF7A8599), fontSize: 13.5),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 4),
                    itemCount: _filtered.length,
                    separatorBuilder: (_, __) => const Divider(
                        height: 1, color: Color(0x99DDE3EE)),
                    itemBuilder: (_, i) {
                      final item = _filtered[i];
                      final isSelected = item == widget.selectedValue;
                      return ListTile(
                        dense: true,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 8),
                        title: Text(
                          item,
                          style: TextStyle(
                            color: isSelected
                                ? const Color(0xFF2DC4A2)
                                : const Color(0xFF1E2D4E),
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                        trailing: isSelected
                            ? const Icon(Icons.check_rounded,
                                color: Color(0xFF2DC4A2), size: 18)
                            : null,
                        onTap: () => widget.onSelected(item),
                      );
                    },
                  ),
          ),
        ],
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
        padding:
            const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: isUploaded
              ? const Color(0xFF2DC4A2).withOpacity(0.06)
              : hasError
                  ? Colors.red.shade50
                  : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isUploaded
                ? const Color(0xFF2DC4A2).withOpacity(0.4)
                : hasError
                    ? Colors.red.shade200
                    : const Color(0xFFDDE3EE),
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: isUploaded
                    ? const Color(0xFF2DC4A2).withOpacity(0.15)
                    : hasError
                        ? Colors.red.shade100
                        : const Color(0xFFEFF2F8),
                shape: BoxShape.circle,
              ),
              child: isUploading
                  ? const Padding(
                      padding: EdgeInsets.all(13),
                      child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Color(0xFF2DC4A2)),
                    )
                  : Icon(
                      isUploaded
                          ? Icons.check_circle_rounded
                          : hasError
                              ? Icons.error_outline_rounded
                              : icon,
                      color: isUploaded
                          ? const Color(0xFF2DC4A2)
                          : hasError
                              ? Colors.red.shade600
                              : const Color(0xFF7A8599),
                      size: 24,
                    ),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                  color: Color(0xFF1E2D4E),
                  fontSize: 14,
                  fontWeight: FontWeight.w700),
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
                    ? const Color(0xFF2DC4A2)
                    : hasError
                        ? Colors.red.shade600
                        : const Color(0xFF7A8599),
                fontSize:
                    isRequired && !isUploaded && !hasError ? 10.5 : 12,
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
                  foregroundColor: const Color(0xFF1E2D4E),
                  side: const BorderSide(
                      color: Color(0xFFDDE3EE), width: 1.5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 8),
                ),
                child: Text(
                  isUploaded ? 'Change File' : 'Select File',
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 13),
                ),
              ),
            ],
            if (!showSelectButton &&
                !isUploaded &&
                !isUploading &&
                !hasError) ...[
              const SizedBox(height: 8),
              Text(
                'Tap to upload',
                style: TextStyle(
                    color: const Color(0xFF2DC4A2).withOpacity(0.8),
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
                      color: Color(0xFF1E2D4E),
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
                            color: Color(0xFF2DC4A2), size: 15),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(g,
                              style: const TextStyle(
                                  color: Color(0xFF4A5568),
                                  fontSize: 12.5)),
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
        color: Color(0xFFF4F6FA),
        border: Border(
            top: BorderSide(color: Color(0xFFDDE3EE))),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: state.canProceed && !state.isSubmitting
              ? cubit.continueToPayment
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1E2D4E),
            disabledBackgroundColor:
                const Color(0xFF1E2D4E).withOpacity(0.35),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50)),
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
                  style: TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 15),
                ),
        ),
      ),
    );
  }
}