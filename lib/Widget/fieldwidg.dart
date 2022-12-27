import 'package:flutter/material.dart';

Padding carfield(
    {required String libelle,
    required TextEditingController controller,
    required bool enable}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: ListTile(
        shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.grey.shade400),
            borderRadius: const BorderRadius.all(
              Radius.circular(5),
            )),
        title: Row(
          children: [
            Text(
              libelle,
              style: const TextStyle(color: Colors.green),
            ),
            const SizedBox(width: 10),
            Expanded(
                child: TextField(
              controller: controller,
              style: const TextStyle(fontWeight: FontWeight.w400),
              decoration: InputDecoration(
                enabled: enable,
                border: InputBorder.none,
              ),
            )),
          ],
        )),
  );
}
