import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

const List<(String, String)> pricePeriods = [
  ('per_annum', 'Per year'),
  ('per_month', 'Per month'),
  ('per_night', 'Per night'),
  ('total', 'Total'),
];

class PropertyDetailsSection extends StatefulWidget {
  const PropertyDetailsSection({
    super.key,
    required this.priceAmount,
    required this.pricePeriod,
    required this.bedrooms,
    required this.bathrooms,
    required this.parkingSpaces,
    required this.onPriceAmountChanged,
    required this.onPricePeriodChanged,
    required this.onBedroomsChanged,
    required this.onBathroomsChanged,
    required this.onParkingSpacesChanged,
  });

  final num? priceAmount;
  final String? pricePeriod;
  final int? bedrooms;
  final int? bathrooms;
  final int? parkingSpaces;
  final ValueChanged<num?> onPriceAmountChanged;
  final ValueChanged<String?> onPricePeriodChanged;
  final ValueChanged<int?> onBedroomsChanged;
  final ValueChanged<int?> onBathroomsChanged;
  final ValueChanged<int?> onParkingSpacesChanged;

  @override
  State<PropertyDetailsSection> createState() =>
      _PropertyDetailsSectionState();
}

class _PropertyDetailsSectionState extends State<PropertyDetailsSection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenHorizontal,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.s),
              child: Row(
                children: [
                  Text('Property details', style: AppTypography.displayName),
                  const Spacer(),
                  Icon(
                    _expanded ? Icons.expand_less : Icons.expand_more,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
          if (_expanded) ...[
            _NumberField(
              label: 'Price',
              value: widget.priceAmount?.toString(),
              onChanged: (text) =>
                  widget.onPriceAmountChanged(num.tryParse(text)),
            ),
            const SizedBox(height: AppSpacing.s),
            Wrap(
              spacing: AppSpacing.s,
              runSpacing: AppSpacing.s,
              children: [
                for (final (value, label) in pricePeriods)
                  ChoiceChip(
                    label: Text(label, style: AppTypography.chipLabel),
                    selected: widget.pricePeriod == value,
                    onSelected: (selected) => widget.onPricePeriodChanged(
                      selected ? value : null,
                    ),
                    selectedColor: AppColors.primaryContainer,
                    backgroundColor: AppColors.fieldBackground,
                    side: BorderSide.none,
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.s),
            _NumberField(
              label: 'Bedrooms',
              value: widget.bedrooms?.toString(),
              onChanged: (text) =>
                  widget.onBedroomsChanged(int.tryParse(text)),
            ),
            const SizedBox(height: AppSpacing.s),
            _NumberField(
              label: 'Bathrooms',
              value: widget.bathrooms?.toString(),
              onChanged: (text) =>
                  widget.onBathroomsChanged(int.tryParse(text)),
            ),
            const SizedBox(height: AppSpacing.s),
            _NumberField(
              label: 'Parking spaces',
              value: widget.parkingSpaces?.toString(),
              onChanged: (text) =>
                  widget.onParkingSpacesChanged(int.tryParse(text)),
            ),
            const SizedBox(height: AppSpacing.s),
          ],
        ],
      ),
    );
  }
}

class _NumberField extends StatelessWidget {
  const _NumberField({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final String? value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(label, style: AppTypography.metaLine),
        ),
        SizedBox(
          width: 120,
          child: TextFormField(
            initialValue: value,
            keyboardType: TextInputType.number,
            style: AppTypography.body,
            textAlign: TextAlign.right,
            decoration: const InputDecoration(
              isDense: true,
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppSpacing.s,
                vertical: AppSpacing.s,
              ),
            ),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
