import 'package:flutter/material.dart';
class CountDownTimer extends StatefulWidget {
  const CountDownTimer({
    Key? key,
    int? secondsRemaining,
    this.countDownTimerStyle,
    this.whenTimeExpires,
    this.countDownFormatter,
  })  : secondsRemaining = secondsRemaining,
        super(key: key);

  final int? secondsRemaining;
  final Function? whenTimeExpires;
  final Function ?countDownFormatter;
  final TextStyle? countDownTimerStyle;

  State createState() => new _CountDownTimerState();
}

class _CountDownTimerState extends State<CountDownTimer>
    with TickerProviderStateMixin {
  AnimationController? _controller;
  Duration? duration;

 String get timerDisplayString {
  Duration? duration = _controller?.duration;
  double value = _controller?.value ?? 0;
  Duration resultDuration = Duration.zero;

  if (duration != null) {
    resultDuration = duration * value;
  }

  return widget.countDownFormatter != null
      ? widget.countDownFormatter!(resultDuration.inSeconds)
      : formatHHMMSS(duration?.inSeconds ?? 0);
}

String formatHHMMSS(int seconds) {
  // Implement your formatting logic here
  // Example implementation:
  int hours = seconds ~/ 3600;
  int minutes = (seconds ~/ 60) % 60;
  int secs = seconds % 60;
  return '$hours:$minutes:$secs';
}


  @override
  void initState() {
    super.initState();
    duration = new Duration(seconds: widget.secondsRemaining!);
    _controller = new AnimationController(
     vsync: this,
      duration: duration,
    );
    _controller?.reverse(from: widget.secondsRemaining!.toDouble());
    _controller?.addStatusListener((status) {
      if (status == AnimationStatus.completed || status == AnimationStatus.dismissed) {
        widget.whenTimeExpires!();
      }
    });
  }

  @override
  void didUpdateWidget(CountDownTimer oldWidget) {
    if (widget.secondsRemaining != oldWidget.secondsRemaining) {
      setState(() {
        duration = new Duration(seconds: widget.secondsRemaining!);
        _controller?.dispose();
        _controller = new AnimationController(
          vsync: this,
          duration: duration,
        );
        _controller?.reverse(from: widget.secondsRemaining!.toDouble());
        _controller?.addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            widget.whenTimeExpires!();
          } else if (status == AnimationStatus.dismissed) {
            print("Animation Complete");
          }
        });
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
        child: AnimatedBuilder(
            animation: _controller!,
            builder: (_, Widget? child) {
              return Text(
                timerDisplayString,
                style: widget.countDownTimerStyle,
              );
            }));
  }
  String formatHHMMSSS(int seconds) {
    int hours = (seconds / 3600).truncate();
    seconds = (seconds % 3600).truncate();
    int minutes = (seconds / 60).truncate();

    String hoursStr = (hours).toString().padLeft(2, '0');
    String minutesStr = (minutes).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');

    if (hours == 0) {
      return "$minutesStr:$secondsStr";
    }

    return "$hoursStr:$minutesStr:$secondsStr";
  }
}