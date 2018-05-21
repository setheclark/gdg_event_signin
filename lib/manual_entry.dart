import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_signin/attendee_data.dart';
import 'package:flutter/material.dart';

class ManualEntryPage extends StatefulWidget {
  final CollectionReference rsvpRef;

  ManualEntryPage(this.rsvpRef);

  void storeAttendee(BuildContext context, String firstName, String lastName) {
    var a = Attendee.fromEntry(rsvpRef.document(), firstName, lastName);

    a.isAttending = true;
    a.save();
    print(a.reference.documentID);
    Navigator.of(context).pop(a);
  }

  @override
  State<StatefulWidget> createState() => _ManualEntryState();
}

class _ManualEntryState extends State<ManualEntryPage> {
  final formKey = GlobalKey<FormState>();
  String _firstName;
  String _lastName;

  void _signIn() {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();

      widget.storeAttendee(context, _firstName, _lastName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Enter Name"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: "First Name",
                ),
                validator: (val) => val.length == 0 ? 'Not valid' : null,
                onSaved: (val) => _firstName = val,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Last Name",
                ),
                validator: (val) => val.length == 0 ? 'Not valid' : null,
                onSaved: (val) => _lastName = val,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: RaisedButton(
                  onPressed: _signIn,
                  child: Text("Sign In"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
