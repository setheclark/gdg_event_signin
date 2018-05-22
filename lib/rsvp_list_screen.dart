import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_signin/attendee_data.dart';
import 'package:event_signin/globals.dart' as globals;
import 'package:flutter/material.dart';

class RsvpListPage extends StatelessWidget {
  final CollectionReference rsvpRef;

  RsvpListPage(this.rsvpRef);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Select from list"),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: rsvpRef
            .where(globals.ATTENDING_KEY, isEqualTo: false)
            .where(globals.MEETUP_RSVP_KEY, isEqualTo: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return const Text('Loading...');
          var attendees = snapshot.data.documents
              .map((snapshot) => Attendee.fromSnapshot(snapshot))
              .toList();

          return AttendeeList(
              attendees, (a) => showConfirmationDialog(context, a));
        },
      ),
    );
  }

  void showConfirmationDialog(BuildContext context, Attendee a) async {
    if (await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: AlertDialog(
              title: Text("Sign in?"),
              content: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  a.profilePic != null
                      ? CircleAvatar(
                          radius: 50.0,
                          backgroundImage: NetworkImage(
                            a.profilePic,
                          ),
                        )
                      : const SizedBox(),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(
                      a.name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text("No"),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                FlatButton(
                  child: Text("Yes"),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                )
              ],
            ),
          );
        })) {
      a.isAttending = true;
      a.save();
      print(a.reference.documentID);
      Navigator.of(context).pop(a);
    }
  }
}
