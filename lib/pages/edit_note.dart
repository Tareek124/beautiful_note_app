// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

import '../database/database_provider.dart';
import '../model/user_model.dart';

class EditNote extends StatefulWidget {
  String initialTitle;
  String initialDesc;
  DateTime initialDate;
  int idIndex;
  EditNote(
      {Key? key,
      required this.initialDate,
      required this.initialTitle,
      required this.idIndex,
      required this.initialDesc})
      : super(key: key);

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  String? title = "";
  String? desc = "";
  DateTime? date = DateTime.now();
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  @override
  void initState() {
    super.initState();
    titleController.text = widget.initialTitle;
    descController.text = widget.initialDesc;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFF5EE),
      appBar: PreferredSize(
        child: Container(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: Padding(
            padding: const EdgeInsets.only(left: 30.0, top: 20.0, bottom: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                const Text(
                  'Edit Note',
                  style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
              ],
            ),
          ),
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                // ignore: prefer_const_literals_to_create_immutables
                colors: [
                  Colors.cyan,
                  Colors.indigo,
                  // Color(0xffd46a06),
                ],
              ),
              // ignore: prefer_const_literals_to_create_immutables
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 10.0,
                  spreadRadius: 1.0,
                )
              ]),
        ),
        preferredSize: Size(MediaQuery.of(context).size.width, 150.0),
      ),
      body: Form(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 25, 10, 10),
          child: Column(children: [
            TextFormField(
              controller: titleController,
              style: const TextStyle(
                  fontSize: 18,
                  color: Color(0xff3e1969),
                  fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                icon: Icon(Icons.title),
                hintText: 'Note Title',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(11))),
              ),
              onChanged: (value) {
                title = value;
              },
            ),
            const SizedBox(
              height: 25,
            ),
            TextFormField(
              controller: descController,
              maxLines: 10,
              decoration: const InputDecoration(
                icon: Icon(Icons.note),
                hintText: 'Note Description',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(11))),
              ),
              onSaved: (value) {
                desc = value;
              },
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Pick Date-->",
                  style: TextStyle(fontSize: 21),
                ),
                TextButton(
                    onPressed: () {
                      DatePicker.showDatePicker(context,
                          showTitleActions: true,
                          minTime: DateTime.now(),
                          maxTime: DateTime(3000, 6, 7), onChanged: (date) {
                        print('change $date');
                      }, onConfirm: (value) {
                        print('confirm $value');
                        setState(() {
                          date = value;
                        });
                      }, currentTime: DateTime.now(), locale: LocaleType.ar);
                    },
                    child: const Icon(
                      Icons.date_range,
                      size: 35,
                    )),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        date == null
                            ? DateFormat.yMMMEd().format(widget.initialDate)
                            : DateFormat.yMMMEd().format(date!),
                        style: const TextStyle(
                          fontSize: 22,
                          color: Colors.blue,
                        )),
                    Container(
                        margin: const EdgeInsets.all(20),
                        width: 200,
                        height: 50,
                        child: ElevatedButton(
                            style: ButtonStyle(
                                elevation:
                                    MaterialStateProperty.all<double>(15),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(11),
                                        side: const BorderSide(
                                            color: Colors.cyan))),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.cyan)),
                            onPressed: () async {
                              DatabaseProvider.instance.updateUser(UserModel(
                                  id: widget.idIndex,
                                  title: titleController.text,
                                  desc: descController.text,
                                  date: date));
                              Navigator.pop(context);
                            },
                            // ignore: prefer_const_constructors
                            child: const Text(
                              "Edit",
                              // ignore: unnecessary_const
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 18),
                            )))
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
