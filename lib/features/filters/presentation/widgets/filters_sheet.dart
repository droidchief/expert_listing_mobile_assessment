import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/bedroom_option.dart';
import '../../domain/feed_filter.dart';
import '../../domain/filter_options.dart';
import '../../domain/transaction_option.dart';
import '../cubit/feed_filter_cubit.dart';
import '../cubit/filter_options_cubit.dart';
import '../cubit/filter_options_state.dart';
import 'filter_section_heading.dart';
import 'price_range_section.dart';
import 'toggle_chip.dart';

Future<void> showFiltersSheet(BuildContext context) {
  final feedFilterCubit = context.read<FeedFilterCubit>();
  final filterOptionsCubit = context.read<FilterOptionsCubit>();
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (context) => MultiBlocProvider(
      providers: [
        BlocProvider.value(value: feedFilterCubit),
        BlocProvider.value(value: filterOptionsCubit),
      ],
      child: const FiltersSheet(),
    ),
  );
}

class FiltersSheet extends StatefulWidget {
  const FiltersSheet({super.key});

  @override
  State<FiltersSheet> createState() => _FiltersSheetState();
}

class _FiltersSheetState extends State<FiltersSheet> {
  late FeedFilter _draft;

  @override
  void initState() {
    super.initState();
    _draft = context.read<FeedFilterCubit>().state;
  }

  void _clearAll() => setState(() => _draft = FeedFilter.empty);

  void _apply() {
    context.read<FeedFilterCubit>().apply(_draft);
    Navigator.of(context).maybePop();
  }

  void _togglePostType(String value, FilterOptions options) {
    setState(() {
      final Set<String> postTypes = Set.of(_draft.postTypes);
      if (!postTypes.remove(value)) postTypes.add(value);

      final Set<String> validTransactionValues = postTypes.isEmpty
          ? options.transactionTypes.map((t) => t.value).toSet()
          : options.transactionTypes
                .where((t) => postTypes.contains(t.postType))
                .map((t) => t.value)
                .toSet();
      final Set<String> transactionTypes = _draft.transactionTypes
          .where(validTransactionValues.contains)
          .toSet();

      _draft = _draft.copyWith(
        postTypes: postTypes,
        transactionTypes: transactionTypes,
      );
    });
  }

  void _toggleTransactionType(String value) {
    setState(() {
      final Set<String> transactionTypes = Set.of(_draft.transactionTypes);
      if (!transactionTypes.remove(value)) transactionTypes.add(value);
      _draft = _draft.copyWith(transactionTypes: transactionTypes);
    });
  }

  void _toggleLocation(String id) {
    setState(() {
      final Set<String> locationIds = Set.of(_draft.locationIds);
      if (!locationIds.remove(id)) locationIds.add(id);
      _draft = _draft.copyWith(locationIds: locationIds);
    });
  }

  void _toggleBedrooms(int value) {
    setState(() {
      _draft = _draft.minBedrooms == value
          ? _draft.copyWith(clearMinBedrooms: true)
          : _draft.copyWith(minBedrooms: value);
    });
  }

  void _togglePostedWithin(String value) {
    setState(() {
      _draft = _draft.postedWithin == value
          ? _draft.copyWith(clearPostedWithin: true)
          : _draft.copyWith(postedWithin: value);
    });
  }

  void _togglePhotosOnly(bool value) {
    setState(() {
      _draft = value
          ? _draft.copyWith(hasMedia: true)
          : _draft.copyWith(clearHasMedia: true);
    });
  }

  List<TransactionOption> _visibleTransactionOptions(FilterOptions options) {
    if (_draft.postTypes.isEmpty) return options.transactionTypes;
    return options.transactionTypes
        .where((t) => _draft.postTypes.contains(t.postType))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // The modal route's own barrier sits behind this whole builder
        // result, so it never sees taps in the space above the sheet card —
        // handle "tap outside to dismiss" here instead.
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Navigator.of(context).maybePop(),
          ),
        ),
        _buildSheet(context),
      ],
    );
  }

  Widget _buildSheet(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      snap: true,
      snapSizes: const [0.75, 0.95],
      builder: (context, scrollController) {
        return GestureDetector(
          // Absorb taps on the card itself so they don't fall through to
          // the dismiss detector behind it.
          onTap: () {},
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppSpacing.radiusSheet),
            ),
            child: Container(
              color: AppColors.surface,
              child: SafeArea(
                top: false,
                child: Column(
                  children: [
                    const SizedBox(height: AppSpacing.m),
                    Container(
                      width: AppSpacing.grabHandleWidth,
                      height: AppSpacing.grabHandleHeight,
                      decoration: BoxDecoration(
                        color: AppColors.divider,
                        borderRadius: BorderRadius.circular(
                          AppSpacing.grabHandleHeight,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.m),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.screenHorizontal,
                      ),
                      child: Row(
                        children: [
                          Text('Filters', style: AppTypography.displayName),
                          const Spacer(),
                          GestureDetector(
                            onTap: _clearAll,
                            child: Text(
                              'Clear all',
                              style: AppTypography.linkLabel,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.m),
                    const _Divider(),
                    Expanded(
                      child:
                          BlocBuilder<FilterOptionsCubit, FilterOptionsState>(
                            builder: (context, state) => switch (state.status) {
                              FilterOptionsStatus.success => _SheetBody(
                                options: state.options!,
                                draft: _draft,
                                scrollController: scrollController,
                                onPostTypeTap: (v) =>
                                    _togglePostType(v, state.options!),
                                onTransactionTypeTap: _toggleTransactionType,
                                onLocationTap: _toggleLocation,
                                onBedroomsTap: _toggleBedrooms,
                                onPostedWithinTap: _togglePostedWithin,
                                onPhotosOnlyChanged: _togglePhotosOnly,
                                onPriceChanged: (values) {
                                  setState(() {
                                    final priceRange =
                                        state.options!.priceRange;
                                    _draft = _draft.copyWith(
                                      minPrice: values.start > priceRange.min
                                          ? values.start
                                          : null,
                                      clearMinPrice:
                                          values.start <= priceRange.min,
                                      maxPrice: values.end < priceRange.max
                                          ? values.end
                                          : null,
                                      clearMaxPrice:
                                          values.end >= priceRange.max,
                                    );
                                  });
                                },
                                visibleTransactionOptions:
                                    _visibleTransactionOptions(state.options!),
                              ),
                              FilterOptionsStatus.failure => Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(AppSpacing.xl),
                                  child: Text(
                                    state.failure?.userMessage ??
                                        'Something went wrong loading filters.',
                                    style: AppTypography.body,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              FilterOptionsStatus.initial ||
                              FilterOptionsStatus.loading => const Center(
                                child: CircularProgressIndicator(),
                              ),
                            },
                          ),
                    ),
                    const _Divider(),
                    Padding(
                      padding: const EdgeInsets.all(
                        AppSpacing.screenHorizontal,
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: _apply,
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(
                              vertical: AppSpacing.m,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppSpacing.radiusPill,
                              ),
                            ),
                          ),
                          child: const Text('Show results'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SheetBody extends StatelessWidget {
  const _SheetBody({
    required this.options,
    required this.draft,
    required this.scrollController,
    required this.onPostTypeTap,
    required this.onTransactionTypeTap,
    required this.onLocationTap,
    required this.onBedroomsTap,
    required this.onPostedWithinTap,
    required this.onPhotosOnlyChanged,
    required this.onPriceChanged,
    required this.visibleTransactionOptions,
  });

  final FilterOptions options;
  final FeedFilter draft;
  final ScrollController scrollController;
  final ValueChanged<String> onPostTypeTap;
  final ValueChanged<String> onTransactionTypeTap;
  final ValueChanged<String> onLocationTap;
  final ValueChanged<int> onBedroomsTap;
  final ValueChanged<String> onPostedWithinTap;
  final ValueChanged<bool> onPhotosOnlyChanged;
  final ValueChanged<RangeValues> onPriceChanged;
  final List<TransactionOption> visibleTransactionOptions;

  @override
  Widget build(BuildContext context) {
    final RangeValues priceValues = RangeValues(
      draft.minPrice ?? options.priceRange.min,
      draft.maxPrice ?? options.priceRange.max,
    );

    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenHorizontal,
      ),
      children: [
        const FilterSectionHeading('Post type'),
        Wrap(
          spacing: AppSpacing.s,
          runSpacing: AppSpacing.s,
          children: [
            for (final option in options.postTypes)
              ToggleChip(
                label: option.label,
                selected: draft.postTypes.contains(option.value),
                onTap: () => onPostTypeTap(option.value),
              ),
          ],
        ),
        if (visibleTransactionOptions.isNotEmpty) ...[
          const FilterSectionHeading('Looking for'),
          Wrap(
            spacing: AppSpacing.s,
            runSpacing: AppSpacing.s,
            children: [
              for (final option in visibleTransactionOptions)
                ToggleChip(
                  label: option.label,
                  selected: draft.transactionTypes.contains(option.value),
                  onTap: () => onTransactionTypeTap(option.value),
                ),
            ],
          ),
        ],
        if (options.locations.isNotEmpty) ...[
          const FilterSectionHeading('Location'),
          Wrap(
            spacing: AppSpacing.s,
            runSpacing: AppSpacing.s,
            children: [
              for (final location in options.locations)
                ToggleChip(
                  label: location.label,
                  selected: draft.locationIds.contains(location.id),
                  onTap: () => onLocationTap(location.id),
                ),
            ],
          ),
        ],
        if (options.bedrooms.isNotEmpty) ...[
          const FilterSectionHeading('Bedrooms'),
          Wrap(
            spacing: AppSpacing.s,
            runSpacing: AppSpacing.s,
            children: [
              for (final BedroomOption bedroom in options.bedrooms)
                ToggleChip(
                  label: bedroom.label,
                  selected: draft.minBedrooms == bedroom.value,
                  onTap: () => onBedroomsTap(bedroom.value),
                ),
            ],
          ),
        ],
        const FilterSectionHeading('Price'),
        PriceRangeSection(
          priceRange: options.priceRange,
          values: priceValues,
          onChanged: onPriceChanged,
        ),
        if (options.postedWithin.isNotEmpty) ...[
          const FilterSectionHeading('Posted'),
          Wrap(
            spacing: AppSpacing.s,
            runSpacing: AppSpacing.s,
            children: [
              for (final option in options.postedWithin)
                ToggleChip(
                  label: option.label,
                  selected: draft.postedWithin == option.value,
                  onTap: () => onPostedWithinTap(option.value),
                ),
            ],
          ),
        ],
        const FilterSectionHeading('Photos only'),
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.l),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Only show posts with photos or video',
                  style: AppTypography.metaLine,
                ),
              ),
              Switch(
                value: draft.hasMedia == true,
                activeThumbColor: AppColors.primary,
                onChanged: onPhotosOnlyChanged,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: AppSpacing.cardSeparator,
      child: ColoredBox(color: AppColors.divider),
    );
  }
}
