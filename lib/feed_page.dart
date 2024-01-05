import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  List<Object?> allData = [];
  getRecData() async {
    CollectionReference recRef =
        FirebaseFirestore.instance.collection('jobPost');
    QuerySnapshot querySnapshot = await recRef.get();

    allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    setState(() {});

    // for (var element in allData) {
    //   recRef.add(element);
    //   setState(() {});

    // }
    print(allData);
  }

  @override
  void initState() {
    // TODO: implement initState
    getRecData();
    getTimer();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('jobdetails')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return new Text("There is no job post");
                return Center(
                  child: Column(
                    children: [
                      Table(
                        children: [
                          TableRow(children: [
                            Text('recruiter'),
                            Text('jobposted'),
                            Text('jobfilled'),
                            Text('vacant')
                          ])
                        ],
                      ),
                      Table(
                        children: getJobDetailItems(snapshot),
                      ),
                    ],
                  ),
                );
              }),
          StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('jobPost').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return new Text("There is no job post");
                return ListView(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: getExpenseItems(snapshot));
              }),
        ],
      ),
    );
  }

  getTimer() {
    Timer.periodic(Duration(milliseconds: 500), (timer) {
      print('===================================$timer');
      setState(() {});
    });
  }

  getExpenseItems(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data!.docs
        .map((doc) => ListTile(
              isThreeLine: true,
              title: Text(doc["recruiter"]),
              trailing: Text(doc["postingdate"].toString()),
              subtitle: Column(
                children: [
                  Text(doc["skillname"].toString()),
                  DateTime.now()
                      .difference(DateTime.parse(doc["expiry"].toString()))
                      .inSeconds>=0?Text('job expired'):
                  Text(DateTime.now()
                      .difference(DateTime.parse(doc["expiry"].toString()))
                      .inSeconds
                      .toString()+'seconds left'),
                ],
              ),
              onTap: () {
                FirebaseFirestore.instance
                    .collection('jobdetails')
                    .doc(doc["recruiter"])
                    .update({
                  'jobfilled': FieldValue.increment(1),
                  // 'jobposted':FieldValue.increment(-1),
                });
                FirebaseFirestore.instance
                    .collection('jobPost')
                    .doc(doc["jobId"].toString())
                    .delete();
                final skillList = doc["skillname"];
                print(skillList);
                for (var i = 0; i < skillList.length; i++) {
                  FirebaseFirestore.instance
                      .collection('skills')
                      .doc('1704364368862')
                      .update({skillList[i]: FieldValue.increment(-1.0)})
                      .then((value) {})
                      .onError((error, stackTrace) => null);
                }
              },
            ))
        .toList();
  }

  getJobDetailItems(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data!.docs
        .map((doc) => TableRow(children: [
              Text(doc['recruiter']),
              Text("${doc['jobposted']}"),
              Text(doc['jobfilled'].toString()),
              Text("${doc['jobposted'] - doc['jobfilled']}")
            ]))
        .toList();
  }
}
