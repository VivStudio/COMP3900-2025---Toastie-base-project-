import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:toastie/themes/colors.dart';
import 'package:toastie/utils/layout/grid.dart';

class FullScreenGallery extends StatefulWidget {
  const FullScreenGallery({
    required this.images,
    required this.initialIndex,
    super.key,
  });

  final List<Object> images; // File or Uint8List
  final int initialIndex;

  @override
  State<FullScreenGallery> createState() => _FullScreenGalleryState();
}

class _FullScreenGalleryState extends State<FullScreenGallery> {
  late PageController _pageController;
  late int _currentIndex;
  double _verticalDrag = 0;
  late ScrollController _indicatorScrollController;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
    _indicatorScrollController = ScrollController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _handleVerticalDragUpdate(DragUpdateDetails details) {
    _verticalDrag += details.delta.dy;
  }

  void _handleVerticalDragEnd(DragEndDetails details) {
    if (_verticalDrag > 100) {
      Navigator.of(context).maybePop();
    }
    _verticalDrag = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: GestureDetector(
        onVerticalDragUpdate: _handleVerticalDragUpdate,
        onVerticalDragEnd: _handleVerticalDragEnd,
        behavior: HitTestBehavior.opaque,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: widget.images.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });

                // Scroll the indicator row
                final double dotWidthIncludingMargin =
                    gridbaseline + gridbaseline;
                final double targetScrollOffset =
                    (dotWidthIncludingMargin * index) -
                        MediaQuery.of(context).size.width / 2 +
                        dotWidthIncludingMargin / 2;

                _indicatorScrollController.animateTo(
                  targetScrollOffset.clamp(
                      0.0, _indicatorScrollController.position.maxScrollExtent,),
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );
              },
              itemBuilder: (context, index) {
                final image = widget.images[index];
                if (image is File) {
                  return Center(
                    child: Image.file(
                      image,
                      fit: BoxFit.contain,
                    ),
                  );
                } else if (image is Uint8List) {
                  return Center(
                    child: Image.memory(
                      image,
                      fit: BoxFit.contain,
                    ),
                  );
                } else {
                  return const Center(
                    child: Text(
                      'Unsupported image type',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }
              },
            ),
            if (widget.images.length > 1)
              Padding(
                padding: const EdgeInsets.all(gridbaseline * 2),
                // TODO: extract bottom dot indicator to separate component
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: _indicatorScrollController,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(widget.images.length, (index) {
                      final isActive = index == _currentIndex;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(
                            horizontal: gridbaseline / 2,),
                        width: gridbaseline,
                        height: gridbaseline,
                        decoration: BoxDecoration(
                          color: isActive ? primary[600] : neutral[300],
                          shape: BoxShape.circle,
                        ),
                      );
                    }),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
