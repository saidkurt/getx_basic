
import 'package:dio/dio.dart';
import 'package:getx_base_state/core/enum/base_api_path.dart';
import 'network_json_decode.dart';
import 'network_manager.dart';

class NetworkService implements INetworkService{
  NetworkService._privateConstructor();
  static final NetworkService _instance = NetworkService._privateConstructor();
  static NetworkService get instance => _instance;

  final Dio _dio=Dio(
    BaseOptions(
      connectTimeout: 5000,
      baseUrl: APIPATH.BASEURL.rawValue,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      ),
    );
    
  @override
  Future<dynamic> fetchData<T, F extends ParseModel>(String path, T requestModel, F responseModel,String requestType) async {
   try {
      final response = await _dio.fetch(RequestOptions(path:path,data:requestModel,method:requestType));
      return _checkType(response, responseModel);
    }on DioError catch (e) {
     // ignore: avoid_print
     print(e.response!.statusCode);
    }
  }

   Response ? _checkType(Response response,dynamic responseModel){
    switch (response.data) {
      case List :
         return response.data.map((e) => responseModel!.fromJson(e))
          .toList();
        case Map :
         return responseModel!.fromJson();
    }
  }
}



