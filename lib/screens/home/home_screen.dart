import 'package:apk_pul/common/core/constants.dart';
import 'package:apk_pul/components/ad_common.dart';
import 'package:apk_pul/components/custom_drawer_menu.dart';
import 'package:apk_pul/components/game_card.dart';
import 'package:apk_pul/components/loading_indicator.dart';
import 'package:apk_pul/components/smart_banner.dart';
import 'package:apk_pul/main/app.dart';
import 'package:apk_pul/models/online_game_res.dart';
import 'package:apk_pul/screens/home/components/game_search_delegate.dart';
import 'package:apk_pul/screens/home/home_controller.dart';
import 'package:apk_pul/screens/home/home_state.dart';
import 'package:apk_pul/utils/app_text_style.dart';
import 'package:apk_pul/utils/force_update_guard.dart';
import 'package:apk_pul/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  late final AdManager _ads;
  // Chặn hiển thị dialog lặp
  bool _forceCheckedOnce = false;

  // Hàm huỷ listener do listenManual trả về
  late ProviderSubscription<HomeState> _sub;
  @override
  void initState() {
    super.initState();
    _forcePortrait();
    _ads = AdManager();
    _ads.preloadInterstitial();
    _sub = ref.listenManual<HomeState>(
      homeControllerProvider,
      (prev, next) async {
        final version = next.serverMinVersion;
        if (!_forceCheckedOnce && (version.isNotEmpty)) {
          _forceCheckedOnce = true;
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            if (!mounted) return;
            await ForceUpdateGuard.ensureUpToDate(
              context,
              serverMinVersion: version,
              androidPackage: 'com.gnof.apkpul',
              iosAppId: '1234567890',
              note:
                  'We released an important update to improve performance and security.',
            );
          });
        }
      },
    );
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final s = ref.read(homeControllerProvider);
      final version = s.serverMinVersion;
      if (!_forceCheckedOnce && (version.isNotEmpty)) {
        _forceCheckedOnce = true;
        await ForceUpdateGuard.ensureUpToDate(
          context,
          serverMinVersion: version,
          androidPackage: 'com.gnof.apkpul',
          iosAppId: '1234567890',
          note:
              'We released an important update to improve performance and security.',
        );
      }
    });
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
    _sub.close();
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeControllerProvider);
    final notifier = ref.read(homeControllerProvider.notifier);

    final games = state.gamesOnline;
    const crossAxisCount = 2;

    final firstRowCount = state.gamesOnline.length >= crossAxisCount
        ? crossAxisCount
        : state.gamesOnline.length;
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
          : CustomScrollView(
              slivers: [
                if (showAdsBanner.value)
                  const SliverToBoxAdapter(
                    child: SmartBanner(),
                  ),
                // ===== GRID: HÀNG 1 =====
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.86,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => GameCard(game: games[index]),
                      childCount: 6, // chỉ 4 item đầu
                    ),
                  ),
                ),

                // ===== HÀNG 2: QUẢNG CÁO FULL-WIDTH =====
                if (showAdsBanner.value)
                  const SliverToBoxAdapter(
                    child: SmartBanner(),
                  ),

                // ===== GRID: CÁC HÀNG SAU =====
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.86,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, idx) {
                        final game = games[firstRowCount + idx];
                        return GameCard(game: game);
                      },
                      childCount:
                          (games.length - firstRowCount).clamp(0, games.length),
                    ),
                  ),
                ),
              ],
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

List<Object> withAdAtRow({
  required List<OnlineGameRes> games,
  int crossAxisCount = 2,
  int rowIndex = 1, // 0-based: hàng thứ 2
  int colIndex = 0, // 0 = cột trái, 1 = cột phải
}) {
  final items = List<Object>.from(games);
  final adPos = (rowIndex * crossAxisCount) + colIndex; // vị trí hiển thị
  final insertAt = adPos.clamp(0, items.length);
  items.insert(insertAt, const _AdMarker());
  return items;
}
