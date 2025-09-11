import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tap_two_play/screens/home/home_controller.dart';
import 'package:tap_two_play/utils/app_text_style.dart';
import 'package:tap_two_play/utils/utils.dart';

const sizeOfSquare = 220.0;

//com.qustodio.family.parental.control.app.screentime
//app.kids360.parent
class HomeScreen extends ConsumerWidget with Utils {
  const HomeScreen({super.key});
//Color(0xfffdefee),
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeControllerProvider);
    final notifier = ref.read(homeControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('Online', style: AppTextStyles.defaultBoldAppBar),
        surfaceTintColor: Colors.transparent,
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16),
      ),
      body: state.isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.red,
              ),
            )
          : ListView.builder( 
        shrinkWrap: true,
        itemCount: state.gamesOnline.length,
        itemBuilder: (context, index) {
          final game = state.gamesOnline[index];
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                
                Text(game.title ?? ''),
              ],
            ),
          );
        },
      ),
    );
  }
}
