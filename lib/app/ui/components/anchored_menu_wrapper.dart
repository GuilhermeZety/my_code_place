import 'package:flutter/material.dart';

class AnchoredMenuWrapper extends StatefulWidget {
  final Widget child; // O IconButton
  final Widget menuContent; // O conteúdo do menu flutuante
  final Size menuSize; // Tamanho fixo do menu (width, height)
  final VoidCallback? onOpen; // Callback opcional

  const AnchoredMenuWrapper({
    super.key,
    required this.child,
    required this.menuContent,
    required this.menuSize,
    this.onOpen,
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
  // Estado para controlar se abre para cima ou para baixo
  bool _showAbove = false;

  @override
  void initState() {
    super.initState();
    // Configuração da animação (rápida, 200ms)
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      reverseDuration: const Duration(milliseconds: 150),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack, // Dá um efeito de "pulo" ao abrir
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

  // Função principal para mostrar o menu
  void showOverlay() {
    if (_overlayEntry != null) return; // Já está aberto

    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    // Lógica para decidir se abre para CIMA ou para BAIXO
    final screenHeight = MediaQuery.of(context).size.height;
    final spaceBelow = screenHeight - (offset.dy + size.height);
    final spaceAbove = offset.dy;

    // Se não couber embaixo e tiver mais espaço em cima, inverte
    // Adicionei uma margem de segurança de 10px
    if (spaceBelow < widget.menuSize.height + 10 && spaceAbove > widget.menuSize.height) {
      _showAbove = true;
    } else {
      _showAbove = false;
    }

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // 1. Detector de toque fora para fechar o menu
          Positioned.fill(
            child: GestureDetector(
              onTap: closeOverlay,
              behavior: HitTestBehavior.translucent,
              child: Container(color: Colors.transparent),
            ),
          ),
          // 2. O Menu Flutuante ancorado
          CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            // Ajusta o offset baseado na direção
            offset: _showAbove
                ? Offset(
                    -(widget.menuSize.width - (widget.menuSize.width * 0.1)),
                    -widget.menuSize.height - 10,
                  ) // 10px de margem acima
                : Offset(
                    -(widget.menuSize.width - (widget.menuSize.width * 0.1)),
                    size.height + 10,
                  ), // 10px de margem abaixo
            child: Material(
              color: Colors.transparent,
              child: SizedBox(
                width: widget.menuSize.width,
                height: widget.menuSize.height,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  // O alinhamento da animação muda dependendo da direção
                  alignment: _showAbove ? Alignment.bottomRight : Alignment.topRight,
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
