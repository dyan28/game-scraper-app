import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:apk_pul/api/api_endpoints.dart';
import 'package:apk_pul/api/api_response/api_response.dart';
import 'package:apk_pul/common/core/constants.dart';
import 'package:apk_pul/common/core/routes.dart';
import 'package:apk_pul/common/data/local_secure_storage.dart';
import 'package:apk_pul/env/env_state.dart';
import 'package:apk_pul/main/app.dart';
import 'package:apk_pul/utils/dialog.dart';
import 'package:apk_pul/utils/logger.dart';
import 'package:apk_pul/utils/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import 'api_exceptions.dart';

ApiClient apiClient(Ref ref) => ref.read(envProvider.notifier);

class ApiClient extends StateNotifier<EnvState> {
  ApiClient(super.state, this.ref);
  Ref ref;

  static const timeout = Duration(seconds: 120);

  static Future<Map<String, String>> getHeaders({
    bool isAuthorized = false,
    bool isFormData = false,
    String? inputLang,
  }) async {
    final accessToken = await SecureStorage.getToken();
    var contentType = 'application/json';

    if (isFormData) {
      contentType = 'multipart/form-data';
    }

    // header for authorization
    final headersAuth = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': contentType,
    };

    // header for non authorization
    final headers = {
      'Content-Type': 'application/json',
    };

    return isAuthorized ? headersAuth : headers;
  }

  // String get header
  Future<dynamic> getRequest(
    String endpoint, {
    bool isAuthorized = false,
    Map<String, dynamic>? params,
    Map<String, String>? addHeaders,
  }) async {
    final headers = await getHeaders(
      isAuthorized: isAuthorized,
    );
    final uri = Uri.parse(state.baseUrlApi + endpoint);

    if (addHeaders != null) {
      headers.addAll(addHeaders);
    }

    _logRequest(
      headers: headers,
      type: 'GET',
      url: uri,
      params: params,
    );

    final result = http
        .get(
          uri,
          headers: headers,
        )
        .then(_handleResponse)
        .catchError(_handleError)
        .timeout(
          timeout,
          onTimeout: () => _handleError(TimeoutException(null, timeout)),
        );

    return result;
  }

  Future<dynamic> postRequest(
    String endpoint, {
    required Map<String, dynamic>? params,
    bool isAuthorized = false,
    dynamic paramsRe,
  }) async {
    final headers = await getHeaders(
      isAuthorized: isAuthorized,
    );

    final uri = Uri.parse(state.baseUrlApi + endpoint);

    _logRequest(
      headers: headers,
      type: 'POST',
      url: uri,
      params: params,
    );

    final result = http
        .post(
          uri,
          headers: headers,
          body: paramsRe ?? json.encode(params),
        )
        .then(_handleResponse)
        .catchError(_handleError)
        .timeout(
          timeout,
          onTimeout: () => _handleError(TimeoutException(null, timeout)),
        );
    return result;
  }

  // Future<dynamic> postFileRequest(
  //   String endpoint, {
  //   required Map<String, dynamic>? params,
  //   bool isAuthorized = false,
  //   bool isLoading = true,
  //   required List<String> paths,
  //   required String key,
  // }) async {
  //   final headers = await getHeaders(
  //     isAuthorized: isAuthorized,
  //     isFormData: true,
  //   );

  //   final uri = Uri.parse(state.baseUrlApi + endpoint);

  //   _logRequest(
  //     headers: headers,
  //     type: 'POST',
  //     url: uri,
  //     params: params,
  //   );

  //   final request = http.MultipartRequest('POST', uri)..headers.addAll(headers);

  //   for (final path in paths) {
  //     final contentType =
  //         isImage(path) ? MediaType('image', mimeType(path)) : null;

  //     request.files.add(await http.MultipartFile.fromPath(
  //       key,
  //       path,
  //       contentType: contentType,
  //     ));
  //   }

  //   if (params != null) {
  //     params.forEach((key, value) {
  //       request.fields[key] = value.toString();
  //     });
  //   }
  //   await request
  //       .send()
  //       .then((value) async {
  //         final body = await value.stream.bytesToString();

  //         logger.v(
  //           json.decode(body),
  //           'Response │ Status: ${value.statusCode}\n${value.request?.url}',
  //         );
  //       })
  //       .catchError(_handleError)
  //       .whenComplete(() => hideLoading(ref, false));
  // }

  Future<dynamic> putRequest(
    String endpoint, {
    required Map<String, dynamic>? params,
    bool isAuthorized = false,
  }) async {
    final headers = await getHeaders(
      isAuthorized: isAuthorized,
    );
    final uri = Uri.parse(state.baseUrlApi + endpoint);

    final result = http
        .put(
          uri,
          headers: headers,
          body: json.encode(params),
        )
        .then(_handleResponse)
        .catchError(_handleError)
        .timeout(
          timeout,
          onTimeout: () => _handleError(TimeoutException(null, timeout)),
        );

    return result;
  }

  Future<dynamic> patchRequest(
    String endpoint, {
    required Map<String, dynamic>? params,
    bool isAuthorized = false,
  }) async {
    final headers = await getHeaders(
      isAuthorized: isAuthorized,
    );
    final uri = Uri.parse(state.baseUrlApi + endpoint);

    final result = http
        .patch(
          uri,
          headers: headers,
          body: json.encode(params),
        )
        .then(_handleResponse)
        .catchError(_handleError)
        .timeout(
          timeout,
          onTimeout: () => _handleError(TimeoutException(null, timeout)),
        );

    return result;
  }

  Future<dynamic> deleteRequest(String endpoint,
      {bool enableLoading = true}) async {
    final headers = await getHeaders(isAuthorized: true);
    final uri = Uri.parse(state.baseUrlApi + endpoint);

    final result = http
        .delete(
          uri,
          headers: headers,
        )
        .then(_handleResponse)
        .catchError(_handleError)
        .timeout(
          timeout,
          onTimeout: () => _handleError(TimeoutException(null, timeout)),
        );

    return result;
  }

  Future<String> reGetAccessToken({required String username}) async {
    String refreshToken = await SecureStorage.getToken(isAccessToken: false);
    log('f5 token: $refreshToken');
    final params = {'userName': username, "refreshToken": refreshToken};

    final res = await postRequest(
      ApiEndpoints.refreshToken,
      params: params,
    );
    final accessToken = (res['accessToken'] ?? '').toString();
    SecureStorage.saveToken(accessToken);

    return accessToken;
  }

  dynamic _handleResponse(http.Response httpResponse) {
    final statusCode = httpResponse.statusCode;
    final url = httpResponse.request?.url.toString();
    final body = httpResponse.body;

    logger.log(Level.info, json.decode(body),
        error: 'Response │ Status: $statusCode\n$url');

    switch (statusCode) {
      case 200 || 201:
        final resBody = json.decode(body);
        ApiResponse response;

        try {
          response = ApiResponse.fromJson(resBody);
        } catch (e) {
          throw OtherException(
              'Api Response has wrong format with code:  $statusCode', url);
        }

        if (!response.success || response.data == null) {
          throw CustomeApiException(
            response.code,
            response.message,
            url,
            response.data,
          );
        }

        return response;
      case 400:
        throw BadRequestException(httpResponse.body, url);
      case 401:
        handleUnauthorizedError();
        break;
      case 403:
        throw UnAuthorizedException(httpResponse.body, url);
      case 500:
      default:
        throw OtherException('Error occured with code:  $statusCode', url);
    }
  }

  dynamic _handleError(onError) {
    final context = Utils.navigatorState!.context;
    var errMsg = 'Server is not available, please try later!';

    if (onError is TimeoutException) {
      // Retry or something
      errMsg = 'Server took too long to response, please try again!';
      log('Timeout error: ${onError.duration}');
    } else if (onError is SocketException) {
      // loss internet connection, show snackbar or something
      errMsg = 'Errors message';
      log('Socket error: Please check your internet connection and try again!');
    } else if (onError is OtherException) {
      // Server 500
      log('Unhandled error: ${onError.message}');
    } else if (onError is CustomeApiException) {
      log('err message: ${onError.message}');
      log('err data: ${onError.data}');

      switch (onError.code) {
        // The login id has already been taken
        case 422:
          String error = onError.validateErrorMsg();
          Dialogs(context).showError(error);
          break;

        //no content
        case 204:
          break;

        // Unauthorized
        case 401:
          Constants.navigatorKey.currentState?.pushNamedAndRemoveUntil(
            Routes.loginScreen,
            (route) => false,
          );
          Dialogs(context)
              .showError(onError.message ?? 'Api has something wrong!');
          break;

        default:
          Dialogs(context)
              .showError(onError.message ?? 'Api has something wrong!');

          break;
      }
      return onError.data;
    }

    // Utils.showSnackBar(context, errMsg);
  }

  static void handleUnauthorizedError() async {
    final context = Utils.navigatorState?.context;
    if (context != null) {
      // Utils.showSnackBar('Text SnackBar');
    }

    /// `await LocalStorage.clearSession();` is a method call to clear the session data stored in the
    /// local storage of the app. This is typically used when the user logs out of the app or when there
    /// is an unauthorized error response from the API. It ensures that any sensitive user data stored
    /// in the local storage is cleared and not accessible to anyone else.
    // await LocalStorage.clearSession();
    Utils.navigatorState
        ?.pushNamedAndRemoveUntil(Routes.loginScreen, (route) => false);
  }

  static void _logRequest({
    required dynamic url,
    required dynamic headers,
    required dynamic params,
    required dynamic type,
  }) {
    logger
      ..i(
        url,
        error: 'Request │ $type',
      )
      ..i(headers, error: 'Headers')
      ..i(params, error: 'Request Parameters');
  }

  void setEnvState(String privacyUrl, String termOfServiceUrl) {
    state = state.copyWith(
      privacyUrl: privacyUrl,
      termsOfServiceUrl: termOfServiceUrl,
    );
  }
}
