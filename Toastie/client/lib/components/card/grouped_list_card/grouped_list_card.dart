import 'package:flutter/material.dart';
import 'package:toastie/components/card/base_card.dart';
import 'package:toastie/themes/colors.dart';

class GroupedListCard extends StatelessWidget {
  GroupedListCard({
    required this.items,
  });

  final List<Widget> items;

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      solidColor: Colors.white,
      child: Column(
        children: List.generate(items.length, (index) {
          return Column(
            children: [
              items[index],
              if (index < items.length - 1)
                Divider(
                  height: 1,
                  thickness: 0.5,
                  color: primary[300] as Color,
                ),
            ],
          );
        }),
      ),
    );
  }
}
