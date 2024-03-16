import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:task_manager/presentation/utility/asset_paths.dart';

class Background extends StatelessWidget {
  final Widget child;
  const Background({super.key,required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SvgPicture.asset(AssetPath.backgroundSvg,height: double.infinity,width: double.infinity,fit: BoxFit.cover,),
        SafeArea(child: child),
      ],
    );
  }
}
