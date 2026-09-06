import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_chip.dart';
import '../../../../core/theme/chip_styles.dart';
import '../../domain/bedroom_option.dart';
import '../../domain/feed_filter.dart';
import '../../domain/filter_chip_option.dart';
import '../../domain/filter_options.dart';
import '../../domain/location_option.dart';
import '../../domain/transaction_option.dart';
import '../cubit/feed_filter_cubit.dart';
import '../cubit/filter_options_cubit.dart';
import 'price_range_section.dart' show formatNaira;

/// Horizontally scrolling row of removable chips, one per active filter
/// *group*, plus a trailing "Clear all". Visible only while a filter is
/// applied.
class ActiveFiltersBar extends StatelessWidget {
  const ActiveFiltersBar({super.key});

  @override
  Widget build(BuildContext context) {
    final FeedFilter filter = context.watch<FeedFilterCubit>().state;
    if (!filter.isActive) return const SizedBox.shrink();

    final FilterOptions? options =
        context.watch<FilterOptionsCubit>().state.options;
    final List<_ActiveChip> chips = _buildChips(filter, options);

    return SizedBox(
      height: 40,
      child: Row(
        children: [
          Expanded(
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenHorizontal,
              ),
              children: [
                for (final chip in chips)
                  Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.s),
                    child: _RemovableChip(
                      label: chip.label,
                      onRemove: () =>
                          context.read<FeedFilterCubit>().removeGroup(chip.group),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.screenHorizontal),
            child: GestureDetector(
              onTap: () => context.read<FeedFilterCubit>().clear(),
              child: Text('Clear all', style: AppTypography.linkLabel),
            ),
          ),
        ],
      ),
    );
  }

  List<_ActiveChip> _buildChips(FeedFilter filter, FilterOptions? options) {
    final chips = <_ActiveChip>[];

    if (filter.postTypes.isNotEmpty) {
      final labels = filter.postTypes
          .map((v) => _label(options?.postTypes, v, (o) => o.value == v))
          .toList();
      chips.add(_ActiveChip(FeedFilter.groupPostType, _groupLabel(labels)));
    }
    if (filter.transactionTypes.isNotEmpty) {
      final labels = filter.transactionTypes
          .map((v) => _transactionLabel(options?.transactionTypes, v))
          .toList();
      chips.add(
        _ActiveChip(FeedFilter.groupTransactionType, _groupLabel(labels)),
      );
    }
    if (filter.locationIds.isNotEmpty) {
      final labels = filter.locationIds
          .map((id) => _locationLabel(options?.locations, id))
          .toList();
      chips.add(_ActiveChip(FeedFilter.groupLocation, _groupLabel(labels)));
    }
    if (filter.minBedrooms != null) {
      final label = _bedroomLabel(options?.bedrooms, filter.minBedrooms!);
      chips.add(_ActiveChip(FeedFilter.groupBedrooms, '$label beds'));
    }
    if (filter.minPrice != null || filter.maxPrice != null) {
      final double min = filter.minPrice ?? options?.priceRange.min ?? 0;
      final double max = filter.maxPrice ?? options?.priceRange.max ?? 0;
      chips.add(_ActiveChip(
        FeedFilter.groupPrice,
        '${formatNaira(min)} – ${formatNaira(max)}',
      ));
    }
    if (filter.postedWithin != null) {
      final label =
          _label(options?.postedWithin, filter.postedWithin!, (o) => o.value == filter.postedWithin);
      chips.add(_ActiveChip(FeedFilter.groupPostedWithin, label));
    }
    if (filter.hasMedia == true) {
      chips.add(const _ActiveChip(FeedFilter.groupHasMedia, 'Photos only'));
    }

    return chips;
  }

  String _groupLabel(List<String> labels) {
    if (labels.isEmpty) return '';
    if (labels.length == 1) return labels.first;
    return '${labels.first} +${labels.length - 1}';
  }

  String _label(
    List<FilterChipOption>? options,
    String value,
    bool Function(FilterChipOption) test,
  ) {
    if (options == null) return value;
    for (final option in options) {
      if (test(option)) return option.label;
    }
    return value;
  }

  String _transactionLabel(List<TransactionOption>? options, String value) {
    if (options == null) return value;
    for (final option in options) {
      if (option.value == value) return option.label;
    }
    return value;
  }

  String _locationLabel(List<LocationOption>? options, String id) {
    if (options == null) return id;
    for (final option in options) {
      if (option.id == id) return option.label;
    }
    return id;
  }

  String _bedroomLabel(List<BedroomOption>? options, int value) {
    if (options == null) return '$value+';
    for (final option in options) {
      if (option.value == value) return option.label;
    }
    return '$value+';
  }
}

class _ActiveChip {
  const _ActiveChip(this.group, this.label);

  final String group;
  final String label;
}

class _RemovableChip extends StatelessWidget {
  const _RemovableChip({required this.label, required this.onRemove});

  final String label;
  final VoidCallback onRemove;

  static const ChipStyle _style = ChipStyle(
    foreground: AppColors.primary,
    background: AppColors.primaryContainer,
    icon: Icons.circle,
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppChip(label: label, style: _style),
        const SizedBox(width: AppSpacing.xs),
        GestureDetector(
          onTap: onRemove,
          child: const Icon(
            Icons.close,
            size: AppSpacing.iconLocation,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}
