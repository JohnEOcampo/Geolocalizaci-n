import 'package:geolocator/geolocator.dart';
import 'package:sqflite/sqflite.dart' as sql;

class peticiones_DB {
  static Future<void> CrearTabla(sql.Database database) async {
    await database.execute("""CREATE TABLE posiciones (
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      localizacion TEXT,
      fechahora TEXT

    ) """);
  }
////////////////////////////////////////////////////////
  ///

  static Future<sql.Database> db() async {
    return sql.openDatabase("geolocalizacion.db", version: 1,
        onCreate: (sql.Database database, int version) async {
      await CrearTabla(database);
    });
  }

/////////////////////////////////////////////////////////////////////
  ///

  static Future<void> guardarPosicion(localiza, fechora) async {
    final baseDato = await peticiones_DB.db();
    final datos = {"localizacion": localiza, "fechahora": fechora};
    baseDato.insert("posiciones", datos,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

///////////////////////////////////////////////////////////////////

  static Future<void> eliminarPosicion(int idpos) async {
    final baseDato = await peticiones_DB.db();
    baseDato.delete("posiciones", where: "id=?", whereArgs: [idpos]);
  }

//////////////////////////////////////////////////////////////////

  static Future<void> eliminarTodasPosiciones() async {
    final baseDato = await peticiones_DB.db();
    baseDato.delete("posiciones");
  }

///////////////////////////////////////////////////////////////////////

  static Future<List<Map<String, dynamic>>> mostrarPosiciones() async {
    final baseDato = await peticiones_DB.db();
    return baseDato.query("posiciones", orderBy: "fechahora");
  }

/////////////////////////////////////////////////////////////////////////////
  ///

  static Future<Position> determinarPosicion() async {
    LocationPermission permiso;
    permiso = await Geolocator.checkPermission();

    if (permiso == LocationPermission.denied) {
      permiso = await Geolocator.requestPermission();
      if (permiso == LocationPermission.denied) {
        return Future.error("Permiso Denegado para usar GPS");
      }
    }

    if (permiso == LocationPermission.deniedForever) {
      return Future.error(
          "Permiso Denegado Permanentemente para usar GPS en este dispositivo");
    }
    return await Geolocator.getCurrentPosition();
  }
}
