import 'package:flutter/material.dart';
import 'package:task_manager/presentation/utility/asset_paths.dart';
class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AssetPath.appLogoPng,
      height: 150,
      width: 150,
    );
  }
}
