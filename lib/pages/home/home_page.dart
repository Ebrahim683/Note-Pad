
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_pad/pages/notes/add_note.dart';
import 'package:note_pad/pages/notes/note_page.dart';
import 'package:note_pad/pages/widget/grid_widget.dart';
import 'package:note_pad/util/storage_util.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF000633),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'My Notes',
          style: TextStyle(color: Colors.grey),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                onPressed: () {
                  StorageUtil.logOut();
                },
                icon: const Icon(
                  Icons.logout,
                  color: Colors.grey,
                )),
          ),
        ],
      ),
      backgroundColor: const Color(0xFF000633),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: const [
              Padding(
                padding: EdgeInsets.only(left: 15),
                child: Text(
                  'Your recent notes',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('notes')
                  .doc(StorageUtil.getUid())
                  .collection('myNotes')
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator(color: Colors.white));
                }
                if (snapshot.hasData) {
                  return GridView.builder(
                    itemBuilder: (context, index) {
                      var data = snapshot.data!.docs[index];
                      return gridWidget(() {
                        //onTap
                        Get.to(NotePage(data));
                      }, () {
                        //onLongTap
                        Get.defaultDialog(
                          title: 'Delete',
                          content:
                              Text("Do you want to delete ${data['title']}?"),
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                InkWell(
                                  onTap: () {
                                    deleteNote(data.id, data['title']);
                                    Get.back();
                                  },
                                  child: const Text('YES'),
                                ),
                                InkWell(
                                  onTap: () {
                                    Get.back();
                                  },
                                  child: const Text('NO'),
                                ),
                              ],
                            ),
                          ],
                        );
                      }, data);
                    },
                    itemCount: snapshot.data!.docs.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                  );
                } else {
                  return Center(
                    child: Text(
                      snapshot.error.toString(),
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  );
                }
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.red[300],
        onPressed: () {
          Get.to(const AddNote());
        },
        label: const Text('Add Note'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  void deleteNote(id, String title) {
    FirebaseFirestore.instance
        .collection('notes')
        .doc(StorageUtil.getUid())
        .collection('myNotes')
        .doc(id)
        .delete();
    Get.snackbar('Success', 'Deleted $title',
        snackPosition: SnackPosition.BOTTOM, colorText: Colors.white);
  }
}
