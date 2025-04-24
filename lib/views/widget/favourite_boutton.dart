import 'package:flutter/material.dart';

class FavouriteButton extends StatefulWidget {
  final bool initiallyFavorited;
  final void Function(bool)? onChanged;

  const FavouriteButton({
    Key? key,
    this.initiallyFavorited = false,
    this.onChanged,
  }) : super(key: key);

  @override
  State<FavouriteButton> createState() => _FavouriteButtonState();
}

class _FavouriteButtonState extends State<FavouriteButton> {
  late bool isFavorited;

  @override
  void initState() {
    super.initState();
    isFavorited = widget.initiallyFavorited;
  }

  void toggleFavourite() {
    setState(() {
      isFavorited = !isFavorited;
    });
    widget.onChanged?.call(isFavorited);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 1,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: toggleFavourite,
        child: Padding(
          padding: const EdgeInsets.all(4), // Minimal padding
          child: Icon(
            isFavorited ? Icons.favorite : Icons.favorite_border,
            color: isFavorited ? Colors.red : Colors.grey,
            size: 22, // Compact icon size
          ),
        ),
      ),
    );
  }
}
