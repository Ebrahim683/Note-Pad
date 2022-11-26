// ignore_for_file: avoid_print

import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:note_pad/util/colors_util.dart';
import 'package:note_pad/util/storage_util.dart';

class AddNote extends StatefulWidget {
  const AddNote({super.key});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  int colorId = Random().nextInt(ColorsUtil.cardsColor.length);
  final titleController = TextEditingController();
  final desController = TextEditingController();
  final date = DateTime.now().toString();
  final fireStore = FirebaseFirestore.instance.collection('notes');
  bool isLoading = false;

  saveNote(String title, String description, String date) async {
    fireStore.doc(StorageUtil.getUid()).collection('myNotes').add({
      'color_id': colorId.toString(),
      'created': date,
      'description': description,
      'title': title
    }).then((value) {
      setState(() {
        isLoading = false;
      });
      Get.snackbar('Saved', '$title saved',
          snackPosition: SnackPosition.BOTTOM);
    }).onError((error, stackTrace) {
      print(error.toString());
      setState(() {
        isLoading = false;
      });
      Get.snackbar('Error', error.toString(),
          snackPosition: SnackPosition.BOTTOM);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsUtil.cardsColor[colorId],
      appBar: AppBar(
        backgroundColor: ColorsUtil.cardsColor[colorId],
        elevation: 0,
        title: const Text(
          'Add Note',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
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
      body: LoadingOverlay(
        isLoading: isLoading,
        progressIndicator:
            const CircularProgressIndicator(color: Colors.yellow),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  style: const TextStyle(fontWeight: FontWeight.w500),
                  controller: titleController,
                  decoration: const InputDecoration(
                    hintText: 'Title',
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  controller: desController,
                  decoration: const InputDecoration(
                    hintText: 'Note Content',
                    border: InputBorder.none,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red[300],
        onPressed: () {
          String title = titleController.text;
          String description = desController.text;
          if (title == '') {
            setState(() {
              isLoading = false;
            });
            Get.snackbar('Error', 'Enter title',
                snackPosition: SnackPosition.BOTTOM);
          } else if (description == '') {
            setState(() {
              isLoading = false;
            });
            Get.snackbar('Error', 'Enter content',
                snackPosition: SnackPosition.BOTTOM);
          } else {
            setState(() {
              isLoading = true;
            });
            saveNote(title, description, date);
          }
        },
        child: Icon(
          Icons.done,
          color: ColorsUtil.cardsColor[colorId],
        ),
      ),
    );
  }
}
