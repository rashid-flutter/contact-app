// import 'dart:nativewrappers/_internal/vm/lib/core_patch.dart';

import 'package:contact_app/contact_app/model/contact_box.dart';
import 'package:contact_app/contact_app/model/contact_model.dart';
import 'package:contact_app/objectbox.g.dart';
import 'package:dio/dio.dart';

class ContactService {
  final dio = Dio(BaseOptions(baseUrl: "http://172.17.0.1:8080"));
  final ObjectBox obj;
  ContactService(this.obj);

  //api curd operations

  //1) get all contacts in api
  Future<List<ContactModel>> getAll() async {
    try {
      final res = await dio.post("/contact", data: {"method": "getContact"});
      // print(res.statusCode.toString());
      return (res.data as List).map((e) => ContactModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw "Error:$e";
    }
  }

// 2)add contacts in api
  Future<void> addContact({String? name, String? number, String? email}) async {
    try {
      await dio.post("/contact", data: {
        "method": "addContact",
        "name": name,
        "number": number,
        "email": email
      });
    } on DioException catch (e) {
      throw "Error:$e";
    }
  }

// 3)update contacts in api
  Future<void> updatecontact(int id,
      {String? name, String? number, String? email}) async {
    try {
      await dio.post("/contact", data: {
        "method": "updateContact",
        "id": id,
        "name": name,
        "number": number,
        "email": email
      });
    } on DioException catch (e) {
      throw "Error:$e";
    }
  }

  // 4)delete contacts in api
  Future<void> deletecontact(int id) async {
    try {
      await dio.post("/contact", data: {"method": "deleteContact", "id": id});
    } on DioException catch (e) {
      throw "Error:$e";
    }
  }

  // objectBox curd operations

  // 1)obj get contacts from db
  List<ContactModel> getContactsDB() {
    return ObjectBox.instance.contactBox.getAll();
  }

// 2)obj get contact from db
  ContactModel? getContactDB(int id) {
    return ObjectBox.instance.contactBox.get(id);
  }

  //add Contacts from db(data base)
  int addContactDB(ContactModel con) {
    return ObjectBox.instance.contactBox.put(con);
  }

//update Contacts from db
  void updateContactDB(ContactModel con) =>
      ObjectBox.instance.contactBox.put(con);

  // delete contacts from db
  bool deleteContactDB(int id) => ObjectBox.instance.contactBox.remove(id);

  //query contacts from db ()
  List<ContactModel> searchContacts(String? searchKey) {
    final contacts = ObjectBox.instance.contactBox
        .query(ContactModel_.name.contains(searchKey.toString()) |
            ContactModel_.number.contains(searchKey.toString()) |
            ContactModel_.email.contains(searchKey.toString()))
        .build()
        .find();
    return contacts;
  }
}
