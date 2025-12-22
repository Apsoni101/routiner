import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routiner/core/constants/app_colors.dart';
import 'package:routiner/core/constants/app_textstyles.dart';
import 'package:routiner/core/extensions/color_extension.dart';
import 'package:routiner/core/extensions/localization_extension.dart';
import 'package:routiner/feature/home/presentation/bloc/club_icon_picker_bloc/club_icon_picker_bloc.dart';

class ClubIconPickerDialog extends StatelessWidget {
  const ClubIconPickerDialog({
    super.key,
    this.selectedIcon,
    this.selectedImageUrl,
  });

  final IconData? selectedIcon;
  final String? selectedImageUrl;

  static final List<IconData> _clubIcons = <IconData>[
    Icons.group,
    Icons.people,
    Icons.groups,
    Icons.sports,
    Icons.fitness_center,
    Icons.book,
    Icons.school,
    Icons.work,
    Icons.business,
    Icons.code,
    Icons.computer,
    Icons.music_note,
    Icons.palette,
    Icons.camera_alt,
    Icons.restaurant,
    Icons.local_cafe,
    Icons.sports_soccer,
    Icons.sports_basketball,
    Icons.sports_tennis,
    Icons.sports_esports,
    Icons.videogame_asset,
    Icons.movie,
    Icons.theater_comedy,
    Icons.healing,
    Icons.favorite,
    Icons.psychology,
    Icons.self_improvement,
    Icons.hiking,
    Icons.kayaking,
    Icons.sailing,
    Icons.surfing,
    Icons.snowboarding,
    Icons.kitesurfing,
    Icons.paragliding,
    Icons.directions_bike,
    Icons.directions_run,
    Icons.pool,
    Icons.beach_access,
    Icons.forest,
    Icons.park,
    Icons.pets,
    Icons.emoji_nature,
    Icons.eco,
    Icons.science,
    Icons.biotech,
    Icons.engineering,
    Icons.calculate,
    Icons.architecture,
    Icons.design_services,
    Icons.brush,
    Icons.draw,
    Icons.piano,
    Icons.mic,
    Icons.headphones,
    Icons.radio,
    Icons.podcasts,
    Icons.library_books,
    Icons.menu_book,
    Icons.auto_stories,
    Icons.local_library,
    Icons.shopping_bag,
    Icons.volunteer_activism,
    Icons.handshake,
    Icons.diversity_3,
    Icons.public,
    Icons.language,
    Icons.travel_explore,
    Icons.flight,
    Icons.directions_car,
    Icons.motorcycle,
  ];

  @override
  Widget build(final BuildContext context) {
    return BlocProvider<ClubIconPickerBloc>(
      create: (_) => ClubIconPickerBloc(
        selectedIcon: selectedIcon,
        selectedImageUrl: selectedImageUrl,
      ),
      child: const _ClubIconPickerDialogContent(),
    );
  }
}

class _ClubIconPickerDialogContent extends StatelessWidget {
  const _ClubIconPickerDialogContent();

  void _confirm(final BuildContext context, final ClubIconPickerState state) {
    if (state.selectedImageUrl != null && state.selectedImageUrl!.isNotEmpty) {
      context.router.pop(<String, String?>{'imageUrl': state.selectedImageUrl});
    } else if (state.selectedIcon != null) {
      context.router.pop(<String, IconData?>{'icon': state.selectedIcon});
    }
  }

  @override
  Widget build(final BuildContext context) {
    return BlocBuilder<ClubIconPickerBloc, ClubIconPickerState>(
      builder: (final BuildContext context, final ClubIconPickerState state) {
        return DefaultTabController(
          length: 2,
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              padding: const EdgeInsets.all(16),
              constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
              child: Column(
                children: <Widget>[
                  Text(
                    context.locale.selectIconTitle,
                    style: AppTextStyles.airbnbCerealW500S18Lh24Ls0,
                  ),
                  const SizedBox(height: 8),
                  TabBar(
                    indicatorColor: context.appColors.c3843FF,
                    labelColor: context.appColors.c3843FF,
                    unselectedLabelColor: context.appColors.c686873,
                    tabs: <Tab>[
                      Tab(text: context.locale.tabIcons),
                      const Tab(text: 'Image URL'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: TabBarView(
                      children: <Widget>[
                        _MaterialIconsTab(selectedIcon: state.selectedIcon),
                        _ImageUrlTab(imageUrl: state.selectedImageUrl ?? ''),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: state.canConfirm
                          ? () => _confirm(context, state)
                          : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(context.locale.selectButton),
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

class _MaterialIconsTab extends StatelessWidget {
  const _MaterialIconsTab({required this.selectedIcon});

  final IconData? selectedIcon;

  @override
  Widget build(final BuildContext context) {
    final AppThemeColors colors = context.appColors;

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: ClubIconPickerDialog._clubIcons.length,
      itemBuilder: (final BuildContext context, final int index) {
        final IconData icon = ClubIconPickerDialog._clubIcons[index];
        final bool isSelected = selectedIcon == icon;

        return IconButton(
          onPressed: () {
            context.read<ClubIconPickerBloc>().add(IconSelected(icon));
          },
          icon: Icon(icon),
          style: IconButton.styleFrom(
            fixedSize: const Size(48, 48),
            backgroundColor: isSelected ? colors.cF6F9FF : colors.cF3F4F6,
            foregroundColor: isSelected ? colors.c3843FF : colors.c686873,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: isSelected ? colors.c3843FF : Colors.transparent,
                width: 2,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ImageUrlTab extends StatefulWidget {
  const _ImageUrlTab({required this.imageUrl});

  final String imageUrl;

  @override
  State<_ImageUrlTab> createState() => _ImageUrlTabState();
}

class _ImageUrlTabState extends State<_ImageUrlTab> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.imageUrl);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            labelText: 'Image URL',
            hintText: 'https://example.com/image.png',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            prefixIcon: const Icon(Icons.link),
          ),
          onChanged: (final String value) {
            context.read<ClubIconPickerBloc>().add(ImageUrlChanged(value));
          },
        ),
        const SizedBox(height: 16),
        Expanded(
          child: BlocBuilder<ClubIconPickerBloc, ClubIconPickerState>(
            builder: (context, state) {
              if (state.selectedImageUrl == null ||
                  state.selectedImageUrl!.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.image_outlined,
                        size: 64,
                        color: context.appColors.c686873.withOpacity(0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Enter an image URL above',
                        style: AppTextStyles.airbnbCerealW400S14Lh20Ls0
                            .copyWith(color: context.appColors.c686873),
                      ),
                    ],
                  ),
                );
              }

              return Container(
                decoration: BoxDecoration(
                  border: Border.all(color: context.appColors.c3843FF, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    state.selectedImageUrl!,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.broken_image,
                              size: 64,
                              color: context.appColors.c686873.withOpacity(0.5),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Failed to load image',
                              style: AppTextStyles.airbnbCerealW400S14Lh20Ls0
                                  .copyWith(color: context.appColors.c686873),
                            ),
                          ],
                        ),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}