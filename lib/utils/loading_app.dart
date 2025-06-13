import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';


class LoadingApp extends StatefulWidget {
  final bool isLoading;
  final double opacity;
  final Color? backroundColor;
  final Widget? progressIndicator;
  final String? loadingMsg;
  final Widget child;

  const LoadingApp({
    required this.isLoading,
    required this.child,
    this.opacity = 0.9,
    this.progressIndicator,
    this.backroundColor,
    this.loadingMsg,
  });

  @override
  _LoadingAppState createState() => _LoadingAppState();
}

class _LoadingAppState extends State<LoadingApp>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool? _overlayVisible;

  _LoadingAppState();

  @override
  void initState() {
    super.initState();
    _overlayVisible = false;
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
    _animation.addStatusListener((status) {
      // ignore: unnecessary_statements
      status == AnimationStatus.forward
          ? setState(() => {_overlayVisible = true})
          : null;
      // ignore: unnecessary_statements
      status == AnimationStatus.dismissed
          ? setState(() => {_overlayVisible = false})
          : null;
    });
    if (widget.isLoading) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(LoadingApp oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.isLoading && widget.isLoading) {
      _controller.forward();
    }

    if (oldWidget.isLoading && !widget.isLoading) {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // var sizeContainer = ((MediaQuery.of(context).size.width) * 30) / 100;
    var widgets = <Widget>[];
    widgets.add(widget.child);
    if (_overlayVisible == true) {
      final modal = FadeTransition(
        opacity: _animation,
        child: Stack(
          children: <Widget>[
            Opacity(
              child: ModalBarrier(
                dismissible: false,
                color: widget.backroundColor ?? Colors.white,
              ),
              opacity: widget.opacity,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    LoadingAnimationWidget.discreteCircle(
                      color: Colors.blue,
                      size: 50,
                      secondRingColor: Colors.blue,
                      thirdRingColor:  Colors.blue,
                    ),
                  ],
                ),
                SizedBox(height: 1.5, width: double.infinity),

              ],
            )
          ],
        ),
      );
      widgets.add(modal);
    }

    return Stack(children: widgets);
  }
}

class CircleLoading extends StatelessWidget {
  final double sizeHeight, strokeWidth;
  final Color? color, backroundColor;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final Widget? progressIndicator;

  const CircleLoading(
      {this.sizeHeight = 60,
      this.mainAxisAlignment = MainAxisAlignment.center,
      this.crossAxisAlignment = CrossAxisAlignment.center,
      this.progressIndicator,
      this.color,
      this.strokeWidth = 1,
      this.backroundColor});

  @override
  Widget build(BuildContext context) {
    final height = (MediaQuery.of(context).size.height);
    final width = (MediaQuery.of(context).size.width);
    return SizedBox(
      child: Center(
        child: progressIndicator ??
            CircularProgressIndicator(
              backgroundColor: backroundColor ?? Colors.grey[300],
              color: color ?? Colors.black,
              strokeWidth: height * strokeWidth / 100,
            ),
      ),
      width: width,
      height: sizeHeight,
    );
  }
}
