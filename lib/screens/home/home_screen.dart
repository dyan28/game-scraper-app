import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tap_two_play/components/custom_drawer_menu.dart';
import 'package:tap_two_play/components/game_card.dart';
import 'package:tap_two_play/components/loading_indicator.dart';
import 'package:tap_two_play/main/app.dart';
import 'package:tap_two_play/models/online_game_res.dart';
import 'package:tap_two_play/screens/home/components/game_search_delegate.dart';
import 'package:tap_two_play/screens/home/home_controller.dart';
import 'package:tap_two_play/utils/app_text_style.dart';
import 'package:tap_two_play/utils/utils.dart';

const sizeOfSquare = 220.0;

//com.qustodio.family.parental.control.app.screentime
//app.kids360.parent
class HomeScreen extends ConsumerStatefulWidget with Utils {
  const HomeScreen({super.key});
//Color(0xfffdefee),
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with RouteAware {
  @override
  void initState() {
    super.initState();
    _forcePortrait();
  }

  void _forcePortrait() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // đăng ký theo dõi route để biết khi pop về
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeControllerProvider);
    final notifier = ref.read(homeControllerProvider.notifier);

    return Scaffold(
      drawer: const CustomDrawerMenu(),
      appBar: AppBar(
        centerTitle: false,
        title: Text('Online Game', style: AppTextStyles.defaultBoldAppBar),
        surfaceTintColor: Colors.transparent,
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              final games = ref.read(homeControllerProvider).gamesOnline;
              // mở search
              final selected = await showSearch<OnlineGameRes?>(
                context: context,
                delegate: GameSearchDelegate(
                  all: games,
                  // nếu chọn 1 game trong results/suggestions:
                  onSelected: (g) {
                    // TODO: mở WebView chơi game hoặc trang chi tiết
                    // Navigator.push(...);
                  },
                ),
              );
              if (selected != null) {
                // nếu muốn xử lý sau khi đóng search
                // ...
              }
            },
          ),
        ],
      ),
      body: state.isLoading
          ? const Center(
              child: LoadingIndicator(),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.gamesOnline.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.86,
              ),
              itemBuilder: (context, index) {
                final item = state.gamesOnline[index];
                if (item is _AdMarker) {
                  return const AdGridTile();
                } else {
                  return GameCard(game: item);
                }
              },
            ),
    );
  }

  List<Object> _mixWithAds(List<OnlineGameRes> items, int every) {
    if (items.isEmpty || every <= 0) return List<Object>.from(items);
    final out = <Object>[];
    for (var i = 0; i < items.length; i++) {
      // chèn ad TRƯỚC item i (trừ i=0) mỗi khi đủ 'every'
      if (i > 0 && i % every == 0) out.add(const _AdMarker());
      out.add(items[i]);
    }
    return out;
  }
}

class _AdMarker {
  const _AdMarker();
}

class AdGridTile extends StatelessWidget {
  const AdGridTile({super.key});

  @override
  Widget build(BuildContext context) {
    // Placeholder UI — thay bằng widget quảng cáo thực tế sau
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0F1A2B),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white10),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white12,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.campaign_rounded, color: Colors.white70),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Quảng cáo',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
