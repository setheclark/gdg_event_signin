import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Attendee {
  final DocumentReference reference;
  final String name;
  final String profilePic;
  bool isAttending;
  final bool meetupRsvp;

  Attendee(this.reference, this.name, this.profilePic, this.isAttending,
      this.meetupRsvp);

  factory Attendee.fromSnapshot(DocumentSnapshot snapshot) => Attendee(
      snapshot.reference,
      snapshot.data['name'],
      snapshot.data['profilePic'],
      snapshot.data['attending'],
      snapshot.data['meetupRsvp']);

  factory Attendee.fromEntry(
          DocumentReference docRef, String fName, String lName) =>
      Attendee(docRef, "$fName $lName", null, false, false);

  Map<String, dynamic> toMap() => {
        "name": name,
        "profilePic": profilePic,
        "attending": isAttending,
        "meetupRsvp": meetupRsvp
      };

  void save() {
    reference.setData(toMap());
  }
}

class AttendeeList extends StatelessWidget {
  final List<Attendee> _attendees;
  final AttendeeClicked itemTapped;

  AttendeeList(this._attendees, this.itemTapped);

  @override
  Widget build(BuildContext context) {
    return new ListView(
      children: _buildAttendeesList(),
    );
  }

  List<AttendeeListItem> _buildAttendeesList() {
    return _attendees
        .map((attendee) => new AttendeeListItem(attendee, itemTapped))
        .toList();
  }
}

typedef void AttendeeClicked(Attendee a);

class AttendeeListItem extends StatelessWidget {
  final Attendee _attendee;
  final AttendeeClicked onTap;

  AttendeeListItem(this._attendee, this.onTap);

  @override
  Widget build(BuildContext context) {
    var avatar = _attendee.profilePic != null
        ? CircleAvatar(
            radius: 20.0,
            backgroundImage: NetworkImage(
              _attendee.profilePic,
            ),
          )
        : null;
    return Card(
      child: ListTile(
        onTap: () => onTap(_attendee),
        leading: avatar,
        title: Text(
          _attendee.name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
