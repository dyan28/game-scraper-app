import 'package:apk_pul/screens/dashboard/dashboard_state.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dashboard_controller.g.dart';

enum DashboardItem {
  online,
  game,
  
}

typedef RefreshListener = Future<void> Function();

@riverpod
class DashController extends _$DashController {
  @override
  DashboardState build() {
    return DashboardState();
  }

  Map<DashboardItem, RefreshListener> listeners = {};

  void notifyRefresh(DashboardItem item) {
    final inProgress = state.inProgress;
    if (inProgress) {
      return;
    }

    state = state.copyWith(inProgress: true);
    listeners[item]?.call().then((_) {
      state = state.copyWith(inProgress: false);
    });

    state = state.copyWith(inProgress: false);
  }

  void addRefreshListener(DashboardItem item, RefreshListener listener) {
    listeners[item] = listener;
  }

  void updateViewAndDashboardIndex({
    required TabController tabController,
    required int indexTab,
  }) {
    // Update Convex index
    tabController.animateTo(indexTab);
    // Update state index tabbar
    state = state.copyWith(
      indexTab: indexTab,
    );
  }
}
