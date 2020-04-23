import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:tetrisymono/gamer/main_player.dart';

class GameController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Row(
        children: <Widget>[
          Expanded(child: LeftController()),
          Expanded(child: DirectionController()),
        ],
      ),
    );
  }
}

const Size _DIRECTION_BUTTON_SIZE = const Size(48, 48);

const Size _SYSTEM_BUTTON_SIZE = const Size(28, 28);

const double _DIRECTION_SPACE = 16;

class DirectionController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        SizedBox.fromSize(size: _DIRECTION_BUTTON_SIZE * 3),
        Transform.rotate(
          angle: math.pi / 4,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: _DIRECTION_SPACE),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _Button(
                      enableLongPress: false,
                      size: _DIRECTION_BUTTON_SIZE,
                      onTap: () {
                        Game.of(context).rotate();
                      }),
                  SizedBox(width: _DIRECTION_SPACE),
                  _Button(
                      size: _DIRECTION_BUTTON_SIZE,
                      onTap: () {
                        Game.of(context).right();
                      }),
                ],
              ),
              SizedBox(height: _DIRECTION_SPACE),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _Button(
                      size: _DIRECTION_BUTTON_SIZE,
                      onTap: () {
                        Game.of(context).left();
                      }),
                  SizedBox(width: _DIRECTION_SPACE),
                  _Button(
                    size: _DIRECTION_BUTTON_SIZE,
                    onTap: () {
                      Game.of(context).down();
                    },
                  ),
                ],
              ),
              SizedBox(height: _DIRECTION_SPACE),
            ],
          ),
        ),
      ],
    );
  }
}

class SystemButtonGroup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Column(
          children: <Widget>[
            _Button(
              size: _SYSTEM_BUTTON_SIZE,
              color: Colors.greenAccent,
              enableLongPress: false,
              onTap: () {
                Game.of(context).soundSwitch();
              },
            ),
            Text(
              'Volume',
              style: TextStyle(
                fontFamily: 'Bangers',
                fontSize: 11,
              ),
            ),
          ],
        ),
        Column(
          children: <Widget>[
            _Button(
                size: _SYSTEM_BUTTON_SIZE,
                color: Colors.greenAccent,
                enableLongPress: false,
                onTap: () {
                  Game.of(context).pauseOrResume();
                }),
            Text('Pause',
                style: TextStyle(
                  fontFamily: 'Bangers',
                  fontSize: 11,
                )),
          ],
        ),
        Column(
          children: <Widget>[
            _Button(
                size: _SYSTEM_BUTTON_SIZE,
                enableLongPress: false,
                color: Colors.greenAccent,
                onTap: () {
                  Game.of(context).reset();
                }),
            Text('Set/Reset',
                style: TextStyle(
                  fontFamily: 'Bangers',
                  fontSize: 11,
                )),
          ],
        )
      ],
    );
  }
}

class DropButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _Button(
            enableLongPress: false,
            size: Size(100, 100),
            onTap: () {
              Game.of(context).drop();
            }),
        Text(
          'Push',
          style: TextStyle(
            fontSize: 11,
            fontFamily: 'Bangers',
          ),
        ),
      ],
    );
  }
}

class LeftController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SystemButtonGroup(),
        Expanded(
          child: Center(
            child: DropButton(),
          ),
        )
      ],
    );
  }
}

class _Button extends StatefulWidget {
  final Size size;
  final Widget icon;

  final VoidCallback onTap;

  ///the color of button
  final Color color;

  final bool enableLongPress;

  const _Button(
      {Key key,
      @required this.size,
      @required this.onTap,
      this.icon,
      this.color = Colors.greenAccent,
      this.enableLongPress = true})
      : super(key: key);

  @override
  _ButtonState createState() {
    return new _ButtonState();
  }
}

///show a hint text for child widget
class _Description extends StatelessWidget {
  final String text;

  final Widget child;

  final AxisDirection direction;

  const _Description({
    Key key,
    this.text,
    this.direction = AxisDirection.down,
    this.child,
  })  : assert(direction != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget widget;
    switch (direction) {
      case AxisDirection.right:
        widget = Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[child, SizedBox(width: 8), Text(text)]);
        break;
      case AxisDirection.left:
        widget = Row(
          children: <Widget>[Text(text), SizedBox(width: 8), child],
          mainAxisSize: MainAxisSize.min,
        );
        break;
      case AxisDirection.up:
        widget = Column(
          children: <Widget>[Text(text), SizedBox(height: 8), child],
          mainAxisSize: MainAxisSize.min,
        );
        break;
      case AxisDirection.down:
        widget = Column(
          children: <Widget>[child, SizedBox(height: 8), Text(text)],
          mainAxisSize: MainAxisSize.min,
        );
        break;
    }
    return DefaultTextStyle(
      child: widget,
      style: TextStyle(fontSize: 9, color: Colors.green),
    );
  }
}

class _ButtonState extends State<_Button> {
  Timer _timer;

  bool _tapEnded = false;

  Color _color;

  @override
  void didUpdateWidget(_Button oldWidget) {
    super.didUpdateWidget(oldWidget);
    _color = widget.color;
  }

  @override
  void initState() {
    super.initState();
    _color = widget.color;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _color,
      elevation: 4,
      shape: CircleBorder(),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) async {
          setState(() {
            _color = widget.color.withOpacity(0.5);
          });
          if (_timer != null) {
            return;
          }
          _tapEnded = false;
          widget.onTap();
          if (!widget.enableLongPress) {
            return;
          }
          await Future.delayed(const Duration(milliseconds: 300));
          if (_tapEnded) {
            return;
          }
          _timer = Timer.periodic(const Duration(milliseconds: 60), (t) {
            if (!_tapEnded) {
              widget.onTap();
            } else {
              t.cancel();
              _timer = null;
            }
          });
        },
        onTapCancel: () {
          _tapEnded = true;
          _timer?.cancel();
          _timer = null;
          setState(() {
            _color = widget.color;
          });
        },
        onTapUp: (_) {
          _tapEnded = true;
          _timer?.cancel();
          _timer = null;
          setState(() {
            _color = widget.color;
          });
        },
        child: SizedBox.fromSize(
          size: widget.size,
        ),
      ),
    );
  }
}
