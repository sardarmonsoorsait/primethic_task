import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:primethic_task/feed_page.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController nameRController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController webController = TextEditingController();
  TextEditingController imageController = TextEditingController();

  final items = [
    'dotnet',
    'dart',
    'elixer',
    'erlang',
    'firebase',
    'flutter',
    'golang',
    'java',
    'mongodb',
    'mysql',
    'oracle',
    'python'
  ];

  List<String> skillList = [];

  String counter = 'Please add some data';
  bool isLoading = false;
  final firestoreJobPost = FirebaseFirestore.instance.collection('jobPost');
  final firestoreRecruiter = FirebaseFirestore.instance.collection('recruiter');
  final firestoreJobCompletion =
      FirebaseFirestore.instance.collection('jobCompletion');
  final firestoreSkills = FirebaseFirestore.instance.collection('skills');

  showDialog() {
    Get.dialog(Dialog(
      child: Container(
          width: 200,
          height: 400,
          color: Colors.amber,
          child: Column(
            children: [
              DropdownButtonFormField(
                  items: recData!.map((e) {
                    return DropdownMenuItem(
                        value: e, child: Text(e.toString()));
                  }).toList(),
                  onChanged: (value) {
                    nameController.text = value.toString();
                  }),
              DropdownButtonFormField(
                  items: items.map((e) {
                    return DropdownMenuItem(
                        value: e, child: Text(e.toString()));
                  }).toList(),
                  onChanged: (value) {
                    skillList.add(value!);
                    print(skillList.toString());
                  }),
              DropdownButtonFormField(
                  items: items.map((e) {
                    return DropdownMenuItem(
                        value: e, child: Text(e.toString()));
                  }).toList(),
                  onChanged: (value) {
                    skillList.add(value!);

                    print(skillList.toString());
                  }),
              DropdownButtonFormField(
                  items: items.map((e) {
                    return DropdownMenuItem(
                        value: e, child: Text(e.toString()));
                  }).toList(),
                  onChanged: (value) {
                    skillList.add(value!);
                    print(skillList.toString());
                  }),
              DropdownButtonFormField(
                  items: items.map((e) {
                    return DropdownMenuItem(
                        value: e, child: Text(e.toString()));
                  }).toList(),
                  onChanged: (value) {
                    skillList.add(value!);
                    print(skillList.toString());
                  }),
              DropdownButtonFormField(
                  items: items.map((e) {
                    return DropdownMenuItem(
                        value: e, child: Text(e.toString()));
                  }).toList(),
                  onChanged: (value) {
                    skillList.add(value!);
                    print(skillList.toString());
                  }),
              ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    final today = DateTime.now();
                    final id = DateTime.now().millisecondsSinceEpoch;
                    firestoreJobPost.doc(id.toString()).set({
                      'expiry': today.add(const Duration(minutes: 2)).toString(),
                      'jobId': id.toString(),
                      'postingdate': today.toString(),
                      'recId': nameController.text,
                      'recruiter': nameController.text,
                      'skillname': skillList
                    }).then((value) {
                      counter = 'data updated';
                      setState(() {
                        isLoading = false;
                      });
                    }).onError((error, stackTrace) {});
                    updateJobDetail(id);

                    // FirebaseFirestore.instance
                    //     .collection('jobdetails')
                    //     .doc(nameController.text)
                    //     .set({
                    //   'recruiter': nameController.text,
                    //   'jobposted': FieldValue.increment(1),
                    //   'jobId': id.toString(),
                    //   'jobfilled': 0
                    // });
                    for (var i = 0; i < skillList.length; i++) {
                      firestoreSkills
                          .doc('1704364368862')
                          .update({skillList[i]: FieldValue.increment(1.0)})
                          .then((value) {})
                          .onError((error, stackTrace) => null);
                    }
                    emptySkillList();
                  },
                  child: Text('publish'))
            ],
          )),
    ));
  }

  updateJobDetail(int id) async {
    var collectionRef = FirebaseFirestore.instance.collection('jobdetails');
    var doc = await collectionRef.doc(nameController.text).get();
    if (doc.exists) {
      FirebaseFirestore.instance
          .collection('jobdetails')
          .doc(nameController.text)
          .update({
        'recruiter': nameController.text,
        'jobposted': FieldValue.increment(1),
        'jobId': id.toString(),
      });
    } else {
      FirebaseFirestore.instance
          .collection('jobdetails')
          .doc(nameController.text)
          .set({
        'recruiter': nameController.text,
        'jobposted': FieldValue.increment(1),
        'jobId': id.toString(),
        'jobfilled': 0
      });
    }
  }

  emptySkillList() {
    skillList = [];
  }

  getData() {
    DocumentReference Ref =
        FirebaseFirestore.instance.collection('skills').doc('1704364368862');
    Ref.snapshots().listen((event) {
      data = (event.data() as Map<String, dynamic>);
      setState(() {});
      print(data);
    });
  }

 Future<void> getRecData() async {
    CollectionReference recRef =
        FirebaseFirestore.instance.collection('recruiter');

    QuerySnapshot querySnapshot = await recRef.get();

    final allData = querySnapshot.docs.map((doc) => doc['name']).toList();

    setState(() {
      recData = allData;
    });

    // for (var element in allData) {
    //   recRef.add(element);
    //   setState(() {});

    // }
    print(allData);
  }
  // [{website: www.asdf.cim, address: chennai, name: sait, logo: sgsbdsfeheh, recId: 1704381878453}, {website: www primethic.com, address: nungampakkam, name: primethic, logo: acdndhfjfj, recId: 1704382952076}]

  showDialogForRecruiter() {
    Get.dialog(Dialog(
      child: Container(
          width: 200,
          height: 400,
          color: Colors.amber,
          child: Column(
            children: [
              TextField(
                decoration:
                    InputDecoration(hintText: 'Enter the recruiter name'),
                controller: nameRController,
              ),
              TextField(
                decoration: InputDecoration(hintText: 'Enter address'),
                controller: addressController,
              ),
              TextField(
                decoration: InputDecoration(hintText: 'Enter website'),
                controller: webController,
              ),
              TextField(
                decoration: InputDecoration(hintText: 'Enter Image name'),
                controller: imageController,
              ),
              ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    String id = nameRController.text;

                    await firestoreRecruiter.doc(id).set({
                      'name': nameRController.text,
                      'recId': id,
                      'address': addressController.text,
                      'website': webController.text,
                      'logo': imageController.text,
                    }).then((value) {
                      setState(() {
                        isLoading = false;
                      });
                    }).onError((error, stackTrace) {});
                    // for (var i = 0; i < skillList.length; i++) {
                    //   await firestoreSkills
                    //       .doc('1704364368862')
                    //       .update({skillList[i]: FieldValue.increment(1.0)})
                    //       .then((value) {})
                    //       .onError((error, stackTrace) => null);
                    // }
                  },
                  child: Text('save recruiter'))
            ],
          )),
    ));
  }

  var data;
  List<dynamic>? recData;

  @override
  void initState() {
    // TODO: implement initState
    getData();
    getRecData();
    super.initState();
  }

//dart: 3.0, python: 3.0, flutter: 3.0, oracle: 1, java: 1, golang: 1, erlang: 1, .net: 1, mysql: 3.0, firebase: 1, mongodb: 3.0, elixer: 1
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: isLoading || data==null
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: getRecData,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Jobs Available for skills'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Table(
                        border: TableBorder.all(),
                        children: [
                          TableRow(children: [
                            Text('Dart'),
                            Center(
                                child: Text(
                                    data['dart'].toString().split('.')[0] ??
                                        ''))
                          ]),
                          TableRow(children: [
                            Text('Python'),
                            Center(
                                child: Text(
                                    data['python'].toString().split('.')[0] ??
                                        ''))
                          ]),
                          TableRow(children: [
                            Text('Flutter'),
                            Center(
                                child: Text(
                                    data['flutter'].toString().split('.')[0] ??
                                        ''))
                          ]),
                          TableRow(children: [
                            Text('Oracle'),
                            Center(
                                child: Text(
                                    data['oracle'].toString().split('.')[0] ??
                                        ''))
                          ]),
                          TableRow(children: [
                            Text('Java'),
                            Center(
                                child: Text(
                                    data['java'].toString().split('.')[0] ??
                                        ''))
                          ]),
                          TableRow(children: [
                            Text('Golang'),
                            Center(
                                child: Text(
                                    data['golang'].toString().split('.')[0] ??
                                        ''))
                          ]),
                          TableRow(children: [
                            Text('Erlang'),
                            Center(
                                child: Text(
                                    data['erlang'].toString().split('.')[0] ??
                                        ''))
                          ]),
                          TableRow(children: [
                            Text('dotNet'),
                            Center(
                                child: Text(
                                    data['dotnet'].toString().split('.')[0] ??
                                        ''))
                          ]),
                          TableRow(children: [
                            Text('Mysql'),
                            Center(
                                child: Text(
                                    data['firebase'].toString().split('.')[0] ??
                                        ''))
                          ]),
                          TableRow(children: [
                            Text('Firebase'),
                            Center(
                                child: Text(
                                    data['mongodb'].toString().split('.')[0] ??
                                        ''))
                          ]),
                          TableRow(children: [
                            Text('MongoDb'),
                            Center(
                                child: Text(
                                    data['dart'].toString().split('.')[0] ??
                                        ''))
                          ]),
                          TableRow(children: [
                            Text('Elixer'),
                            Center(
                                child: Text(
                                    data['elixer'].toString().split('.')[0] ??
                                        ''))
                          ]),
                        ],
                      ),
                    ),
                    SizedBox(height: 200,),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => FeedPage()));
                        },
                        child: Text('go to feed page')),
                          SizedBox(height: 150,),
                  ],
                ),
              ),
            ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FloatingActionButton(
            heroTag: '123',
            onPressed: showDialog,
            tooltip: 'Increment',
            child: Column(
              children: [const Icon(Icons.add), Text('job')],
            ),
          ),
          FloatingActionButton(
            onPressed: showDialogForRecruiter,
            tooltip: 'Increment',
            child: Column(
              children: [const Icon(Icons.add), Text('recruiter')],
            ),
          )
        ],
      ),
    );
  }
}
