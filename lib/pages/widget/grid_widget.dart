import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:note_pad/util/colors_util.dart';

Widget gridWidget(
    Function()? onTap, Function()? onLongPress, QueryDocumentSnapshot doc) {
  int color = int.parse(doc['color_id']);
  return InkWell(
    onTap: onTap,
    onLongPress: onLongPress,
    child: Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: ColorsUtil.cardsColor[color],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            doc['title'].toString(),
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 4),
          Text(
            doc['created'].toString(),
            style: const TextStyle(fontSize: 10),
          ),
          const SizedBox(height: 4),
          Text(
            doc['description'].toString(),
            style:
                const TextStyle(fontSize: 15, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    ),
  );
}
