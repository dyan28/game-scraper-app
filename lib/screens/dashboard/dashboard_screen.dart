import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tap_two_play/generated/assets.gen.dart';
import 'package:tap_two_play/screens/dashboard/dashboard_controller.dart';
import 'package:tap_two_play/screens/games/game_discovery_page.dart';
import 'package:tap_two_play/screens/home/home_screen.dart';
import 'package:tap_two_play/utils/app_colors.dart';
import 'package:tap_two_play/utils/app_text_style.dart';
import 'package:tap_two_play/utils/utils.dart';

class DashBoardArg {
  final int? index;

  DashBoardArg({this.index});
}

class DashBoardScreen extends ConsumerStatefulWidget {
  final int? index;
  const DashBoardScreen({super.key, this.index});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DashBoardScreenState();
}

class _DashBoardScreenState extends ConsumerState<DashBoardScreen>
    with TickerProviderStateMixin, Utils, WidgetsBindingObserver {
  static const List<DashboardItem> tabTypes = [
    DashboardItem.online,
    DashboardItem.game,
  ];
  late TabController _tabController;

  // 3 Pages in dashboard
  static const pages = [
    HomeScreen(),
    GameDiscoveryPage(),
  ];

  final List<GlobalKey<NavigatorState>> _tabNavKeyList =
      List.generate(tabTypes.length, (index) => index)
          .map((_) => GlobalKey<NavigatorState>())
          .toList();

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: 2, vsync: this, initialIndex: widget.index ?? 0);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dashControllerProvider);
    final controller = ref.read(dashControllerProvider.notifier);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (value, _) {},
      child: Scaffold(
        body: CupertinoTabView(
          navigatorKey: _tabNavKeyList[_tabController.index],
          builder: (context) {
            return pages[_tabController.index];
          },
        ),
        bottomNavigationBar: SizedBox(
          height: 74,
          child: BottomNavigationBar(
            currentIndex: _tabController.index,
            showSelectedLabels: true,
            backgroundColor: AppColors.primary,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.white,
            selectedLabelStyle:
                AppTextStyles.textW500S16.copyWith(fontSize: 14),
            unselectedLabelStyle:
                AppTextStyles.textW500S16.copyWith(fontSize: 14),
            unselectedItemColor: AppColors.black393939,
            items: [
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  Assets.svg.icMobilePlay.path,
                  height: 16,
                  width: 16,
                  colorFilter: ColorFilter.mode(
                      _tabController.index == 0
                          ? Colors.white
                          : AppColors.black393939,
                      BlendMode.srcIn),
                ),
                label: 'Play',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  height: 16,
                  width: 16,
                  Assets.svg.icApp.path,
                  colorFilter: ColorFilter.mode(
                    _tabController.index == 1
                        ? Colors.white
                        : AppColors.black393939,
                    BlendMode.srcIn,
                  ),
                ),
                label: 'Games',
              ),
            ],
            onTap: _onTapItem,
          ),
        ),
      ),
    );
  }

  // Function to handle thresh when tab to item in dashboard
  Future<void> _onTapItem(int index) async {
    final stateNotifier = ref.read(dashControllerProvider.notifier);
    final state = ref.watch(dashControllerProvider);
    final currentIndex = ref.watch(dashControllerProvider).indexTab;

    // Check can pop when navigate tabview
    final currentState = _tabNavKeyList[currentIndex].currentState;
    final canPop = currentState?.canPop() ?? false;
    if (currentState != null && canPop) {
      currentState.popUntil((route) => route.isFirst);
    }

    // If index != currentIndex, will be update index for tabview
    if (index != currentIndex) {
      stateNotifier.updateViewAndDashboardIndex(
        tabController: _tabController,
        indexTab: index,
      );
    } else {
      stateNotifier.notifyRefresh(tabTypes[index]);
    }
  }
}
