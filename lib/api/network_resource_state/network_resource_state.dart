import 'package:freezed_annotation/freezed_annotation.dart';

part 'network_resource_state.freezed.dart';

@freezed
class NetworkResourceState<T> with _$NetworkResourceState<T> {
  const factory NetworkResourceState(T? data) = _Data<T>;

  const factory NetworkResourceState.loading() = _Loading<T>;

  const factory NetworkResourceState.error(dynamic errors) = _ErrorDetails<T>;
}
