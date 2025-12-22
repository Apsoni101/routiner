import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routiner/core/constants/app_textstyles.dart';
import 'package:routiner/core/di/app_injector.dart';
import 'package:routiner/core/extensions/color_extension.dart';
import 'package:routiner/core/extensions/localization_extension.dart';
import 'package:routiner/feature/auth/presentation/widgets/form_text_field.dart';
import 'package:routiner/feature/common/presentation/widgets/wave_bottom_sheet.dart';
import 'package:routiner/feature/home/presentation/bloc/create_club_bloc/create_club_bloc.dart';
import 'package:routiner/feature/home/presentation/widgets/club_icon_picker_dialog.dart';

class CreateClubBottomSheet extends StatelessWidget {
  const CreateClubBottomSheet({super.key});

  @override
  Widget build(final BuildContext context) {
    return BlocProvider<CreateClubBloc>(
      create: (_) => AppInjector.getIt<CreateClubBloc>(),
      child: const _CreateClubContent(),
    );
  }
}

class _CreateClubContent extends StatefulWidget {
  const _CreateClubContent();

  @override
  State<_CreateClubContent> createState() => _CreateClubContentState();
}

class _CreateClubContentState extends State<_CreateClubContent> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _showIconPicker(final BuildContext context) async {
    final CreateClubBloc bloc = context.read<CreateClubBloc>();
    final CreateClubState currentState = bloc.state;

    final Map<String, dynamic>? result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (final BuildContext dialogContext) => ClubIconPickerDialog(
        selectedIcon: currentState.selectedIcon,
        selectedImageUrl: currentState.imageUrl,
      ),
    );

    if (result != null && context.mounted) {
      if (result.containsKey('icon')) {
        bloc.add(IconSelected(result['icon']));
      } else if (result.containsKey('imageUrl')) {
        bloc.add(ImageUrlChanged(result['imageUrl']));
      }
    }
  }

  @override
  Widget build(final BuildContext context) {
    return BlocListener<CreateClubBloc, CreateClubState>(
      listener: (final BuildContext context, final CreateClubState state) {
        if (state.status == CreateClubStatus.success) {
          Navigator.pop(context, state.createdClub);
        } else if (state.status == CreateClubStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Failed to create club'),
            ),
          );
        }
      },
      child: CommonWaveBottomSheet(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            const SizedBox(height: 26),
            Text(
              context.locale.createClub.toUpperCase(),
              style: AppTextStyles.airbnbCerealW700S10Lh16Ls1Uppercase.copyWith(
                color: context.appColors.c040415,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 24),

            /// Club Name
            BlocBuilder<CreateClubBloc, CreateClubState>(
              buildWhen: (final CreateClubState p, final CreateClubState c) =>
                  p.nameError != c.nameError,
              builder:
                  (final BuildContext context, final CreateClubState state) {
                    return FormTextField(
                      controller: _nameController,
                      hintText: 'Club Name',
                      hintStyle: AppTextStyles.airbnbCerealW400S14Lh20Ls0
                          .copyWith(color: context.appColors.cCDCDD0),
                      errorText: state.nameError,
                      onChanged: (final String value) {
                        context.read<CreateClubBloc>().add(NameChanged(value));
                      },
                    );
                  },
            ),
            const SizedBox(height: 20),

            /// Description
            BlocBuilder<CreateClubBloc, CreateClubState>(
              buildWhen: (final CreateClubState p, final CreateClubState c) =>
                  p.descriptionError != c.descriptionError,
              builder:
                  (final BuildContext context, final CreateClubState state) {
                    return FormTextField(
                      controller: _descriptionController,
                      hintText: 'Description',
                      maxLines: 4,
                      hintStyle: AppTextStyles.airbnbCerealW400S14Lh20Ls0
                          .copyWith(color: context.appColors.cCDCDD0),
                      errorText: state.descriptionError,
                      onChanged: (final String value) {
                        context.read<CreateClubBloc>().add(
                          DescriptionChanged(value),
                        );
                      },
                    );
                  },
            ),
            const SizedBox(height: 20),

            /// Icon/Image Picker
            BlocBuilder<CreateClubBloc, CreateClubState>(
              buildWhen: (final CreateClubState p, final CreateClubState c) =>
                  p.selectedIcon != c.selectedIcon || p.imageUrl != c.imageUrl,
              builder:
                  (final BuildContext context, final CreateClubState state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'ICON',
                          style: AppTextStyles
                              .airbnbCerealW700S10Lh16Ls1Uppercase
                              .copyWith(
                                color: context.appColors.c9B9BA1,
                                fontSize: 12,
                              ),
                        ),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: () => _showIconPicker(context),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            height: 80,
                            decoration: BoxDecoration(
                              color: context.appColors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: state.hasIcon
                                    ? context.appColors.c3843FF
                                    : context.appColors.cCDCDD0,
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: 80,
                                  decoration: BoxDecoration(
                                    color: context.appColors.cF6F9FF,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      bottomLeft: Radius.circular(12),
                                    ),
                                  ),
                                  child: Center(
                                    child: _buildIconPreview(state, context),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    child: Text(
                                      state.hasIcon
                                          ? (state.selectedIcon != null
                                                ? 'Material Icon Selected'
                                                : 'Image URL Selected')
                                          : 'Tap to select icon or image',
                                      style: AppTextStyles
                                          .airbnbCerealW400S14Lh20Ls0
                                          .copyWith(
                                            color: state.hasIcon
                                                ? context.appColors.c3843FF
                                                : context.appColors.cCDCDD0,
                                          ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 16),
                                  child: Icon(
                                    Icons.edit,
                                    color: context.appColors.c686873,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
            ),
            const SizedBox(height: 28),

            /// Submit Button
            BlocBuilder<CreateClubBloc, CreateClubState>(
              builder:
                  (final BuildContext context, final CreateClubState state) {
                    final bool isLoading =
                        state.status == CreateClubStatus.loading;

                    return ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              context.read<CreateClubBloc>().add(
                                const FormSubmitted(),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.appColors.c3843FF,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              'Create Club',
                              style: AppTextStyles.airbnbCerealW500S14Lh20Ls0
                                  .copyWith(color: context.appColors.white),
                            ),
                    );
                  },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconPreview(
    final CreateClubState state,
    final BuildContext context,
  ) {
    if (state.selectedIcon != null) {
      return Icon(
        state.selectedIcon,
        size: 40,
        color: context.appColors.c3843FF,
      );
    } else if (state.imageUrl != null && state.imageUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          state.imageUrl!,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          errorBuilder:
              (
                final BuildContext context,
                final Object error,
                final StackTrace? stackTrace,
              ) {
                return Icon(
                  Icons.broken_image,
                  size: 40,
                  color: context.appColors.c686873,
                );
              },
          loadingBuilder:
              (
                final BuildContext context,
                final Widget child,
                final ImageChunkEvent? loadingProgress,
              ) {
                if (loadingProgress == null) {
                  return child;
                }
                return SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
        ),
      );
    } else {
      return Icon(
        Icons.add_photo_alternate,
        size: 40,
        color: context.appColors.cCDCDD0,
      );
    }
  }
}
