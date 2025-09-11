import 'package:freezed_annotation/freezed_annotation.dart';

part 'env_state.freezed.dart';

@freezed
class EnvState with _$EnvState {
  factory EnvState({
    required String baseUrlApi,
    required String privacyUrl,
    required String termsOfServiceUrl,
  }) = _EnvState;
}

class EnvValue {
  static EnvState development = EnvState(
    baseUrlApi: 'http://14.225.254.99:3000',
    privacyUrl: '',
    termsOfServiceUrl: '',
  );

  static EnvState production = EnvState(
    baseUrlApi: '',
    privacyUrl: '',
    termsOfServiceUrl: '',
  );
}
