import 'package:flutter/material.dart';

class EmptyList extends StatelessWidget {
  const EmptyList({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Opacity(
              opacity: 0.5,
              child: Icon(Icons.nights_stay_outlined, size: 100),
            ),
            SizedBox(height: 10,),
            Text(
              textAlign: TextAlign.center,
              'Poka chto tshina brat \n', 
              style: TextStyle(fontSize: 18, color: const Color.fromARGB(204, 255, 255, 255), fontWeight: FontWeight.bold),
            ),

          ],
        ),
      ),
    );
  }
}
