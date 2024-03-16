import 'package:flutter/material.dart';

Expanded dashboardCard(BuildContext context,String title,int number) {
  return Expanded(
    child: Card(
      color: Colors.white,
      elevation: 3,
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width*0.2,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(number.toString(),style: const TextStyle(fontSize: 25,fontWeight: FontWeight.w500)),
              Text(title,style: const TextStyle(color: Colors.grey),),
            ],
          ),
        ),
      ),
    ),
  );
}