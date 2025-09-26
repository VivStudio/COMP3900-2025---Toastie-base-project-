import 'dart:io';
import 'package:flutter/material.dart';
import 'package:toastie/features/lab_report/widgets/report_editor/full_screen_gallery.dart';
import 'package:toastie/themes/colors.dart';
import 'package:toastie/utils/grid.dart';

class ImageCarousel extends StatefulWidget {
  ImageCarousel({
    this.imageFiles = const [],
  });
  final List<File> imageFiles;

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  int _currentIndex = 0;
  final _pageController = PageController();
  final ScrollController _indicatorScrollController = ScrollController();

  @override
  void dispose() {
    _pageController.dispose();
    _indicatorScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.imageFiles.length == 0
        ? SizedBox.shrink()
        : Column(
            children: [
              // 📸 Carousel with previews
              SizedBox(
                height: 150,
                child: PageView.builder(
                  controller: PageController(
                    viewportFraction: 0.8,
                  ), // Show part of next image
                  itemCount: widget.imageFiles.length,
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
                      targetScrollOffset.clamp(0.0,
                          _indicatorScrollController.position.maxScrollExtent,),
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  },
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => FullScreenGallery(
                              images: widget.imageFiles,
                              initialIndex: index,
                            ),
                          ),
                        );
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: EdgeInsets.symmetric(
                            horizontal: gridbaseline,
                            vertical:
                                index == _currentIndex ? 0 : gridbaseline,),
                        decoration: BoxDecoration(
                          borderRadius: borderRadius,
                        ),
                        child: ClipRRect(
                          borderRadius: borderRadius,
                          child: Image.file(
                            widget.imageFiles[index],
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: gridbaseline),

              // ⚪ Indicator Dots
              Visibility(
                visible: widget.imageFiles.length > 1,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: _indicatorScrollController,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(widget.imageFiles.length, (index) {
                      bool isActive = index == _currentIndex;
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
          );
  }
}
