import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/app/tasks/task_widget.dart';
import 'package:to_do_app/helpers/ad_mod_service.dart';
import 'package:to_do_app/helpers/size_helper.dart';
import 'package:to_do_app/helpers/constants.dart';
import 'package:google_fonts/google_fonts.dart';

const int kNumberOfPointsForAds = 3;

class TasksPage extends StatefulWidget {
  const TasksPage({
    Key? key,
  }) : super(key: key);

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final adManager = AdManager();

  final controller = TextEditingController();

  bool watchedAds = false;

  @override
  void initState() {
    super.initState();
    adManager.addAds(true, true, true);
    adManager.showRewardedAd();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('tasks').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('An unexpected error occurred');
          }

          final documents = snapshot.data!.docs;

          var numberOfTasks = documents.length;

          var points =
              kNumberOfPointsForAds - (numberOfTasks % kNumberOfPointsForAds);

          points = points == kNumberOfPointsForAds
              ? watchedAds
                  ? kNumberOfPointsForAds
                  : 0
              : points;

          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: Text(
                'TO-DO',
                style: GoogleFonts.poppins(
                  fontSize: SizeHelper.getSizeFromPx(context, 55),
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            floatingActionButton: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FloatingActionButton(
                  onPressed: points == 0
                      ? () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('Oooops...'),
                              content:
                                  const Text('Watch an ad and earn points'),
                              actions: <Widget>[
                                ElevatedButton(
                                  onPressed: () {
                                    adManager.showRewardedAd();
                                    Navigator.pop(context, true);
                                    setState(() {
                                      watchedAds = true;
                                    });
                                  },
                                  child: const Text('Watch'),
                                ),
                              ],
                            ),
                          );
                          points;
                        }
                      : () {
                          setState(() {
                            watchedAds = false;
                          });
                          FirebaseFirestore.instance.collection('tasks').add(
                              {'title': controller.text, 'points': points});
                          controller.clear();
                        },
                  child: const Icon(Icons.add),
                ),
                FloatingActionButton.extended(
                  icon: const Icon(Icons.logout),
                  label: Text(
                    'Log out',
                    style: GoogleFonts.poppins(
                      fontSize: SizeHelper.getSizeFromPx(context, 45),
                      fontWeight: FontWeight.normal,
                    ),
                  ),
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
                child: ListView(
                  children: [
                    Container(
                      margin: EdgeInsets.all(
                        SizeHelper.getSizeFromPx(context, 55),
                      ),
                      height: SizeHelper.getSizeFromPx(context, 120),
                      color: Constants.colorPink,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            FirebaseAuth.instance.currentUser!.email!,
                            style: GoogleFonts.poppins(
                              fontSize: SizeHelper.getSizeFromPx(context, 45),
                              fontWeight: FontWeight.normal,
                              color: Colors.white,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                'points: ',
                                style: GoogleFonts.poppins(
                                  fontSize:
                                      SizeHelper.getSizeFromPx(context, 45),
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                '$points',
                                style: GoogleFonts.poppins(
                                  fontSize:
                                      SizeHelper.getSizeFromPx(context, 45),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
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
                          document['points'],
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
                ),
              ),
            ),
          );
        });
  }
}
