import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectedLocalNotifier extends StateNotifier<Locale> {
  SelectedLocalNotifier() : super(const Locale('en'));

  void changeLocale(Locale newLocale) {
    state = newLocale;
  }
}

final languageProvider =
    StateNotifierProvider<SelectedLocalNotifier, Locale>((ref) {
  return SelectedLocalNotifier();
});
