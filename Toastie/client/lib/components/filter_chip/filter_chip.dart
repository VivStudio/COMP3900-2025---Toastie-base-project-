import 'package:flutter/material.dart';
import 'package:toastie/themes/colors.dart';

class ToastieFilterChip extends StatefulWidget {
  const ToastieFilterChip({
    required this.label,
    required this.icon,
    required this.options,
    required this.onSelectionChanged,
    super.key,
  });

  final String label;
  final IconData icon;
  final List<String> options;
  final ValueChanged<List<String>> onSelectionChanged;

  @override
  State<ToastieFilterChip> createState() => _ToastieFilterChipState();
}

class _ToastieFilterChipState extends State<ToastieFilterChip> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  List<String> _selectedOptions = [];

  @override
  void initState() {
    super.initState();
    _selectedOptions = [];
  }

  void _showOverlay() {
    if (_overlayEntry == null) {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
    }
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0.0, size.height + 8.0), // 8.0 for a little spacing
          child: Material(
            elevation: 4.0,
            borderRadius: BorderRadius.circular(8.0),
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: neutral[400] as Color),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Selectable options
                  ...widget.options.map((option) => ListTile(
                        title: Text(option),
                        trailing: _selectedOptions.contains(option)
                            ? const Icon(Icons.check, color: accentPink)
                            : null,
                        onTap: () {
                          setState(() {
                            if (_selectedOptions.contains(option)) {
                              _selectedOptions.remove(option);
                            } else {
                              _selectedOptions.add(option);
                            }
                          });
                          widget.onSelectionChanged(_selectedOptions);
                        },
                      ),),
                  const Divider(),
                  // Select All / Remove All buttons
                  ListTile(
                    title: const Text('Select All'),
                    onTap: () {
                      setState(() {
                        _selectedOptions = List.from(widget.options);
                      });
                      widget.onSelectionChanged(_selectedOptions);
                      _hideOverlay(); // Close after selection
                    },
                  ),
                  ListTile(
                    title: const Text('Remove All Selected'),
                    onTap: () {
                      setState(() {
                        _selectedOptions.clear();
                      });
                      widget.onSelectionChanged(_selectedOptions);
                      _hideOverlay(); // Close after selection
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: () {
          if (_overlayEntry == null) {
            _showOverlay();
          } else {
            _hideOverlay();
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(color: neutral[400] as Color),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, size: 18.0, color: accentPink),
              const SizedBox(width: 8.0),
              Text(
                widget.label,
                style: TextStyle(
                  color: neutral[900] as Color,
                  fontSize: 14.0,
                ),
              ),
              const SizedBox(width: 4.0),
              Icon(
                _overlayEntry != null
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                size: 18.0,
                color: neutral[900] as Color,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
