import 'package:flutter/material.dart';
import 'package:task_manager/presentation/utility/app_colors.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(top: 16,bottom: 8,left: 16,right: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Task Title',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600
              ),
            ),
            const Text(
              'Task Description in short',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey
              ),
            ),
            const SizedBox(height: 5,),
            const Text(
              'Date: 03/16/24',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,

              ),
            ),
            const SizedBox(height: 10,),
            SizedBox(
              height: 18,
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.lightBlue[300],
                    ),
                    child: const SizedBox(width: 80,child: Center(child: Text('New',style: TextStyle(fontSize: 12,color: Colors.white),),),),
                  ),
                  const Expanded(child: SizedBox()),
                  IconButton(
                    onPressed: (){},
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.edit_note,size: 20,color: AppColors.themeColor,),
                  ),
                  IconButton(
                    onPressed: (){},
                    padding: EdgeInsets.zero,
                    icon: Icon(Icons.delete_forever,size: 20,color: Colors.red[300],),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
