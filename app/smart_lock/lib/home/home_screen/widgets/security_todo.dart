import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_lock/globals/config/theme_data.dart';
import 'package:smart_lock/globals/controllers/size_handler.dart';
import 'package:smart_lock/home/home_screen/home_screen_handler.dart';

/// widget for showing the security todo
class SecurityTodo extends StatelessWidget {
  const SecurityTodo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeScreenHandler handler = Get.find<HomeScreenHandler>();
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(right: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Security todo',
              style: sizeHandler.currentTextTheme.headline2,
            ),
            const SizedBox(height: 25),
            Obx(
              () => _Entry(
                  content: handler.todo1.value, showTick: handler.todo1bool),
            ),
            const SizedBox(height: 15),
            _Entry(content: handler.todo2.value, showTick: true),
            const SizedBox(height: 15),
            Obx(
              () => _Entry(
                  content: handler.todo3.value, showTick: handler.todo3bool),
            ),
          ],
        ),
      ),
    );
  }
}

/// widget for showing a security todo
class _Entry extends StatelessWidget {
  const _Entry({
    Key? key,
    required this.content,
    required this.showTick,
  }) : super(key: key);

  final String content;
  final bool showTick;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "• $content",
          style: sizeHandler.currentTextTheme.bodyText1,
        ),
        SizedBox(
          height: 38,
          width: 38,
          child: Card(
            color: white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(300),
            ),
            child: Icon(
              showTick ? Icons.check_rounded : Icons.close_rounded,
              size: 28,
              color: showTick ? blue : red,
            ),
          ),
        )
      ],
    );
  }
}
