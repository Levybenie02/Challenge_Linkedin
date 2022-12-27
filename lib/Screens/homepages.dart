import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parking_app_version_1/Db/dbmanage.dart';
import 'package:parking_app_version_1/Models/vehicule.dart';
import 'package:parking_app_version_1/Screens/addcar.dart';
import 'package:parking_app_version_1/Widget/caritems.dart';
import 'package:async/async.dart';

class Homepages extends StatefulWidget {
  const Homepages({super.key});

  @override
  State<Homepages> createState() => _HomepagesState();
}

class _HomepagesState extends State<Homepages> {
  final AsyncMemoizer memoizer = AsyncMemoizer();

  Future updateUI() async {
    await Dbmanager().getCar();
    setState(() {});
  }

  Future<bool> asyncinit() async {
    await memoizer.runOnce(() async {
      await Dbmanager().initDb();
      await Dbmanager().getCar();
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: asyncinit(),
      builder: ((context, snapshot) {
        if ((!snapshot.hasData || snapshot.data == false)) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator(color: Colors.green)),
          );
        } else {
          return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: Text(
                  "Parking pro",
                  style: GoogleFonts.lato(fontSize: 20, letterSpacing: 4),
                ),
                actions: [
                  IconButton(
                      splashRadius: 25,
                      onPressed: () {
                        Get.to(() => const Addcar());
                      },
                      icon: const Icon(Icons.add))
                ],
              ),
              body: (Dbmanager.carItems.isEmpty)
                  ? const Center(
                      child: Text("Aucun vehicule au park"),
                    )
                  : ListView(
                      children: Dbmanager.carItems.map(carItems).toList(),
                    ));
        }
      }),
    );
  }

  DelayedDisplay carItems(Modelcar car) => DelayedDisplay(
        delay: const Duration(microseconds: 350),
        child: Dismissible(
          key: Key(car.id.toString()),
          onDismissed: ((direction) async {
            await Dbmanager().deleteCar(car: car);
            updateUI();
          }),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 22,
                    backgroundColor: Color(int.parse(car.color)),
                    child: Text(
                      car.marque.substring(0, 1).toUpperCase(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    car.marque.toUpperCase(),
                    style: GoogleFonts.lato(),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'M. ${car.nom}',
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        (car.ispark)
                            ? 'Entré le ${car.time}'
                            : 'Sorti le ${car.time}',
                        style: GoogleFonts.lato(),
                      )
                    ],
                  ),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //   Text('data'),
                      Switch(
                          value: car.ispark,
                          onChanged: ((value) async {
                            await Dbmanager().togglecar(car: car);
                            updateUI();
                          }))
                    ],
                  ),
                ),
              ),
              const Divider(
                thickness: 1,
              )
            ],
          ),
        ),
      );
}
