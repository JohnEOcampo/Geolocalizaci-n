import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:reto_4/procesos/peticiones_DB.dart';

class controladorGeneral extends GetxController {
  final Rxn<List<Map<String, dynamic>>> _listaPosiciones =
      Rxn<List<Map<String, dynamic>>>();

///////////////////////////////////////////////////////////
  ///
  final _position = "".obs;

  void carga_posicion(String X) {
    _position.value = X;
  }

  String get position => _position.value;
///////////////////////////////////////////////////////////////
  ///
  void cargar_Posiciones(List<Map<String, dynamic>> X) {
    _listaPosiciones.value = X;
  }

  List<Map<String, dynamic>>? get listaPosiciones => _listaPosiciones.value;

  Future<void> cargarTodaBD() async {
    final datos = await peticiones_DB.mostrarPosiciones();
    cargar_Posiciones(datos);
  }
}
