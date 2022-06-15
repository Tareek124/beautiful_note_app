// ignore_for_file: prefer_const_constructors

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:note_app/database/database_provider.dart';
import '../model/user_model.dart';
import 'edit_note.dart';
import 'new_note.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<UserModel> userList = [];

  Future<List<UserModel>> _getData() async {
    userList = await DatabaseProvider.instance.readAllElements();
    return userList.isEmpty ? [] : userList;
  }

  createListView(BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.hasData) {
      userList = snapshot.data;
    }

    return userList.isNotEmpty
        ? ListView.builder(
            itemCount: userList.length,
            itemBuilder: (context, index) {
              return Dismissible(
                secondaryBackground: Container(
                  color: Colors.red,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 300),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        Icon(
                          Icons.delete,
                          // color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
                key: UniqueKey(),
                background: Container(
                  color: Colors.red,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 300),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        Icon(
                          Icons.delete,
                          // color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
                onDismissed: (direction) {
                  DatabaseProvider.instance.deleteUser(userList[index].id);
                  setState(() {});
                },
                child: _buildItem(userList[index], index),
              );
            })
        : Center(
            child: Text(
            "No Notes To Show",
            style: TextStyle(
              fontSize: 25,
              // color: Colors.black.withOpacity(0.6),
              fontWeight: FontWeight.bold,
            ),
          ));
  }

  _buildItem(UserModel model, int index) {
    return Card(
      child: ListTile(
        title: Wrap(
          direction: Axis.horizontal,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  model.title!,
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  model.desc!,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 15),
                Wrap(
                  children: [
                    const Icon(Icons.date_range_outlined, color: Colors.cyan),
                    const Padding(padding: EdgeInsets.only(right: 10)),
                    Text(
                      DateFormat.yMMMEd().format(model.date!),
                      style: const TextStyle(fontSize: 18, color: Colors.cyan),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        trailing: IconButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(
                    builder: (context) => EditNote(
                        idIndex: model.id!,
                        initialDate: model.date!,
                        initialTitle: model.title!,
                        initialDesc: model.desc!)))
                .then((value) => setState(() {}));
          },
          icon: const Icon(Icons.edit),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xffFFF5EE),
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .push(
                      MaterialPageRoute(builder: (context) => const NewNote()))
                  .then((value) => setState(() {}));
            },
            child: const Text(
              "Add Note",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
        centerTitle: true,
        title: Text("Best Note App"),
      ),
      // PreferredSize(
      //   child: Container(
      //     // padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      //     child: Padding(
      //       padding: const EdgeInsets.only(left: 30.0, top: 20.0, bottom: 20.0),
      //       child: Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //         children: [
      //           Text(
      //             'Best Note App',
      //             style: TextStyle(
      //               fontSize: 22.0,
      //               fontWeight: FontWeight.w500,
      //               // color: Colors.white,
      //             ),
      //           ),
      //           TextButton(
      //             onPressed: () {
      //               Navigator.of(context)
      //                   .push(MaterialPageRoute(
      //                       builder: (context) => const NewNote()))
      //                   .then((value) => setState(() {}));
      //             },
      //             child: const Text(
      //               "Add Note",
      //               style: TextStyle(
      //                   // color: Colors.black,
      //                   fontSize: 15,
      //                   fontWeight: FontWeight.bold),
      //             ),
      //           ),
      //         ],
      //       ),
      //     ),
      //     decoration: BoxDecoration(
      //         gradient: LinearGradient(
      //           begin: Alignment.topLeft,
      //           end: Alignment.bottomRight,

      //           // ignore: prefer_const_literals_to_create_immutables
      //           colors: [
      //             // Colors.cyan,
      //             // Colors.indigo,
      //             // Color(0xffd46a06),
      //           ],
      //         ), // ignore: prefer_const_literals_to_create_immutables
      //         // ignore: prefer_const_literals_to_create_immutables
      //         boxShadow: [
      //           BoxShadow(
      //             // color: Colors.black,
      //             blurRadius: 10.0,
      //             spreadRadius: 1.0,
      //           )
      //         ]),
      //   ),
      //   preferredSize: Size(MediaQuery.of(context).size.width, 150.0),
      // ),
      body: FutureBuilder<List<UserModel>>(
        future: _getData(),
        builder: (context, snapshot) {
          return createListView(context, snapshot);
        },
      ),
    );
  }
}
