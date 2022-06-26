import 'package:flutter/material.dart';
import 'package:rx_dart/dialogs/delete_contact.dialog.dart';
import 'package:rx_dart/models/contact.dart';
import 'package:rx_dart/type_definitions.dart';
import 'package:rx_dart/views/main_popup_menu_button.dart';

class ContactsListTile extends StatelessWidget {
  final Contact contact;
  final DeleteContactCallback deleteContactCallback;

  const ContactsListTile({
    Key? key,
    required this.contact,
    required this.deleteContactCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        contact.firstName + " " + contact.lastName,
      ),
      trailing: IconButton(
        onPressed: () async {
          final shouldDelete = await deleteContactDialog(context: context);

          if (shouldDelete) {
            deleteContactCallback(contact);
          }
        },
        icon: const Icon(
          Icons.delete,
        ),
      ),
    );
  }
}

class ContactsListView extends StatelessWidget {
  final Stream<Iterable<Contact>> contact;
  final LogoutCallback logoutCallback;
  final DeleteContactCallback deleteContactCallback;
  final GoToCreateContact goToCreateContact;
  final DeleteAccountCallback deleteAccountCallback;

  const ContactsListView({
    Key? key,
    required this.contact,
    required this.goToCreateContact,
    required this.deleteAccountCallback,
    required this.logoutCallback,
    required this.deleteContactCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Contacts List',
        ),
        actions: [
          MainPopupMenuButton(
            deleteAccountCallback: deleteAccountCallback,
            logoutCallback: logoutCallback,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          goToCreateContact();
        },
        child: const Icon(
          Icons.add,
        ),
      ),
      body: StreamBuilder<Iterable<Contact>>(
        stream: contact,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.done:
            case ConnectionState.active:
              final contacts = snapshot.requireData;

              return ListView.builder(
                itemCount: contacts.length,
                itemBuilder: (ctx, index) {
                  return ContactsListTile(
                    contact: contacts.elementAt(index),
                    deleteContactCallback: deleteContactCallback,
                  );
                },
              );
          }
        },
      ),
    );
  }
}
