import 'package:flutter/material.dart';
import 'package:to_do_list/component/card.dart';
import 'package:to_do_list/component/text.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        // centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const MyText(
              "Home",
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
            // Spacer(), //rencana b
            // Icon(Icons.settings)
          ],
        ),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(
                    "Welcome back",
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  SizedBox(height: 4),
                  MyText(
                    "Roby",
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
              Spacer(),
              CircleAvatar(
                radius: 40,
                backgroundColor: cs.primaryColor.withOpacity(0.4),
                backgroundImage: AssetImage("assets/bayu.jpg"),
              )
            ],
          ),
          SizedBox(height: 20,),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyText(
                "Now Running",
                fontSize: 14,
              ),
              const SizedBox(height: 8),
              MyCard(
                title: "Bayu Nikah",
                subtitle: "Besok",
              )
            ],
          )
        ],
      ),
    );
  }
}
