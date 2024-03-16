import 'package:flutter/material.dart';
import 'package:task_manager/presentation/widget/background.dart';
import '../widget/dashboard_card.dart';
import '../widget/task_card.dart';

class CancelledTaskScreen extends StatefulWidget {
  const CancelledTaskScreen({super.key});

  @override
  State<CancelledTaskScreen> createState() => _CancelledTaskScreenState();
}

class _CancelledTaskScreenState extends State<CancelledTaskScreen> {
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

