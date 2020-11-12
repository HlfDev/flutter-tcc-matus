import 'dart:io';

import 'package:dio/dio.dart';
import 'package:matus_app/app/models/cep_aberto.dart';

const token = "cfe8d98718764112afd8075c37c24fc4";

class CepAbertoService {
  Future<CepAbertoAddress> getAddressFromCep(String cep) async {
    final replacedCep = cep.replaceAll('.', '').replaceAll('-', '');
    final endpoint = "https://www.cepaberto.com/api/v3/cep?cep=$replacedCep";

    final Dio dio = Dio();

    dio.options.headers[HttpHeaders.authorizationHeader] = 'Token token=$token';

    try {
      final response = await dio.get<Map<String, dynamic>>(endpoint);

      if (response.data.isEmpty) {
        return Future.error('CEP Inválido');
      }
      final CepAbertoAddress address = CepAbertoAddress.fromMap(response.data);

      return address;
    } on DioError catch (e) {
      return Future.error(e);
    }
  }
}
