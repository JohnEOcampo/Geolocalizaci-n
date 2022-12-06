import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reto_4/controladores/controladorGeneral.dart';
import 'package:reto_4/procesos/peticiones_DB.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class listar extends StatefulWidget {
  const listar({super.key});

  @override
  State<listar> createState() => _listarState();
}

class _listarState extends State<listar> {
  controladorGeneral Control = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Control.cargarTodaBD();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          child: Control.listaPosiciones?.isEmpty == false
              ? ListView.builder(
                  itemCount: Control.listaPosiciones!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: ListTile(
                        title: Text(
                            Control.listaPosiciones![index]["localizacion"]),
                        subtitle:
                            Text(Control.listaPosiciones![index]["fechahora"]),
                        leading: Icon(Icons.location_searching),
                        trailing: IconButton(
                            onPressed: () {
                              Alert(
                                      type: AlertType.warning,
                                      title: "¡¡ATENCIÓN!!",
                                      buttons: [
                                        DialogButton(
                                            color: Colors.green,
                                            child: Text("SI"),
                                            onPressed: () {
                                              peticiones_DB.eliminarPosicion(
                                                  Control.listaPosiciones![
                                                      index]["id"]);
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
                                          "¿Estas seguro que deseas eliminar esta ubicación?",
                                      context: context)
                                  .show();
                            },
                            icon: Icon(Icons.delete_forever_outlined)),
                      ),
                    );
                  },
                )
              : Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
        ));
  }
}
