import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/network/dio_client.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../feed/presentation/cubit/feed_cubit.dart';
import '../../../filters/presentation/widgets/filter_section_heading.dart';
import '../../../filters/presentation/widgets/toggle_chip.dart';
import '../../data/composer_repository.dart';
import '../../data/upload_repository.dart';
import '../../domain/location_option.dart';
import '../cubit/composer_cubit.dart';
import '../cubit/composer_state.dart';
import '../widgets/composer_body_field.dart';
import '../widgets/composer_bottom_bar.dart';
import '../widgets/composer_location_row.dart';
import '../widgets/location_picker_sheet.dart';
import '../widgets/media_strip.dart';
import '../widgets/property_details_section.dart';

const List<(String, String)> _postTypes = [
  ('general', 'General'),
  ('property', 'Property'),
  ('request', 'Request'),
];

const List<(String, String)> _propertyTransactionOptions = [
  ('for_sale', 'For Sale'),
  ('for_rent', 'For Rent'),
  ('for_shortlet', 'For Shortlet'),
];

const List<(String, String)> _requestTransactionOptions = [
  ('looking_to_buy', 'Looking to Buy'),
  ('looking_to_rent', 'Looking to Rent'),
  ('looking_for_shortlet', 'Looking for Shortlet'),
];

class ComposerScreen extends StatefulWidget {
  const ComposerScreen({super.key});

  @override
  State<ComposerScreen> createState() => _ComposerScreenState();
}

class _ComposerScreenState extends State<ComposerScreen> {
  late final ComposerCubit _cubit;
  late final TextEditingController _bodyController;
  late final FocusNode _bodyFocusNode;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final dioClient = DioClient();
    _cubit = ComposerCubit(
      repository: ComposerRepository(dioClient),
      uploadRepository: UploadRepository(dioClient),
    );
    _bodyController = TextEditingController();
    _bodyFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _cubit.close();
    _bodyController.dispose();
    _bodyFocusNode.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? file =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (file == null) return;
    await _cubit.addImage(file.path);
  }

  Future<void> _pickLocation() async {
    final LocationOption? location = await showLocationPickerSheet(context);
    if (location != null) _cubit.setLocation(location);
  }

  Future<bool> _confirmDiscard() async {
    if (!_cubit.state.hasUnsavedContent) return true;
    final bool? discard = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Discard post?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Keep editing'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Discard'),
          ),
        ],
      ),
    );
    return discard ?? false;
  }

  Future<void> _handleClose() async {
    if (await _confirmDiscard() && mounted) {

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;
          await _handleClose();
        },
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: _handleClose,
            ),
            title: Text('New post', style: AppTypography.displayName),
            centerTitle: false,
            actions: [
              BlocBuilder<ComposerCubit, ComposerState>(
                buildWhen: (previous, current) =>
                    previous.isValid != current.isValid ||
                    previous.status != current.status,
                builder: (context, state) {
                  final bool submitting =
                      state.status == ComposerStatus.submitting;
                  return TextButton(
                    onPressed: (state.isValid && !submitting)
                        ? () => _cubit.submit()
                        : null,
                    child: submitting
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Post'),
                  );
                },
              ),
              const SizedBox(width: AppSpacing.s),
            ],
          ),
          body: BlocListener<ComposerCubit, ComposerState>(
            listenWhen: (previous, current) => previous.status != current.status,
            listener: (context, state) {
              if (state.status == ComposerStatus.success) {
                context.read<FeedCubit>().refresh();
                Navigator.of(context).pop();
              } else if (state.status == ComposerStatus.failure &&
                  state.failure != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.failure!.userMessage)),
                );
              }
            },
            child: Column(
              children: [
                const _Divider(),
                Expanded(
                  child: BlocBuilder<ComposerCubit, ComposerState>(
                    builder: (context, state) => ListView(
                      children: [
                        const SizedBox(height: AppSpacing.m),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.screenHorizontal,
                          ),
                          child: Wrap(
                            spacing: AppSpacing.s,
                            children: [
                              for (final (value, label) in _postTypes)
                                ToggleChip(
                                  label: label,
                                  selected: state.postType == value,
                                  onTap: () => _cubit.setPostType(value),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.l),
                        ComposerBodyField(
                          controller: _bodyController,
                          focusNode: _bodyFocusNode,
                          bodyLength: _bodyController.text.length,
                          maxLength: ComposerState.maxBodyLength,
                          onChanged: _cubit.setBody,
                        ),
                        const SizedBox(height: AppSpacing.m),
                        MediaStrip(
                          media: state.media,
                          canAddMore:
                              state.media.length < ComposerState.maxMedia,
                          onAddTap: _pickImage,
                          onRemove: _cubit.removeImage,
                          onRetry: _cubit.retryUpload,
                        ),
                        if (state.postType != 'general') ...[
                          const SizedBox(height: AppSpacing.s),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.screenHorizontal,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FilterSectionHeading(
                                  state.postType == 'property'
                                      ? 'Listing type'
                                      : 'Looking for',
                                ),
                                Wrap(
                                  spacing: AppSpacing.s,
                                  runSpacing: AppSpacing.s,
                                  children: [
                                    for (final (value, label) in state.postType ==
                                            'property'
                                        ? _propertyTransactionOptions
                                        : _requestTransactionOptions)
                                      ToggleChip(
                                        label: label,
                                        selected: state.transactionType == value,
                                        onTap: () =>
                                            _cubit.setTransactionType(value),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                        if (state.location != null)
                          ComposerLocationRow(
                            location: state.location!,
                            onClear: _cubit.clearLocation,
                          ),
                        if (state.postType == 'property')
                          PropertyDetailsSection(
                            priceAmount: state.priceAmount,
                            pricePeriod: state.pricePeriod,
                            bedrooms: state.bedrooms,
                            bathrooms: state.bathrooms,
                            parkingSpaces: state.parkingSpaces,
                            onPriceAmountChanged: _cubit.setPriceAmount,
                            onPricePeriodChanged: _cubit.setPricePeriod,
                            onBedroomsChanged: _cubit.setBedrooms,
                            onBathroomsChanged: _cubit.setBathrooms,
                            onParkingSpacesChanged: _cubit.setParkingSpaces,
                          ),
                        const SizedBox(height: AppSpacing.xxl),
                      ],
                    ),
                  ),
                ),
                const _Divider(),
                ComposerBottomBar(
                  onAddPhoto: _pickImage,
                  onAddLocation: _pickLocation,
                ),
              ],
            ),
          ),
        ),
      ),
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
