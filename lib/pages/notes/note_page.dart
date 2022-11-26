import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_pad/util/colors_util.dart';

class NotePage extends StatefulWidget {
  final QueryDocumentSnapshot doc;
  const NotePage(this.doc, {super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  @override
  Widget build(BuildContext context) {
    int colorID = int.parse(widget.doc['color_id']);
    return Scaffold(
      backgroundColor: ColorsUtil.cardsColor[colorID],
      appBar: AppBar(
        backgroundColor: ColorsUtil.cardsColor[colorID],
        elevation: 0,
        title: Column(
          children: [
            Text(
              widget.doc['title'],
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.w700),
            ),
            Text(
              widget.doc['created'].toString(),
              style: const TextStyle(fontSize: 10, color: Colors.black),
            ),
          ],
        ),
        leading: InkWell(
          onTap: Get.back,
          child: Container(
            margin: const EdgeInsets.all(8.0),
            padding: const EdgeInsets.all(8.0),
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.doc['description'].toString(),
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
