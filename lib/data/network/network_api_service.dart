// ignore_for_file: only_throw_errors

import 'package:easeops_web_hrms/app_export.dart';
import 'package:http/http.dart' as http;

class NetworkApiService extends BaseApiService {
  @override
  Future<dynamic> getResponse({
    String? endpoint,
    String? token,
    bool isReturnBool = false,
  }) async {
    return makeRequest(
        method: 'GET',
        endpoint: endpoint,
        token: token,
        isReturnBool: isReturnBool);
  }

  @override
  Future<dynamic> postResponse({
    String? endpoint,
    String? token,
    Map<String, dynamic>? postBody,
    List<Map<String, dynamic>>? postBody1,
    bool isReturnBool = false,
  }) async {
    return makeRequest(
      method: 'POST',
      endpoint: endpoint,
      token: token,
      body: postBody,
      bodyList: postBody1,
      isReturnBool: isReturnBool,
    );
  }

  @override
  Future<dynamic> deleteResponse({String? endpoint, String? token}) async {
    return makeRequest(
        method: 'DELETE', endpoint: endpoint, token: token, isReturnBool: true);
  }

  @override
  Future<dynamic> putResponse({
    String? endpoint,
    String? token,
    Map<String, dynamic>? postBody,
    List<Map<String, dynamic>>? postBody1,
  }) async {
    return makeRequest(
        method: 'PUT', endpoint: endpoint, token: token, body: postBody,bodyList: postBody1);
  }

  @override
  Future<dynamic> patchResponse({
    String? endpoint,
    String? token,
    Map<String, dynamic>? patchBody,
  }) async {
    return makeRequest(
        method: 'PATCH', endpoint: endpoint, token: token, body: patchBody);
  }

  Future<dynamic> makeRequest({
    required String method,
    String? endpoint,
    String? token,
    Map<String, dynamic>? body,
    List<Map<String, dynamic>>? bodyList,
    bool isReturnBool = false,
  }) async {
    dynamic responseJson;
    try {
      final url = Uri.parse("${ApiEndPoints.baseApi}${endpoint ?? ''}");
      final headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      };
      final bodyContent =
          bodyList != null ? jsonEncode(bodyList) : jsonEncode(body);
      http.Response response;

      switch (method) {
        case 'GET':
          response = await http.get(url, headers: headers);
          break;
        case 'POST':
          response = await http.post(url, headers: headers, body: bodyContent);
          break;
        case 'DELETE':
          response = await http.delete(url, headers: headers);
          break;
        case 'PUT':
          response = await http.put(url, headers: headers, body: bodyContent);
          break;
        case 'PATCH':
          response = await http.patch(url, headers: headers, body: bodyContent);
          break;
        default:
          throw ApiException('Invalid HTTP method');
      }

      responseJson = returnResponse(response, isReturnBool: isReturnBool);
    } catch (err) {
      Logger.log('$method ERROR: $err for $endpoint');
      if (err is http.ClientException) throw '$err';
      throw ApiException('$err');
    }
    return responseJson;
  }

  dynamic returnResponse(http.Response response, {bool isReturnBool = false}) {
    switch (response.statusCode) {
      case 200:
      case 202:
      case 204:
        return isReturnBool
            ? true
            : jsonDecode(utf8.decode(response.bodyBytes));
      case 400:
        throw BadRequestException(getErrorMessage(response));
      case 401:
        throw UnauthorizedException(getErrorMessage(response));
      case 402:
        throw PaymentRequiredException('Payment required');
      case 403:
        throw ForbiddenException('Forbidden');
      case 404:
        throw NotFoundException('Not found');
      case 405:
        throw NotFoundException('Method not found');
      case 409:
      case 422:
        throw UnProcessableEntityException(getErrorMessage(response));
      case >= 500:
        throw ServerErrorException('Server error');
      default:
        throw DefaultException(getErrorMessage(response));
    }
  }

  String getErrorMessage(http.Response response) {
    return jsonDecode(response.body)['detail'][0]['msg'];
  }
}
