import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ShowUploads extends StatefulWidget {
  String? userId;
  ShowUploads({Key? key, required this.userId}) : super(key: key);

  @override
  State<ShowUploads> createState() => _ShowUploadsState();
}

class _ShowUploadsState extends State<ShowUploads> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Images'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('user')
            .doc(widget.userId)
            .collection('images')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return (const Center(
              child: Text('No image uploaded'),
            ));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: ((context, index) {
                String url = snapshot.data!.docs[index]['downloadUrl'];
                return Image.network(
                  url,
                  height: 300,
                  fit: BoxFit.cover,
                );
              }),
            );
          }
        },
      ),
    );
  }
}
