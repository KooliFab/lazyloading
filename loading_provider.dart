part 'loading_provider.g.dart';

@riverpod
class LoadingNotifier extends _$LoadingNotifier {
  @override
  bool build() {
    return false; // Initial state is not loading
  }

  void setLoading(bool isLoading) {
    state = isLoading;
  }
}
