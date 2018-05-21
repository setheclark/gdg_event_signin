import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_signin/attendee_data.dart';
import 'package:event_signin/globals.dart' as globals;
import 'package:event_signin/manual_entry.dart';
import 'package:event_signin/rsvp_list_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final CollectionReference rsvpRef = Firestore.instance
      .collection(globals.EVENTS_COLLECTION)
      .document(globals.EVENT_NAME)
      .collection(globals.RSVP_COLLECTION);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(),
      body: Center(
        child: SizedBox(
          child: Column(
            children: <Widget>[
              Text("Did you RSVP on Meetup.com?"),
              Padding(
                child: RaisedButton(
                  child: Text("Yes"),
                  onPressed: () {
                    showRsvpList(context);
                  },
                ),
                padding: const EdgeInsets.symmetric(vertical: 16.0),
              ),
              RaisedButton(
                child: Text("No"),
                onPressed: () {
                  showManualEntry(context);
                },
              )
            ],
          ),
          width: 200.0,
          height: 300.0,
        ),
      ),
    );
  }

  void showManualEntry(BuildContext context) async {
    Attendee a = await Navigator.of(context).push(MaterialPageRoute<Attendee>(
        builder: (context) => ManualEntryPage(rsvpRef)));

    if (a != null) {
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          duration: Duration(seconds: 3),
          content:
              Text("${a.name}, you're signed in.  Please enjoy the event!"),
        ),
      );
    }
  }

  void showRsvpList(BuildContext context) async {
    Attendee a = await Navigator.of(context).push(
          MaterialPageRoute<Attendee>(
              builder: (context) => RsvpListPage(rsvpRef)),
        );

    if (a != null) {
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          duration: Duration(seconds: 3),
          content:
              Text("${a.name}, you're signed in.  Please enjoy the event!"),
        ),
      );
    }
  }
}
