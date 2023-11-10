import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:story/src/home/model/story.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late List<Story> stories;
  int currentIndex = 0;
  String wrapText(String inputText, int maxLineLength) {
    StringBuffer buffer = StringBuffer();
    int currentIndex = 0;

    while (currentIndex < inputText.length) {
      int nextIndex = currentIndex + maxLineLength;
      if (nextIndex > inputText.length) {
        nextIndex = inputText.length;
      }

      String line = inputText.substring(currentIndex, nextIndex);
      buffer.write(line);

      if (nextIndex < inputText.length) {
        buffer.write('-\n');
      }

      currentIndex = nextIndex;
    }

    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 220, 220, 220),
        title: Image.asset(
          "assets/logo.png",
          width: 60,
          height: 60,
        ),
        actions: [
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "Handicrafted by",
                style: TextStyle(color: Color.fromARGB(255, 166, 166, 166)),
              ),
              SizedBox(width: 5),
              Text(
                "Jim HLS",
                style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
              ),
            ],
          ),
          const SizedBox(
            width: 5,
          ),
          Image.asset(
            "assets/anh.png",
            width: 60,
            height: 60,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 130,
              width: MediaQuery.of(context).size.width,
              color: const Color.fromARGB(255, 60, 179, 113),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "A joke a day keeps the doctor away",
                    style: TextStyle(
                      fontSize: 22,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "If you joke the wrong way, your teeth have to pay. (Serious)",
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                ],
              ),
            ),
            StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('story').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                stories = snapshot.data!.docs.map((document) {
                  Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;
                  return Story.fromMap(document.id, data);
                }).toList();
                if (currentIndex >= stories.length) {
                  return const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 350,
                        child: Text(
                            "That's all the stories for today! Come back another day!"),
                      ),
                    ],
                  );
                }

                return Column(
                  children: [
                    const SizedBox(height: 20),
                    Column(
                      children: [
                        SizedBox(
                          height: 230,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              stories[currentIndex].content,
                              style: const TextStyle(
                                  fontSize: 15.5,
                                  color: Color.fromARGB(255, 77, 76, 76)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.blue),
                            shape: MaterialStateProperty.all<OutlinedBorder>(
                              const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                              ),
                            ),
                          ),
                          onPressed: () {
                            String currentStoryId = stories[currentIndex].id;

                            FirebaseFirestore.instance
                                .collection('story')
                                .doc(currentStoryId)
                                .update({
                              'comment': "This is funny",
                              // Update other fields as needed
                            });
                            setState(() {
                              currentIndex++;
                            });
                          },
                          child: const Text(
                            "This is Funny!",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(
                          width: 40,
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              const Color.fromARGB(255, 60, 179, 113),
                            ),
                            shape: MaterialStateProperty.all<OutlinedBorder>(
                              const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                              ),
                            ),
                          ),
                          onPressed: () {
                            String currentStoryId = stories[currentIndex].id;

                            FirebaseFirestore.instance
                                .collection('story')
                                .doc(currentStoryId)
                                .update({
                              'comment': "This is not funny",
                            });
                            setState(() {
                              currentIndex++;
                            });
                          },
                          child: const Text(
                            "This is not funny",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 150,
              decoration: const BoxDecoration(
                border: Border(
                    top: BorderSide(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                    bottom: BorderSide(
                      color: Colors.grey,
                      width: 1.0,
                    )),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    wrapText(
                      "This app is created as part of Hlsolutions program. The materials contained on this website are provided for general information only and do not constitute any form of advice. HLS assumes no responsibility for any loss or damage which may arise from reliance on the information contained on this site",
                      67,
                    ),
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                  const Text("Copyright 2021 HLS")
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
