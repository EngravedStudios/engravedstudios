import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'navbar_controller.g.dart';

@riverpod
class NavbarController extends _$NavbarController {
  @override
  bool build() {
    return true; // Visible by default
  }

  void show() {
    if (!state) state = true;
  }

  void hide() {
    if (state) state = false;
  }
}
