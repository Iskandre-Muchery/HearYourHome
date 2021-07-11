import 'package:app/models.dart';
import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<NotificationObject> items = [
    NotificationObject("You are now connected", Colors.green)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildBar(context),
        body: new Container(child: _buildNotificationsListView(items)));
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      title: new Text("HearYourHome"),
      centerTitle: true,
    );
  }

  Widget _buildNotificationsListView(List<NotificationObject> notifications) {
    return ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return Dismissible(
              key: UniqueKey(),
              onDismissed: (direction) {
                setState(() {
                  notifications.removeAt(index);
                });
              },
              background: Container(
                color: Colors.red,
                child: Icon(Icons.delete),
              ),
              child: Align(
                alignment: Alignment.center,
                child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.1,
                    child: _buildNotification(
                        notification.text, notification.color)),
              ));
        });
  }

  Widget _buildNotification(String text, Color color) {
    String timeDisplayed = DateTime.now().toString();
    timeDisplayed = timeDisplayed.substring(0, timeDisplayed.length - 7);

    return Card(
      color: Colors.green,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              timeDisplayed,
              style: TextStyle(fontSize: 14, color: Colors.black),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Text("You are now connected",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
