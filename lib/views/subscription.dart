import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubits/subscription/subscription_cubit.dart';
import '../../cubits/subscription/subscription_state.dart';
import '../models/subscribtion_model.dart';

class SubscriptionPage extends StatelessWidget {
  const SubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SubscriptionCubit()..loadCategories(),
      child: const _SubscriptionCategoryScreen(),
    );
  }
}

class _SubscriptionCategoryScreen extends StatelessWidget {
  const _SubscriptionCategoryScreen();

  static const _categoryMeta = {
    'students': _CategoryMeta(
      icon: Icons.school_rounded,
      description: 'Active enrollment in recognized Egyptian universities or schools required.',
      color: Color(0xFF5B8FB9),
      price: '33',
      period: 'qtr',
      features: ['Up to 180 trips', 'Valid across 3 zones'],
    ),
    'military': _CategoryMeta(
      icon: Icons.military_tech_rounded,
      description: 'Dedicated rates for the Armed Forces, Police, and Veterans.',
      color: Color(0xFF4A7B6F),
      price: '75',
      period: 'qtr',
      features: ['Unlimited zone access', 'Family companion discount'],
    ),
    'public': _CategoryMeta(
      icon: Icons.people_rounded,
      description: 'Standard subscription for private and public sector professionals.',
      color: Color(0xFF7B6FA4),
      price: '150',
      period: 'mo',
      features: ['Auto-renew monthly', 'Digital receipt tracking'],
    ),
    'elderly': _CategoryMeta(
      icon: Icons.elderly_rounded,
      description: 'Special rates for senior citizens aged 60 and above.',
      color: Color(0xFFB07D4A),
      price: '25',
      period: 'mo',
      features: ['Priority boarding', 'Valid across all zones'],
    ),
    'special': _CategoryMeta(
      icon: Icons.favorite_rounded,
      description: 'Exclusive support for families of martyrs and special cases.',
      color: Color(0xFFB94A4A),
      price: '20',
      period: 'mo',
      features: ['Free zone access', 'Government-backed subsidy'],
    ),
    'special needs': _CategoryMeta(
      icon: Icons.accessible_rounded,
      description: 'Tailored access for individuals with special needs.',
      color: Color(0xFF4A8FB9),
      price: '15',
      period: 'mo',
      features: ['Unlimited trips', 'Accessible boarding support'],
    ),
  };

  _CategoryMeta _getMeta(String categoryKey) {
    return _categoryMeta[categoryKey.toLowerCase()] ??
        const _CategoryMeta(
          icon: Icons.card_membership_rounded,
          description: 'Subsidized subscription plan for eligible commuters.',
          color: Color(0xFF5B8FB9),
          price: '50',
          period: 'mo',
          features: ['Valid on all lines', 'Digital pass included'],
        );
  }

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
                onRetry: () => context.read<SubscriptionCubit>().loadCategories(),
              );
            }

            if (state is SubscriptionCategoriesLoaded) {
              return _CategoryList(
                categories: state.categories,
                getMeta: _getMeta,
              );
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
  final _CategoryMeta Function(String) getMeta;

  const _CategoryList({required this.categories, required this.getMeta});

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
                final meta = getMeta(cat.en);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _CategoryCard(
                    category: cat,
                    meta: meta,
                    onSelect: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider(
                            create: (_) => SubscriptionCubit()
                              ..loadPlansByCategory(cat.en),
                            child: SubscriptionPlansScreen(category: cat, meta: meta),
                          ),
                        ),
                      );
                    },
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
              children: const [
                _FaqTile(
                  icon: Icons.help_outline_rounded,
                  text: 'Not sure which to pick?',
                  subtitle: 'Check our detailed eligibility guide for commuters.',
                ),
                SizedBox(height: 12),
                _FaqTile(
                  icon: Icons.verified_rounded,
                  text: 'Secure Subsidies',
                  subtitle: 'Government-backed discounts are directly applied to your wallet.',
                  iconColor: Color(0xFF2D7D46),
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
            'STEP 01/02',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade500,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 10),
          RichText(
            text: const TextSpan(
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1D2939),
                height: 1.2,
              ),
              children: [
                TextSpan(text: 'Select your\n'),
                TextSpan(
                  text: 'commuter profile',
                  style: TextStyle(
                    color: Color(0xFF1D3557),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Tailored subscriptions for the backbone of Cairo. Choose the category that fits your daily journey to unlock exclusive subsidized rates.',
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

class _CategoryCard extends StatelessWidget {
  final SubscriptionCategory category;
  final _CategoryMeta meta;
  final VoidCallback onSelect;

  const _CategoryCard({
    required this.category,
    required this.meta,
    required this.onSelect,
  });

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
              _capitalize(category.en),
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
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'EGP',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  meta.price,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1D2939),
                    height: 1,
                  ),
                ),
                Text(
                  ' /${meta.period}',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
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
                child: const Text(
                  'Select Profile',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
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
          const Text(
            'Smart\nVerification',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Your chosen profile will require a valid ID upload in the next step. Documents are verified in under 15 minutes by our AI system.',
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
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '+15k verified',
                  style: TextStyle(
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
  final _colors = const [Color(0xFF5B8FB9), Color(0xFF4A7B6F), Color(0xFF7B6FA4)];

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
                border: Border.all(color: const Color(0xFF1D3557), width: 2),
              ),
              child: const Icon(Icons.person, color: Colors.white, size: 16),
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
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
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
              'Could not load plans',
              style: const TextStyle(
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
              label: const Text('Retry'),
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

class _CategoryMeta {
  final IconData icon;
  final String description;
  final Color color;
  final String price;
  final String period;
  final List<String> features;

  const _CategoryMeta({
    required this.icon,
    required this.description,
    required this.color,
    required this.price,
    required this.period,
    required this.features,
  });
}


// ─────────────────────────────────────────────────────────────────────────────
// Step 2: Plan selection screen
// ─────────────────────────────────────────────────────────────────────────────

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
          _capitalize(category.en),
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
            return _PlansErrorView(message: state.message);
          }

          if (state is SubscriptionPlansLoaded) {
            return _PlansList(
              result: state.result,
              meta: meta,
            );
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

  @override
  Widget build(BuildContext context) {
    final plans = widget.result.plans;

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'STEP 02/02',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade500,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Choose your plan',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1D2939),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Select the zone coverage that matches your daily commute.',
                      style: TextStyle(
                        fontSize: 13.5,
                        color: Colors.grey.shade500,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              ...List.generate(plans.length, (index) {
                final plan = plans[index];
                final isSelected = _selectedIndex == index;
                return GestureDetector(
                  onTap: () => setState(() => _selectedIndex = index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(bottom: 14),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF1D3557)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF1D3557)
                            : Colors.transparent,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: isSelected
                              ? const Color(0xFF1D3557).withOpacity(0.18)
                              : Colors.black.withOpacity(0.05),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
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
                            child: Text(
                              '${plan.zones}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: isSelected
                                    ? Colors.white
                                    : widget.meta.color,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${plan.zones} Zone${plan.zones > 1 ? 's' : ''}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: isSelected
                                      ? Colors.white
                                      : const Color(0xFF1D2939),
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                '${plan.durationEn.substring(0, 1).toUpperCase()}${plan.durationEn.substring(1)} subscription',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: isSelected
                                      ? Colors.white.withOpacity(0.7)
                                      : Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          const Icon(Icons.check_circle_rounded,
                              color: Colors.white, size: 22),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _selectedIndex == null
                  ? null
                  : () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Plan selected: ${widget.result.plans[_selectedIndex!].zones} zone(s)',
                          ),
                          backgroundColor: const Color(0xFF1D3557),
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
              child: const Text(
                'Continue',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PlansErrorView extends StatelessWidget {
  final String message;

  const _PlansErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline_rounded, size: 48, color: Colors.grey),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}