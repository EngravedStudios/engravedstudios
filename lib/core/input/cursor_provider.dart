import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cursor_provider.g.dart';

enum CursorType { default_, hover, click }

@riverpod
class CursorState extends _$CursorState {
  @override
  CursorType build() => CursorType.default_;

  void setHover() => state = CursorType.hover;
  void setDefault() => state = CursorType.default_;
  void setClick() => state = CursorType.click;
}
