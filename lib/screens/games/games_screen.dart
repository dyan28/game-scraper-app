import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tap_two_play/screens/games/components/store_game_tile.dart';
import 'package:tap_two_play/screens/games/game_controller.dart';
import 'package:tap_two_play/utils/app_colors.dart';

class GamesScreen extends ConsumerStatefulWidget {
  const GamesScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GamesScreenState();
}

class _GamesScreenState extends ConsumerState<GamesScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(gameControllerProvider);
    final notifier = ref.read(gameControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: _SearchField(
          controller: TextEditingController(),
          focusNode: FocusNode(),
          onClear: () {},
        ), // giữ tiêu đề
        surfaceTintColor: Colors.transparent,
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemCount: state.games.length,
              itemBuilder: (context, index) {
                return StoreGameTile(
                  title: state.games[index].title ?? '',
                  iconUrl: state.games[index].icon ?? '',
                  bannerUrl: state.games[index].screenshots?.first ?? '',
                  rating: state.games[index].scoreText,
                );
              },
            ),
      // body: Center(child: Text('Games Screen')
      //
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.focusNode,
    required this.onClear,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      textInputAction: TextInputAction.search,
      onFieldSubmitted: (_) => focusNode.unfocus(),
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: 'Search games',
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
        prefixIcon: const Icon(Icons.search, color: Colors.white),
        suffixIcon: ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (_, v, __) => v.text.isEmpty
              ? const SizedBox.shrink()
              : IconButton(
                  icon: const Icon(Icons.clear, color: Colors.white),
                  onPressed: onClear,
                ),
        ),
        isDense: true,
        filled: true,
        fillColor: Colors.white.withOpacity(0.12),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.15)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.15)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.colorScheme.onPrimary),
        ),
      ),
    );
  }
}
