@file:JvmName("Fetcher")

import com.google.cloud.firestore.Firestore
import com.google.cloud.firestore.FirestoreOptions
import org.json.JSONObject
import java.awt.Toolkit
import java.awt.datatransfer.StringSelection
import java.lang.StringBuilder

val eventName = "io2018"
var wait = true
val db: Firestore by lazy {
  val options = FirestoreOptions.getDefaultInstance().toBuilder().setProjectId("gdg-charottloe-meetup-rsvp").build()
  options.service
}

fun main(args: Array<String>) {

  if (args.size != 1) {
    print("err")
    return
  } else {
    when (args[0]) {
      "syncRsvps" -> MeetupSync.sync()
      "fetchAttendees" -> FetchAttendees.fetch()
    }
  }
}

object FetchAttendees {
  fun fetch() {
    val query = db
        .collection("events")
        .document(eventName)
        .collection("rsvps")
        .whereEqualTo("attending", true)

    val docs = query.get().get().documents

    StringSelection(with(StringBuilder()) {
      for (d in docs) {
        append(d.get("name"))
        append(System.lineSeparator())
      }

      toString()
    }).run {
      Toolkit.getDefaultToolkit().systemClipboard.setContents(this, this)
    }
  }
}

object MeetupSync {
  fun sync() {
//https://api.meetup.com/2/rsvps?offset=0&format=json&event_id=249472955&photo-host=public&page=75&fields=&order=event&desc=false&sig_id=155262402&sig=1bf9a75b2981f2d0e83ff277334362e161e8acc3

    val eventRsvpRef = db.collection("events").document(eventName).collection("rsvps")
    val obj = JSONObject(this.javaClass.getResource("/attendees.json").readText())
    obj.getJSONArray("results").run {
      val batch = db.batch()

      for (i in 0 until length()) {
        getJSONObject(i).run {
          val member = getJSONObject("member")
          val rsvpMap = mapOf(
              "name" to member.getString("name"),
              "profilePic" to optJSONObject("member_photo")?.optString("photo_link"),
              "attending" to false,
              "meetupRsvp" to true
          )
          val rsvpRef = eventRsvpRef.document()
          batch.set(rsvpRef, rsvpMap)
        }
      }

      batch.commit().get()
    }

    wait = false
  }
}

