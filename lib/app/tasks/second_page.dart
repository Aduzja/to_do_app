import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/helpers/size_helper.dart';
import 'package:to_do_app/helpers/constants.dart';
import 'package:google_fonts/google_fonts.dart';

class SecondPage extends StatelessWidget {
  SecondPage({Key? key}) : super(key: key);

  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FloatingActionButton(
            onPressed: () {
              FirebaseFirestore.instance.collection('tasks').add(
                {'title': controller.text},
              );
              controller.clear();
            },
            child: const Icon(Icons.add),
          ),
          FloatingActionButton.extended(
            icon: const Icon(Icons.logout),
            label: const Text('Log out'),
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [Constants.colorPink, Constants.colorBlue],
            ),
          ),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('tasks').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text('An unexpected error occurred');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text('Please wait, loading');
              }

              final documents = snapshot.data!.docs;

              return ListView(
                children: [
                  for (final document in documents) ...[
                    Dismissible(
                      key: ValueKey(document.id),
                      onDismissed: (_) {
                        FirebaseFirestore.instance
                            .collection('tasks')
                            .doc(document.id)
                            .delete();
                      },
                      child: TaskWidget(
                        document['title'],
                      ),
                    ),
                  ],
                  Container(
                    margin: EdgeInsets.all(
                      SizeHelper.getSizeFromPx(context, 55),
                    ),
                    child: TextField(
                      controller: controller,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class TaskWidget extends StatelessWidget {
  const TaskWidget(
    this.title, {
    Key? key,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Constants.colorMustard,
      padding: EdgeInsets.all(
        SizeHelper.getSizeFromPx(context, 55),
      ),
      margin: EdgeInsets.all(
        SizeHelper.getSizeFromPx(context, 55),
      ),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: SizeHelper.getSizeFromPx(context, 55),
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }
}
