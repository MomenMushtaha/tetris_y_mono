import 'package:flutter/material.dart';
import 'package:tetrisymono/gamer/main_player.dart';
import 'package:tetrisymono/material/briks.dart';
import 'package:tetrisymono/material/images.dart';

const _PLAYER_PANEL_PADDING = 6;

Size getBrikSizeForScreenWidth(double width) {
  return Size.square((width - _PLAYER_PANEL_PADDING) / GAME_PAD_WIDTH);
}

///the matrix of player content
class PlayerPanel extends StatelessWidget {
  //the size of player panel
  final Size size;

  PlayerPanel({Key key, @required double width})
      : assert(width != null && width != 0),
        size = Size(width, width * 2),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint("size : $size");
    return SizedBox.fromSize(
      size: size,
      child: Container(
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.green),
        ),
        child: Stack(
          children: <Widget>[
            _PlayerPad(),
            _GameUninitialized(),
          ],
        ),
      ),
    );
  }
}

class _PlayerPad extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: GameState.of(context).data.map((list) {
        return Row(
          children: list.map((b) {
            return b == 1
                ? const Brik.normal()
                : b == 2 ? const Brik.highlight() : const Brik.empty();
          }).toList(),
        );
      }).toList(),
    );
  }
}

class _GameUninitialized extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (GameState.of(context).states == GameStates.none) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconDragon(
              animate: true,
            ),
            SizedBox(height: 16),
            Text('Tetris',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Bangers',
                )),
            Text(
              "By MONO Labratories",
              style: TextStyle(fontSize: 9, fontFamily: 'Bangers'),
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}
