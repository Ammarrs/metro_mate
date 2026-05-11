import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:second/components/ai_assisstant/floating_ai_button.dart';
import 'package:second/generated/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../cubits/subscription/subscription_cubit.dart';
import '../../cubits/subscription/subscription_state.dart';
import '../models/subscribtion_model.dart';
import '../views/verify_identity_screen.dart';

// ─── Entry point ──────────────────────────────────────────────────────────────
// If a subscription_id is already stored in SharedPreferences the user has an
// in-progress / pending subscription, so we redirect them straight to Screen3
// instead of making them go through the flow again.

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({super.key});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  // null  → still loading
  // true  → has active subscription_id, redirect to Screen3
  // false → no subscription_id, show normal flow
  bool? _hasActiveSubscription;

  @override
  void initState() {
    super.initState();
    _checkSubscriptionId();
  }

  Future<void> _checkSubscriptionId() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString('subscription_id') ?? '';
    if (!mounted) return;
    setState(() => _hasActiveSubscription = id.isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
    // Still reading SharedPreferences — show a blank/loading state.
    if (_hasActiveSubscription == null) {
      return const Scaffold(
        backgroundColor: Color(0xFFF0F2F5),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF1D3557)),
        ),
      );
    }

    // Already has a subscription in progress → send to Screen3 directly.
    if (_hasActiveSubscription == true) {
      // Use a post-frame callback so we navigate after the widget tree is built.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) Navigator.pushReplacementNamed(context, 'Screen3');
      });
      // Return a blank scaffold while the navigation fires.
      return const Scaffold(backgroundColor: Color(0xFFF0F2F5));
    }

    // No active subscription → normal flow.
    return BlocProvider(
      create: (_) => SubscriptionCubit()..loadCategories(),
      child: const _SubscriptionCategoryScreen(),
    );
  }
}

// ─── Category metadata (no prices — those come from API) ─────────────────────
class _CategoryMeta {
  final IconData icon;
  final String description;
  final Color color;
  final List<String> features;

  const _CategoryMeta({
    required this.icon,
    required this.description,
    required this.color,
    required this.features,
  });
}

_CategoryMeta _getMeta(BuildContext context, String key) {
  final s = S.of(context);

  switch (key.toLowerCase()) {
    case 'students':
      return _CategoryMeta(
        icon: Icons.school_rounded,
        description: s.studentsCategoryDescription,
        color: const Color(0xFF5B8FB9),
        features: [
          s.studentsFeature1,
          s.studentsFeature2,
        ],
      );

    case 'military':
      return _CategoryMeta(
        icon: Icons.military_tech_rounded,
        description: s.militaryCategoryDescription,
        color: const Color(0xFF4A7B6F),
        features: [
          s.militaryFeature1,
          s.militaryFeature2,
        ],
      );

    case 'public':
      return _CategoryMeta(
        icon: Icons.people_rounded,
        description: s.publicCategoryDescription,
        color: const Color(0xFF7B6FA4),
        features: [
          s.publicFeature1,
          s.publicFeature2,
        ],
      );

    case 'elderly':
      return _CategoryMeta(
        icon: Icons.elderly_rounded,
        description: s.elderlyCategoryDescription,
        color: const Color(0xFFB07D4A),
        features: [
          s.elderlyFeature1,
          s.elderlyFeature2,
        ],
      );

    case 'special':
      return _CategoryMeta(
        icon: Icons.favorite_rounded,
        description: s.specialCategoryDescription,
        color: const Color(0xFFB94A4A),
        features: [
          s.specialFeature1,
          s.specialFeature2,
        ],
      );

    case 'special needs':
      return _CategoryMeta(
        icon: Icons.accessible_rounded,
        description: s.specialNeedsCategoryDescription,
        color: const Color(0xFF4A8FB9),
        features: [
          s.specialNeedsFeature1,
          s.specialNeedsFeature2,
        ],
      );

    default:
      return _CategoryMeta(
        icon: Icons.card_membership_rounded,
        description: s.defaultCategoryDescription,
        color: const Color(0xFF5B8FB9),
        features: [
          s.defaultFeature1,
          s.defaultFeature2,
        ],
      );
  }
}

String _localizedCategoryName(BuildContext context, String key) {
  final s = S.of(context);

  switch (key.toLowerCase()) {
    case 'students':
      return s.studentsCategory;

    case 'military':
      return s.militaryCategory;

    case 'public':
      return s.publicCategory;

    case 'elderly':
      return s.elderlyCategory;

    case 'special':
      return s.specialCategory;

    case 'special needs':
      return s.specialNeedsCategory;

    default:
      return key;
  }
}

// ─── Step 1: Category selection ───────────────────────────────────────────────
class _SubscriptionCategoryScreen extends StatelessWidget {
  const _SubscriptionCategoryScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      body: SafeArea(
        child: BlocBuilder<SubscriptionCubit, SubscriptionState>(
          builder: (context, state) {
            if (state is SubscriptionCategoriesLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFF1D3557)),
              );
            }
            if (state is SubscriptionCategoriesError) {
              return _ErrorView(
                message: state.message,
                onRetry: () =>
                    context.read<SubscriptionCubit>().loadCategories(),
              );
            }
            if (state is SubscriptionCategoriesLoaded) {
              return _CategoryList(categories: state.categories);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _CategoryList extends StatelessWidget {
  final List<SubscriptionCategory> categories;
  const _CategoryList({required this.categories});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _Header()),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final cat = categories[index];
                final meta = _getMeta(context, cat.en);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _CategoryCard(
                    category: cat,
                    meta: meta,
                    onSelect: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider(
                          create: (_) => SubscriptionCubit()
                            ..loadPlansByCategory(cat.en.toLowerCase()),
                          child: SubscriptionPlansScreen(
                            category: cat,
                            meta: meta,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
              childCount: categories.length,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: _SmartVerificationCard(),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
            child: Column(
              children: [
                _FaqTile(
                  icon: Icons.help_outline_rounded,
                  text: S.of(context).notSurePick,
                  subtitle: S.of(context).eligibilityGuide,
                ),
                const SizedBox(height: 12),
                _FaqTile(
                  icon: Icons.verified_rounded,
                  text: S.of(context).secureSubsidies,
                  subtitle: S.of(context).subsidyDesc,
                  iconColor: const Color(0xFF2D7D46),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).step01,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade500,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 10),
          RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1D2939),
                height: 1.2,
              ),
              children: [
                TextSpan(text: S.of(context).selectCommuterProfile),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            S.of(context).tailoredSubscriptionsDescription,
            style: TextStyle(
              fontSize: 13.5,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

// No prices on this card — just icon, name, description, features, and Select button
class _CategoryCard extends StatelessWidget {
  final SubscriptionCategory category;
  final _CategoryMeta meta;
  final VoidCallback onSelect;

  const _CategoryCard({
    required this.category,
    required this.meta,
    required this.onSelect,
  });

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: meta.color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(meta.icon, color: meta.color, size: 24),
            ),
            const SizedBox(height: 14),
            Text(
              _localizedCategoryName(context, category.en),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1D2939),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              meta.description,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade500,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 14),
            ...meta.features.map(
              (f) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_rounded,
                        color: Color(0xFF2D7D46), size: 17),
                    const SizedBox(width: 8),
                    Text(
                      f,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF344054),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onSelect,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1D3557),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  S.of(context).selectProfile,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SmartVerificationCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1D3557),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).smartVerification,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            S.of(context).smartVerificationDesc,
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withOpacity(0.75),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _AvatarStack(),
              const SizedBox(width: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  S.of(context).verifiedUsers,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AvatarStack extends StatelessWidget {
  final _colors = const [
    Color(0xFF5B8FB9),
    Color(0xFF4A7B6F),
    Color(0xFF7B6FA4)
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      height: 32,
      child: Stack(
        children: List.generate(3, (i) {
          return Positioned(
            left: i * 20.0,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: _colors[i],
                shape: BoxShape.circle,
                border:
                    Border.all(color: const Color(0xFF1D3557), width: 2),
              ),
              child:
                  const Icon(Icons.person, color: Colors.white, size: 16),
            ),
          );
        }),
      ),
    );
  }
}

class _FaqTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final String subtitle;
  final Color iconColor;

  const _FaqTile({
    required this.icon,
    required this.text,
    required this.subtitle,
    this.iconColor = const Color(0xFF5B8FB9),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1D2939),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style:
                      TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 52, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              S.of(context).couldNotLoadPlans,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1D2939),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(S.of(context).retry),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1D3557),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Step 2: Plan selection (prices from API) ─────────────────────────────────

class SubscriptionPlansScreen extends StatelessWidget {
  final SubscriptionCategory category;
  final _CategoryMeta meta;

  const SubscriptionPlansScreen({
    super.key,
    required this.category,
    required this.meta,
  });

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0F2F5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded,
              color: Color(0xFF1D2939), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _localizedCategoryName(context, category.en),
          style: const TextStyle(
            color: Color(0xFF1D2939),
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ),
      body: BlocBuilder<SubscriptionCubit, SubscriptionState>(
        builder: (context, state) {
          if (state is SubscriptionPlansLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF1D3557)),
            );
          }
          if (state is SubscriptionPlansError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  state.message,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade500),
                ),
              ),
            );
          }
          if (state is SubscriptionPlansLoaded) {
            return _PlansList(result: state.result, meta: meta);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _PlansList extends StatefulWidget {
  final CategoryPlansResult result;
  final _CategoryMeta meta;

  const _PlansList({required this.result, required this.meta});

  @override
  State<_PlansList> createState() => _PlansListState();
}

class _PlansListState extends State<_PlansList> {
  int? _selectedIndex;

  Map<String, List<MapEntry<int, SubscriptionPlan>>> _grouped() {
    final map = <String, List<MapEntry<int, SubscriptionPlan>>>{};
    for (var i = 0; i < widget.result.plans.length; i++) {
      final plan = widget.result.plans[i];
      final key = _capitalize(plan.durationEn);
      map.putIfAbsent(key, () => []).add(MapEntry(i, plan));
    }
    return map;
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

  // ✅ Localized section header
  String _localizedDuration(String duration) {
    switch (duration.toLowerCase()) {
      case 'monthly':
        return S.of(context).monthly;
      case 'quarterly':
        return S.of(context).quarterly;
      case 'half yearly':
        return S.of(context).halfYearly;
      case 'yearly':
        return S.of(context).yearly;
      default:
        return duration;
    }
  }

  String _durationShort(String duration) {
    switch (duration.toLowerCase()) {
      case 'monthly':
        return S.of(context).perMonth;
      case 'quarterly':
        return S.of(context).perQuarter;
      case 'half yearly':
        return S.of(context).per6Months;
      case 'yearly':
        return S.of(context).perYear;
      default:
        return duration;
    }
  }

  @override
  Widget build(BuildContext context) {
    final grouped = _grouped();

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      S.of(context).step02,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade500,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      S.of(context).choosePlan,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1D2939),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      S.of(context).planDescription,
                      style: TextStyle(
                        fontSize: 13.5,
                        color: Colors.grey.shade500,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              // Grouped plan cards
              ...grouped.entries.map((entry) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10, top: 4),
                      child: Text(
                        _localizedDuration(entry.key), // ✅ localized
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1D2939),
                          letterSpacing: 0.4,
                        ),
                      ),
                    ),
                    ...entry.value.map((indexedPlan) {
                      final globalIndex = indexedPlan.key;
                      final plan = indexedPlan.value;
                      final isSelected = _selectedIndex == globalIndex;

                      return GestureDetector(
                        onTap: () =>
                            setState(() => _selectedIndex = globalIndex),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF1D3557)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFF1D3557)
                                  : Colors.transparent,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: isSelected
                                    ? const Color(0xFF1D3557)
                                        .withOpacity(0.18)
                                    : Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 16),
                          child: Row(
                            children: [
                              // Zone badge
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.white.withOpacity(0.15)
                                      : widget.meta.color.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: plan.zones != null
                                      ? Text(
                                          '${plan.zones}',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w800,
                                            color: isSelected
                                                ? Colors.white
                                                : widget.meta.color,
                                          ),
                                        )
                                      : Icon(
                                          Icons.all_inclusive_rounded,
                                          color: isSelected
                                              ? Colors.white
                                              : widget.meta.color,
                                          size: 22,
                                        ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              // Label
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      plan.zones != null
                                          ? '${plan.zones! > 1 ? "${plan.zones} ${S.of(context).zones}" : "${plan.zones} ${S.of(context).zone}"}'
                                          : S.of(context).allZones,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: isSelected
                                            ? Colors.white
                                            : const Color(0xFF1D2939),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Price from API
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.white
                                            : const Color(0xFF1D2939),
                                      ),
                                      children: [
                                        TextSpan(
                                          text: '${S.of(context).egp} ',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                            color: isSelected
                                                ? Colors.white
                                                    .withOpacity(0.7)
                                                : Colors.grey.shade500,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '${plan.prices.toInt()}',
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '/${_durationShort(plan.durationEn)}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: isSelected
                                          ? Colors.white.withOpacity(0.6)
                                          : Colors.grey.shade400,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 8),
                              if (isSelected)
                                const Icon(Icons.check_circle_rounded,
                                    color: Colors.white, size: 20),
                            ],
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 6),
                  ],
                );
              }),
            ],
          ),
        ),
        // Continue button
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _selectedIndex == null
                  ? null
                  : () {
                      final plan =
                          widget.result.plans[_selectedIndex!];
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => VerifyIdentityPage(
                            category: widget.result.category.en
                                .toLowerCase(),
                            duration: plan.durationEn.toLowerCase(),
                            zones: plan.zones ?? 1,
                            planId: plan.id,
                          ),
                        ),
                      );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1D3557),
                disabledBackgroundColor: Colors.grey.shade300,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              child: Text(
                S.of(context).continueBtn,
                style: const TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 16),
              ),
            ),
          ),
        ),
      ],
    );
  }
}