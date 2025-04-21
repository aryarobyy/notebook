import 'package:flutter/material.dart';
import 'package:to_do_list/component/card.dart';
import 'package:to_do_list/component/text.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

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
          SizedBox(height: 15,),
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
                backgroundColor: cs.primary.withOpacity(0.4),
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
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: MyCard(
                  title: "Bayu Nikah",
                  subtitle: "Besok",
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: cs.primary,
                  ),
                  child: MyText(
                    "All",
                    fontWeight: FontWeight.w300,
                    fontSize: 18,
                    color: cs.onSurface,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: cs.surface,
                  ),
                  child: MyText(
                    "Tomorrow",
                    fontWeight: FontWeight.w300,
                    fontSize: 18,
                    color: cs.onSurface,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: cs.surface,
                  ),
                  child: Center(
                    child: MyText(
                      "Favourite",
                      fontWeight: FontWeight.w300,
                      fontSize: 18,
                      color: cs.onSurface,
                    )
                  ),
                ),
                SizedBox(width: 8,),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: cs.surface,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.add,
                      color: cs.onSurface,
                    )
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 4,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MyCard(
                    title: "Pergi ke pasar",
                    subtitle: "Hari ini",
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
