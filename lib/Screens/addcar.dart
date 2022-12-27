import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:parking_app_version_1/Db/dbmanage.dart';
import 'package:parking_app_version_1/Models/vehicule.dart';
import 'package:parking_app_version_1/Screens/homepages.dart';
import 'package:parking_app_version_1/Widget/fieldwidg.dart';

class Addcar extends StatefulWidget {
  const Addcar({super.key});

  @override
  State<Addcar> createState() => _AddcarState();
}

class _AddcarState extends State<Addcar> {
  bool isadd = true;

  // CONDUCTEUR
  TextEditingController namecontroller = TextEditingController();
  TextEditingController numcontroller = TextEditingController();

  //VEHICULE
  TextEditingController matcontroller = TextEditingController();
  TextEditingController marqcontroller = TextEditingController();
  // TextEditingController colorcontroller = TextEditingController();
  bool ispark = true;

  Color pickerColor = const Color(0xff443a49);
  Color currentColor = const Color(0xff443a49);

// ValueChanged<Color> callback
  void changeColor(Color color) {
    setState(() => pickerColor = color);
    print(pickerColor.value);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeDateFormatting();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.offAll(() => const Homepages());
          },
          icon: const Icon(CupertinoIcons.back),
        ),
        title: const Text("Enregistrement"),
        actions: [
          IconButton(
              splashRadius: 25,
              onPressed: () async {
                print("save");
                setState(() {
                  isadd = false;
                });
                await Dbmanager()
                    .addCar(
                        car: Modelcar(
                            matricule: matcontroller.text,
                            marque: marqcontroller.text,
                            color: pickerColor.value.toString(),
                            nom: namecontroller.text,
                            numero: numcontroller.text,
                            time: DateFormat("E d/M/y \nà kk:mm", 'fr_CH')
                                .format(DateTime.now())))
                    .whenComplete(() {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Vehicule enregistré avec succès")));
                  Get.to(() => const Homepages());
                });
              },
              icon: const Icon(Icons.save))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Expanded(child: Divider()),
                Text(
                  "CONDUCTEUR",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black45,
                      letterSpacing: 3),
                ),
                Expanded(child: Divider()),
              ],
            ),
            carfield(
                libelle: 'Nom       :',
                controller: namecontroller,
                enable: isadd),
            carfield(
                libelle: 'Contact   :',
                controller: numcontroller,
                enable: isadd),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Expanded(child: Divider()),
                Text(
                  "VEHICULE",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black45,
                      letterSpacing: 3),
                ),
                Expanded(child: Divider()),
              ],
            ),
            carfield(
                libelle: 'Matricule :',
                controller: matcontroller,
                enable: isadd),
            carfield(
                libelle: 'Marque    :',
                controller: marqcontroller,
                enable: isadd),
            colorfield(libelle: 'Couleur   :', enable: isadd),
            /* Padding(
              padding: const EdgeInsets.all(8.0),
              child: SwitchListTile(
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.grey.shade400),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(5),
                    )),
                value: ispark,
                onChanged: ((value) {
                  setState(() {
                    ispark = value;
                  });
                }),
                title: const Text(
                  'Etat          :',
                  style: TextStyle(color: Colors.green),
                ),
                activeColor: Colors.green,
              ),
            ) */
          ],
        ),
      ),
    );
  }

  Padding colorfield({required String libelle, required bool enable}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
          shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.grey.shade400),
              borderRadius: const BorderRadius.all(
                Radius.circular(5),
              )),
          trailing: TextButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: ((context) {
                      return AlertDialog(
                          title: const Text('Pick a color!'),
                          content: SingleChildScrollView(
                            child: MaterialPicker(
                              pickerColor: pickerColor,
                              onColorChanged: changeColor,
                            ),
                          ));
                    }));
              },
              child: const Text(
                'Choisir\nune couleur',
                style: TextStyle(color: Colors.blue),
              )),
          title: Row(
            children: [
              Text(
                libelle,
                style: const TextStyle(color: Colors.green),
              ),
              const SizedBox(width: 10),
              Expanded(
                  child: Container(
                height: 35,
                color: pickerColor,
                // child: Text("data"),
              )),
            ],
          )),
    );
  }
}
