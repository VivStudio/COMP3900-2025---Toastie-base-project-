import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ParentWidget(),
    );
  }
}

class ParentWidget extends StatefulWidget {
  const ParentWidget({super.key});

  @override
  _ParentWidgetState createState() => _ParentWidgetState();
}

class _ParentWidgetState extends State<ParentWidget> {
  double _sliderValue = 0.0;

  late SliderWidget _slider;

  @override
  void initState() {
    super.initState();
    _slider = SliderWidget(
      initialValue: _sliderValue,
      onValueChanged: _updateColor,
    );
  }

  void _updateColor(double value) {
    setState(() {
      _sliderValue = value;
    });
    print(_slider.currentValue());
  }

  Color _getBackgroundColor() {
    return Color.lerp(Colors.blue, Colors.red, _sliderValue / 100)!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _getBackgroundColor(),
      appBar: AppBar(title: const Text('Slider Color Example')),
      body: Center(
        child: _slider,
      ),
    );
  }
}

class SliderWidget extends StatefulWidget {
  SliderWidget({
    required this.initialValue,
    required this.onValueChanged,
    super.key,
  });
  final double initialValue;
  final ValueChanged<double> onValueChanged;

  _SliderWidgetState state = _SliderWidgetState();

  double currentValue() {
    return state._sliderValue;
  }

  @override
  _SliderWidgetState createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  late double _sliderValue;

  @override
  void initState() {
    super.initState();
    _sliderValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: _sliderValue,
      min: 0,
      max: 100,
      divisions: 10,
      label: _sliderValue.toStringAsFixed(1),
      onChanged: (newValue) {
        setState(() {
          _sliderValue = newValue;
        });
        widget.onValueChanged(newValue);
      },
    );
  }
}
