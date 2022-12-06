import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:reto_4/controladores/controladorGeneral.dart';
import 'package:reto_4/procesos/peticiones_DB.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'GeoLocalización',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'GeoLocalizacion'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  controladorGeneral Control = Get.find();

  void obtenerPosicion() async {
    Position position = await peticiones_DB.determinarPosicion();
    Control.carga_posicion(position.toString());
    print(position.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("GeoLocalizacion"),
        actions: [
          IconButton(
              onPressed: () {
                Alert(
                        type: AlertType.warning,
                        title: "¡¡ATENCIÓN!!",
                        buttons: [
                          DialogButton(
                              color: Colors.green,
                              child: Text("SI"),
                              onPressed: () {
                                peticiones_DB.eliminarTodasPosiciones();
                                Control.cargarTodaBD();
                                Navigator.pop(context);
                              }),
                          DialogButton(
                              color: Colors.red,
                              child: Text("NO"),
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                        ],
                        desc:
                            "¿Estas seguro que deseas eliminar TODAS las ubicaciones?",
                        context: context)
                    .show();
              },
              icon: Icon(Icons.delete_forever_sharp))
        ],
      ),
      floatingActionButton: Center(
        child: FloatingActionButton(
            child: Icon(Icons.location_on_outlined),
            onPressed: () {
              obtenerPosicion();
              Alert(
                      type: AlertType.info,
                      title: "¡¡ATENCIÓN!!",
                      desc:
                          "¿Esta seguro que desea almacenar su localización " +
                              Control.position +
                              "?",
                      buttons: [
                        DialogButton(
                            color: Colors.green,
                            child: Text("SI"),
                            onPressed: () {
                              final fh = DateTime.now();
                              peticiones_DB.guardarPosicion(
                                  Control.position.toString(), fh.toLocal());
                              Control.cargarTodaBD();
                              Navigator.pop(context);
                            }),
                        DialogButton(
                            color: Colors.red,
                            child: Text("NO"),
                            onPressed: () {
                              Navigator.pop(context);
                            }),
                      ],
                      context: context)
                  .show();
            }),
      ),
    );
  }
}
