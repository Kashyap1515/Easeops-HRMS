abstract class BaseApiService {
  Future<dynamic> getResponse({String? endpoint, String? token});

  Future<dynamic> postResponse({
    String? endpoint,
    String? token,
    Map<String, dynamic>? postBody,
  });

  Future<dynamic> deleteResponse({String? endpoint, String? token});

  Future<dynamic> putResponse({
    String? endpoint,
    String? token,
    Map<String, dynamic>? postBody,
  });

  Future<dynamic> patchResponse({
    String? endpoint,
    String? token,
    Map<String, dynamic>? patchBody,
  });
}
