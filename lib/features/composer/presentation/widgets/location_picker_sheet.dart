import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/dio_client.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/locations_repository.dart';
import '../../domain/location_option.dart';
import '../cubit/location_search_cubit.dart';
import '../cubit/location_search_state.dart';

Future<LocationOption?> showLocationPickerSheet(BuildContext context) {
  return showModalBottomSheet<LocationOption>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (context) => BlocProvider(
      create: (context) => LocationSearchCubit(LocationsRepository(DioClient())),
      child: const _LocationPickerSheet(),
    ),
  );
}

class _LocationPickerSheet extends StatefulWidget {
  const _LocationPickerSheet();

  @override
  State<_LocationPickerSheet> createState() => _LocationPickerSheetState();
}

class _LocationPickerSheetState extends State<_LocationPickerSheet> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      snap: true,
      snapSizes: const [0.7, 0.95],
      builder: (context, scrollController) {
        return ClipRRect(
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
                      borderRadius:
                          BorderRadius.circular(AppSpacing.grabHandleHeight),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.m),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.screenHorizontal,
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.m,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.fieldBackground,
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusPill),
                      ),
                      child: TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        style: AppTypography.body,
                        decoration: InputDecoration(
                          hintText: 'Search for a location',
                          hintStyle: AppTypography.body
                              .copyWith(color: AppColors.textSecondary),
                          border: InputBorder.none,
                          isDense: true,
                          prefixIcon: const Icon(
                            Icons.search,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        onChanged: (value) =>
                            context.read<LocationSearchCubit>().search(value),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.m),
                  const _Divider(),
                  Expanded(
                    child: BlocBuilder<LocationSearchCubit, LocationSearchState>(
                      builder: (context, state) {
                        return switch (state.status) {
                          LocationSearchStatus.loading =>
                            const Center(child: CircularProgressIndicator()),
                          LocationSearchStatus.failure => Center(
                              child: Padding(
                                padding: const EdgeInsets.all(AppSpacing.xl),
                                child: Text(
                                  state.failure?.userMessage ??
                                      'Something went wrong.',
                                  style: AppTypography.body,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          LocationSearchStatus.success => state.results.isEmpty
                              ? Center(
                                  child: Text(
                                    'No locations found',
                                    style: AppTypography.metaLine,
                                  ),
                                )
                              : ListView.builder(
                                  controller: scrollController,
                                  itemCount: state.results.length,
                                  itemBuilder: (context, index) {
                                    final location = state.results[index];
                                    return ListTile(
                                      leading: const Icon(
                                        Icons.location_on_outlined,
                                        color: AppColors.textSecondary,
                                      ),
                                      title: Text(
                                        location.displayLabel,
                                        style: AppTypography.body,
                                      ),
                                      onTap: () =>
                                          Navigator.of(context).pop(location),
                                    );
                                  },
                                ),
                        };
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
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
