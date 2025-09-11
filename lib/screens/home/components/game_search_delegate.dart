import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tap_two_play/components/game_card.dart';
import 'package:tap_two_play/models/online_game_res.dart';

class GameSearchDelegate extends SearchDelegate<OnlineGameRes?> {
  GameSearchDelegate({
    required this.all,
    this.onSelected,
  });

  final List<OnlineGameRes> all;
  final void Function(OnlineGameRes game)? onSelected;

  @override
  List<Widget>? buildActions(BuildContext context) => [
        if (query.isNotEmpty)
          IconButton(
              icon: const Icon(Icons.clear), onPressed: () => query = ''),
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null));

  @override
  Widget buildSuggestions(BuildContext context) =>
      _gridResults(_filter(all, query), context);

  @override
  Widget buildResults(BuildContext context) =>
      _gridResults(_filter(all, query), context);

  List<OnlineGameRes> _filter(List<OnlineGameRes> src, String q) {
    final qn = q.trim().toLowerCase();
    if (qn.isEmpty) return src;
    return src
        .where((g) => (g.title ?? '').toLowerCase().contains(qn))
        .toList();
  }

  Widget _gridResults(List<OnlineGameRes> items, BuildContext context) {
    if (items.isEmpty) {
      return const Center(child: Text('No results'));
    }
    final width = MediaQuery.of(context).size.width;

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.86, // chỉnh tỉ lệ card
      ),
      itemBuilder: (_, i) => GameCard(game: items[i]),
    );
  }
}

class _GridResults extends StatelessWidget {
  const _GridResults({required this.items, required this.onTap});
  final List<OnlineGameRes> items;
  final void Function(OnlineGameRes) onTap;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.86, // chỉnh tỉ lệ card
      ),
      itemBuilder: (_, i) => GestureDetector(
        onTap: () => onTap(items[i]),
        child: GameCard(game: items[i]),
      ),
    );
  }
}
