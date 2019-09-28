import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

/// asset_classes option lets you define completely custom classes for handling assets
/// based on their extension
/// Here we used SvgFile to automatically convert svg assets into widgets
class SvgFile extends StatelessWidget {
  final String path;
  const SvgFile(this.path);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(path);
  }
}
