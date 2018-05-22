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
      resizeToAvoidBottomPadding: false,
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Sign In'),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/gdg_charlotte_logo.png'),
              Center(
                child: Text(
                  "Did you RSVP on Meetup.com?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                  ),
                ),
              ),
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
          width: 300.0,
        ),
      ),
    );
  }

  void showManualEntry(BuildContext context) async {
    Attendee a = await Navigator.of(context).push(MaterialPageRoute<Attendee>(
        builder: (context) => ManualEntryPage(rsvpRef)));

    if (a != null) {
      showSuccessSnackbar(a);
    }
  }

  void showRsvpList(BuildContext context) async {
    Attendee a = await Navigator.of(context).push(
          MaterialPageRoute<Attendee>(
              builder: (context) => RsvpListPage(rsvpRef)),
        );

    if (a != null) {
      showSuccessSnackbar(a);
    }
  }

  void showSuccessSnackbar(Attendee a) {
    scaffoldKey.currentState.showSnackBar(
      SnackBar(
        duration: Duration(seconds: 3),
        content: Text(
          "${a.name}, you're signed in.  Please enjoy the event!",
          style: TextStyle(
            fontSize: 18.0,
          ),
        ),
      ),
    );
  }
}
