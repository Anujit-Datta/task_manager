import 'package:flutter/material.dart';
import 'package:task_manager/presentation/widget/background.dart';
import '../widget/dashboard_card.dart';
import '../widget/task_card.dart';

class ProgressTaskScreen extends StatefulWidget {
  const ProgressTaskScreen({super.key});

  @override
  State<ProgressTaskScreen> createState() => _ProgressTaskScreenState();
}

class _ProgressTaskScreenState extends State<ProgressTaskScreen> {
  @override
  Widget build(BuildContext context) {
    return Background(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context,index){
                  return const TaskCard();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

