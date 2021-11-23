import 'dart:math';
import 'package:flutter/material.dart';
import 'package:smart_lock/globals/config/custom_icons_icons.dart';
import 'package:smart_lock/globals/widgets/gradient_icon.dart';

/// widget for lock
class Lock extends StatelessWidget {
  /// position of lock, 0 is locked, 1 is unlocked
  final double lockPosition;
  final Color otherColor;
  const Lock({
    Key? key,
    required this.lockPosition,
    required this.otherColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: AspectRatio(
        aspectRatio: 0.85,
        child: LayoutBuilder(
          builder: (context, constraints) => Stack(
            children: [
              Align(
                  alignment: Alignment.topCenter,
                  child: Transform.rotate(
                    angle: lockPosition * pi / 9,
                    alignment: Alignment.bottomRight,
                    child: SizedBox(
                      height: constraints.maxHeight * 0.55,
                      width: constraints.maxWidth,
                      child: GradientIcon(
                        CustomIcons.lock_top,
                        size: constraints.maxHeight / 3,
                        gradient: LinearGradient(
                          colors: <Color>[
                            otherColor,
                            Theme.of(context).focusColor,
                          ],
                          stops: [0.5, 1],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  )),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                      height: constraints.maxHeight * 0.55,
                      width: constraints.maxWidth,
                      child: GradientIcon(
                        CustomIcons.lock,
                        size: constraints.maxHeight / 2,
                        gradient: LinearGradient(
                          colors: <Color>[
                            otherColor,
                            Theme.of(context).focusColor,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      )))
            ],
          ),
        ),
      ),
    );
  }
}
