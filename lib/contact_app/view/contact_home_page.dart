import 'package:contact_app/contact_app/controller/contact_providerers.dart';
import 'package:contact_app/contact_app/view/add_contact_page.dart';
import 'package:contact_app/contact_app/view/update_contact_page.dart';
// import 'package:contact_app/contact_app/model/contact_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ContactHomePage extends ConsumerWidget {
  final TextEditingController searchCon = TextEditingController();

  ContactHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use mayHaveChanged to handle UnimplementedError
    final contacts = ref.watch(contactsPro);

    return Scaffold(
      appBar: AppBar(
        title: const Text("CONTACT APP"),
        centerTitle: true,
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(56.0),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextField(
                controller: searchCon,
                decoration: InputDecoration(
                    hintText: 'Search...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none),
                    filled: true,
                    fillColor: Colors.white),
                onChanged: (query) {
                  ref.read(contactsPro.notifier).searchCon(query);
                },
              ),
            )),
      ),
      body: contacts.when(
          data: (data) => data.isEmpty
              ? const Center(child: Text('No contacts found'))
              : ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (c, i) {
                    final con = data[i];

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 80,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            border:
                                Border.all(width: 0.3, color: Colors.black)),
                        child: ListTile(
                          title: Text(con.name),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(con.number),
                              Text(con.email),
                              // Text(con.id.toString())
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                UpdateContact(contact: con)));
                                  },
                                  icon: const Icon(Icons.edit)),
                              IconButton(
                                  onPressed: () {
                                    ref
                                        .read(contactsPro.notifier)
                                        .deleteCon(con);
                                  },
                                  icon: const Icon(Icons.delete)),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
          error: (error, StackTrace) {
            return Center(
              child: Text(error.toString()),
            );
          },
          loading: () {
            return const CircularProgressIndicator();
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => AddContact()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
