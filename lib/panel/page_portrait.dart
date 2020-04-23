import 'package:flutter/material.dart';
import 'package:tetrisymono/main.dart';
import 'package:tetrisymono/panel/controller.dart';
import 'package:tetrisymono/panel/screen.dart';

part 'page_land.dart';

class PagePortrait extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size * 1.2;
    final screenW = size.width * 0.8;
    return SizedBox.expand(
      child: Container(
        color: Colors.green,
        child: Column(
          children: <Widget>[
            Spacer(),
            _ScreenDecoration(child: Screen(width: screenW)),
            Spacer(flex: 2),
            GameController(),
          ],
        ),
      ),
    );
  }
}

class _ScreenDecoration extends StatelessWidget {
  final Widget child;

  const _ScreenDecoration({Key key, @required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
              color: const Color(0xFF4CAF50), width: SCREEN_BORDER_WIDTH),
          left: BorderSide(
              color: const Color(0xFF4CAF50), width: SCREEN_BORDER_WIDTH),
          right: BorderSide(
              color: const Color(0xFF4CAF50), width: SCREEN_BORDER_WIDTH),
          bottom: BorderSide(
              color: const Color(0xFF4CAF50), width: SCREEN_BORDER_WIDTH),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.green)),
        child: Container(
          padding: const EdgeInsets.all(3),
          color: Colors.green,
          child: child,
        ),
      ),
    );
  }
}
