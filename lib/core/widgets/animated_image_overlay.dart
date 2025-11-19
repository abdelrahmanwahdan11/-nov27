import 'package:flutter/material.dart';

class AnimatedImageOverlay extends StatelessWidget {
  const AnimatedImageOverlay({
    super.key,
    required this.imageUrl,
    required this.child,
    this.onClose,
  });

  final String imageUrl;
  final Widget child;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(.25),
                  BlendMode.darken,
                ),
              ),
            ),
          ),
        ),
        Center(
          child: ScaleTransition(
            scale: CurvedAnimation(
              parent: ModalRoute.of(context)!.animation!,
              curve: Curves.easeOutBack,
            ),
            child: child,
          ),
        ),
        Positioned(
          top: 24,
          right: 24,
          child: IconButton(
            onPressed: onClose ?? () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close, color: Colors.white),
          ),
        )
      ],
    );
  }
}
