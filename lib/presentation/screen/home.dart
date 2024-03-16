import 'package:flutter/material.dart';
import 'package:task_manager/presentation/screen/cancelled.dart';
import 'package:task_manager/presentation/screen/completed.dart';
import 'package:task_manager/presentation/screen/new.dart';
import 'package:task_manager/presentation/screen/progress.dart';
import 'package:task_manager/presentation/utility/app_colors.dart';
import '../widget/profile_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int bottomNavbarSelectedItem=0;
  List<Widget> homeBody=[
    const NewTaskScreen(),
    const ProgressTaskScreen(),
    const CancelledTaskScreen(),
    const CompletedTaskScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileBar,
      body: homeBody[bottomNavbarSelectedItem],
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        selectedItemColor: AppColors.themeColor,
        currentIndex: bottomNavbarSelectedItem,
        onTap: (selected){
          bottomNavbarSelectedItem=selected;
          setState(() {});
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.add_task),
            label: 'New',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_rounded),
            label: 'Progress',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cancel_outlined),
            label: 'Cancelled',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.task_alt),
            label: 'Completed',
          ),
        ],
      ),
    );
  }

}
