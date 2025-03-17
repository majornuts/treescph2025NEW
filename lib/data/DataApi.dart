import 'package:dio/dio.dart';
import 'FT.dart';

class DataApi {
  static Future<FT> fetchDataTreesParser() async {
    var dio = Dio();
    const urlTrees =
        'https://wfs-kbhkort.kk.dk/ows?service=wfs&version=2.0.0&request=GetFeature&typeName=k101:gadetraer&outputFormat=json&SRSNAME=EPSG:4326';
    final response = await dio.get(urlTrees);
    return FT.fromJson(response.data);
  }
}
