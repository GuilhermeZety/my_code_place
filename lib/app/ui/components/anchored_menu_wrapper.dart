import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AnchoredMenuWrapper extends StatefulWidget {
  final Widget child;
  final Widget menuContent;
  final Size menuSize;
  final VoidCallback? onOpen;
  final double windowScale;

  const AnchoredMenuWrapper({
    super.key,
    required this.child,
    required this.menuContent,
    required this.menuSize,
    this.onOpen,
    this.windowScale = 1,
  });

  @override
  State<AnchoredMenuWrapper> createState() => AnchoredMenuWrapperState();
}

class AnchoredMenuWrapperState extends State<AnchoredMenuWrapper>
    with SingleTickerProviderStateMixin {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  bool get isOpen => _overlayEntry != null;
  bool _showTop = false;
  bool _showRight = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: 200.ms,
      reverseDuration: 150.ms,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
      reverseCurve: Curves.easeIn,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _removeOverlay();
    super.dispose();
  }

  void showOverlay() {
    // if already open, do nothing
    if (_overlayEntry != null) return;

    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    // logic to decide if open above or below
    final screenHeight = MediaQuery.of(context).size.height;
    final spaceBelow = screenHeight - (offset.dy + size.height);

    if (spaceBelow < (widget.menuSize.height + 15) * widget.windowScale) {
      _showTop = true;
    } else {
      _showTop = false;
    }

    if (offset.dx < (widget.menuSize.width - 20) * widget.windowScale) {
      _showRight = true;
    } else {
      _showRight = false;
    }

    final double widthOffset = _showRight ? 0 : -(widget.menuSize.width - 30);

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: closeOverlay,
              behavior: HitTestBehavior.translucent,
              child: Container(color: Colors.transparent),
            ),
          ),
          CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: Offset(
              widthOffset,
              _showTop ? -widget.menuSize.height - 5 : size.height + 5,
            ),
            child: Material(
              color: Colors.transparent,
              child: SizedBox(
                width: widget.menuSize.width,
                height: widget.menuSize.height,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  alignment: Alignment(
                    _showRight ? -1 : 1,
                    _showTop ? 1 : -1,
                  ),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: widget.menuContent,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    overlay.insert(_overlayEntry!);
    widget.onOpen?.call();
    _animationController.forward();
  }

  void closeOverlay() async {
    await _animationController.reverse();
    _removeOverlay();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: () {
          if (_overlayEntry == null) {
            showOverlay();
          } else {
            closeOverlay();
          }
        },
        child: widget.child,
      ),
    );
  }
}
