import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_chip.dart';
import '../../../../core/theme/chip_styles.dart';

class ToggleChip extends StatelessWidget {
  const ToggleChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  static const ChipStyle _selectedStyle = ChipStyle(
    foreground: AppColors.primary,
    background: AppColors.primaryContainer,
    icon: Icons.circle,
  );

  static const ChipStyle _unselectedStyle = ChipStyle(
    foreground: AppColors.textSecondary,
    background: AppColors.fieldBackground,
    icon: Icons.circle,
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AppChip(
        label: label,
        style: selected ? _selectedStyle : _unselectedStyle,
      ),
    );
  }
}
