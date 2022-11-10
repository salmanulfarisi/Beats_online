import 'package:flutter/material.dart';

class PositionSeekWidget extends StatefulWidget {
  final Duration currentPosition;
  final Duration duration;
  final Function(Duration) seekTo;
  const PositionSeekWidget(
      {Key? key,
      required this.currentPosition,
      required this.duration,
      required this.seekTo})
      : super(key: key);

  @override
  State<PositionSeekWidget> createState() => _PositionSeekWidgetState();
}

class _PositionSeekWidgetState extends State<PositionSeekWidget> {
  late Duration _visibleVlaue;
  bool listenOnlyUserInteraction = false;
  double get percent => widget.duration.inMilliseconds == 0
      ? 0
      : _visibleVlaue.inMilliseconds / widget.duration.inMilliseconds;
  @override
  void initState() {
    _visibleVlaue = widget.currentPosition;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant PositionSeekWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listenOnlyUserInteraction) {
      _visibleVlaue = widget.currentPosition;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Expanded(
              child: SliderTheme(
                data: const SliderThemeData(
                    trackHeight: 1,
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5)),
                child: Slider(
                  min: 0,
                  inactiveColor: Colors.grey,
                  activeColor: Colors.white,
                  max: widget.duration.inMilliseconds.toDouble(),
                  value: percent * widget.duration.inMilliseconds.toDouble(),
                  onChangeEnd: (newValue) {
                    setState(() {
                      listenOnlyUserInteraction = false;
                      widget.seekTo(_visibleVlaue);
                    });
                  },
                  onChangeStart: (_) {
                    setState(() {
                      listenOnlyUserInteraction = true;
                    });
                  },
                  onChanged: (newValue) {
                    setState(() {
                      final to = Duration(milliseconds: newValue.floor());
                      _visibleVlaue = to;
                    });
                  },
                ),
              ),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 40,
                child: Text(
                  durationToString(widget.currentPosition),
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              SizedBox(
                width: 40,
                child: Text(durationToString(widget.duration),
                    style: const TextStyle(color: Colors.white, fontSize: 12)),
              )
            ],
          ),
        ),
      ],
    );
  }
}

String durationToString(Duration duration) {
  String twoDigits(int n) {
    if (n >= 10) return '$n';
    return '0$n';
  }

  final twoDigitMinutes =
      twoDigits(duration.inMinutes.remainder(Duration.minutesPerHour));
  final twoDigitSeconds =
      twoDigits(duration.inSeconds.remainder(Duration.secondsPerMinute));
  return '$twoDigitMinutes:$twoDigitSeconds';
}
