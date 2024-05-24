import 'dart:async';

import 'package:contact_app/contact_app/controller/service/contact_service.dart';
import 'package:contact_app/contact_app/model/contact_box.dart';
import 'package:contact_app/contact_app/model/contact_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final objectboxPro = FutureProvider<ObjectBox>((ref) async {
  final obj = await ObjectBox.create();
  return obj;
});

final contactServicePro = Provider<ContactService>((ref) {
  final obj = ref.watch(objectboxPro).maybeWhen(
        data: (objectBox) => objectBox,
        orElse: () => null,
      );
  if (obj == null) throw "";
  return ContactService(obj);
});

final contactsPro =
    AsyncNotifierProvider<ContactNoteifier, List<ContactModel>>(() {
  return ContactNoteifier();
});

class ContactNoteifier extends AsyncNotifier<List<ContactModel>> {
  late final ContactService contactService;
  @override
  Future<List<ContactModel>> build() async {
    contactService = ref.watch(contactServicePro);
    return await loadCon();
  }

  //connecting db and api fully connected(get all contacts)
  Future<List<ContactModel>> loadCon() async {
    final contact1 = contactService.getContactsDB();
    if (contact1.isEmpty) {
      final apiCon = await contactService.getAll();
      for (final contact2 in apiCon) {
        contactService.addContactDB(contact2);
      }
      return apiCon;
    } else {
      return contact1;
    }
  }

  //add contact connects with api and db functions
  Future<void> addCon(ContactModel con) async {
    await contactService.addContact(
        name: con.name, number: con.number, email: con.email);
    contactService.addContactDB(con);
    state = AsyncData([...state.value!, con]);
  }

  //update contact connects with api and db functions
  Future<void> updateCon(ContactModel con) async {
    await contactService.updatecontact(con.id,
        name: con.name, number: con.number, email: con.email);
    contactService.updateContactDB(con);
    state = AsyncData([
      for (final exCon in state.value!)
        if (exCon.id == con.id) con else exCon
    ]);
  }

  //delete contact connects with api and db functions
  Future<void> deleteCon(ContactModel con) async {
    await contactService.deletecontact(con.id);
    contactService.deleteContactDB(con.id);
    state = AsyncData(
        state.value!.where((contact) => contact.id != con.id).toList());
  }

  //search bar connecting db and api
  void searchCon(String searchKey) {
    final result = contactService.searchContacts(searchKey);
    state = AsyncData(result);
  }
}
