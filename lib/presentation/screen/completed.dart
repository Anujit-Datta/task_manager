import 'package:flutter/material.dart';
import 'package:task_manager/presentation/widget/background.dart';
import '../widget/dashboard_card.dart';
import '../widget/task_card.dart';

class CompletedTaskScreen extends StatefulWidget {
  const CompletedTaskScreen({super.key});

  @override
  State<CompletedTaskScreen> createState() => _CompletedTaskScreenState();
}

class _CompletedTaskScreenState extends State<CompletedTaskScreen> {
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

