import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:rx_dart/models/contact.dart';
import 'package:rxdart/rxdart.dart';

typedef _Snapshots = QuerySnapshot<Map<String, dynamic>>;
typedef _Document = DocumentReference<Map<String, dynamic>>;

extension Unwrap<T> on Stream<T?> {
  Stream<T> unwrap() => switchMap(
        (optional) async* {
          if (optional != null) {
            yield optional;
          }
        },
      );
}

@immutable
class ContactsBloc {
  final Sink<String?> userId;
  final Sink<Contact> createContact;
  final Sink<Contact> deleteContact;
  final Sink<void> deleteAllContacts;
  final Stream<Iterable<Contact>> contacts;
  final StreamSubscription<void> _createContactSubscription;
  final StreamSubscription<void> _deleteContactSubscription;
  final StreamSubscription<void> _deleteAllContactSubscription;

  void dispose() {
    userId.close();
    createContact.close();
    deleteContact.close();
    deleteAllContacts.close();
    _createContactSubscription.cancel();
    _deleteContactSubscription.cancel();
    _deleteAllContactSubscription.cancel();
  }

  const ContactsBloc._({
    required this.userId,
    required this.createContact,
    required this.deleteContact,
    required this.contacts,
    required this.deleteAllContacts,
    required StreamSubscription<void> deleteAllContactSubscription,
    required StreamSubscription<void> createContactSubscription,
    required StreamSubscription<void> deleteContactSubscription,
  })  : _createContactSubscription = createContactSubscription,
        _deleteContactSubscription = deleteContactSubscription,
        _deleteAllContactSubscription = deleteAllContactSubscription;

  factory ContactsBloc() {
    final backend = FirebaseFirestore.instance;

    final userId = BehaviorSubject<String?>();

    final contacts = userId.switchMap<_Snapshots>(
      (userId) {
        if (userId == null) {
          return const Stream<_Snapshots>.empty();
        } else {
          return backend.collection(userId).snapshots();
        }
      },
    ).map((snapshot) sync* {
      for (final document in snapshot.docs) {
        yield Contact.fromJson(
          document.data(),
          id: document.id,
        );
      }
    });

    final createContact = BehaviorSubject<Contact>();
    final createContactSubscription = createContact
        .switchMap(
          (contactToCreate) => userId
              .take(
                1,
              )
              .unwrap()
              .asyncMap(
                (userId) => backend
                    .collection(
                      userId,
                    )
                    .add(
                      contactToCreate.data,
                    ),
              ),
        )
        .listen(
          (event) {},
        );

    final deleteContact = BehaviorSubject<Contact>();
    final deleteContactSubscription = deleteContact
        .switchMap(
          (contactToDelete) => userId
              .take(
                1,
              )
              .unwrap()
              .asyncMap(
                (userId) => backend
                    .collection(
                      userId,
                    )
                    .doc(
                      contactToDelete.id,
                    )
                    .delete(),
              ),
        )
        .listen(
          (event) {},
        );

    final deleteAllContract = BehaviorSubject<void>();
    final StreamSubscription<void> deleteAllContactSubscription = deleteAllContract
        .switchMap(
          (_) => userId
              .take(
                1,
              )
              .unwrap()
              .asyncMap(
                (userId) => backend
                    .collection(
                      userId,
                    )
                    .get(),
              )
              .switchMap(
                (collection) => Stream.fromFutures(
                  collection.docs.map(
                    (doc) => doc.reference.delete(),
                  ),
                ),
              ),
        )
        .listen(
          (event) {},
        );

    return ContactsBloc._(
      userId: userId,
      createContact: createContact,
      deleteContact: deleteContact,
      contacts: contacts,
      deleteAllContacts: deleteAllContract,
      createContactSubscription: createContactSubscription,
      deleteContactSubscription: deleteContactSubscription,
      deleteAllContactSubscription: deleteAllContactSubscription,
    );
  }
}
