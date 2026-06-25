import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class ScrollableTableWrapper extends StatefulWidget {
  final Widget child;

  ScrollableTableWrapper({super.key, required this.child});

  @override
  State<ScrollableTableWrapper> createState() => _ScrollableTableWrapperState();
}

class _ScrollableTableWrapperState extends State<ScrollableTableWrapper> {
  final ScrollController _controller = ScrollController();
  bool _canScrollLeft = false;
  bool _canScrollRight = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_updateScrollButtons);
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateScrollButtons());
  }

  void _updateScrollButtons() {
    if (!mounted) return;
    setState(() {
      _canScrollLeft = _controller.position.pixels > 0;
      _canScrollRight = _controller.position.pixels < _controller.position.maxScrollExtent;
    });
  }

  void _scrollLeft() {
    _controller.animateTo(
      (_controller.position.pixels - 200).clamp(0.0, _controller.position.maxScrollExtent),
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _scrollRight() {
    _controller.animateTo(
      (_controller.position.pixels + 200).clamp(0.0, _controller.position.maxScrollExtent),
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.removeListener(_updateScrollButtons);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          controller: _controller,
          scrollDirection: Axis.horizontal,
          physics: BouncingScrollPhysics(),
          child: widget.child,
        ),
        if (_canScrollLeft)
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Center(
              child: Container(
                margin: EdgeInsets.only(left: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.95),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(1, 1))],
                ),
                child: IconButton(
                  icon: Icon(Icons.chevron_left, color: AppColors.primary),
                  onPressed: _scrollLeft,
                  iconSize: 20,
                  constraints: BoxConstraints(minWidth: 36, minHeight: 36),
                  padding: EdgeInsets.zero,
                ),
              ),
            ),
          ),
        if (_canScrollRight)
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: Center(
              child: Container(
                margin: EdgeInsets.only(right: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.95),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(-1, 1))],
                ),
                child: IconButton(
                  icon: Icon(Icons.chevron_right, color: AppColors.primary),
                  onPressed: _scrollRight,
                  iconSize: 20,
                  constraints: BoxConstraints(minWidth: 36, minHeight: 36),
                  padding: EdgeInsets.zero,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
