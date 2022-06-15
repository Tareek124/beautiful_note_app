import 'package:note_app/database/constants.dart';

class UserModel {
  final int? id;
  final String? title;
  final String? desc;
  final DateTime? date;

  const UserModel({this.id, this.title, this.desc, this.date});

  Map<String, dynamic> toMap() => {
        columnID: id,
        columnTitle: title,
        columnDesc: desc,
        columnDate: date.toString(),
      };

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map[columnID],
      title: map[columnTitle],
      desc: map[columnDesc],
      date: DateTime.parse(map[columnDate]),
    );
  }
}
