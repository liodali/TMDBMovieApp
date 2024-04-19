import 'package:equatable/equatable.dart';

class StreamListState<T, K> extends Equatable{
  final bool isLoading;
  final K errorMsg;
  final List<T> data;
  const StreamListState({
    this.isLoading = false,
    required this.errorMsg,
    required this.data,
  });
  StreamListState<T, K> copyWith({
    bool? isLoading,
    K? errorMsg,
    List<T>? data,
  }) =>
      StreamListState(
        isLoading: isLoading ?? this.isLoading,
        data: data ?? this.data,
        errorMsg: errorMsg ?? this.errorMsg,
      );
      
        @override
        List<Object?> get props => [
           data,isLoading,errorMsg
        ];
}
