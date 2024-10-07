// Use Riverpod
class JobBoardView extends ConsumerStatefulWidget {
  const JobBoardView({super.key});

  @override
  ConsumerState<JobBoardView> createState() => _JobBoardViewState();
}

class _JobBoardViewState extends ConsumerState<JobBoardView> {
  late Future<void> _initialLoadFuture;
  List<JobPost> _allJobs = [];
  PostType? _filterPostType;
  DocumentSnapshot? _lastDocument;
  bool _hasMoreData = true;

  @override
  void initState() {
    super.initState();
    _initialLoadFuture = _loadJobs(initialLoad: true);
  }

  Future<void> _loadJobs({PostType? postType, bool initialLoad = false}) async {
    if (_allJobs.isEmpty || initialLoad) {
      _lastDocument = null;
      _hasMoreData = true;
      final paginatedJobs =
          await ref.refresh(getJobsAvailableProvider(null).future);
      _allJobs = paginatedJobs.jobs;
      _lastDocument = paginatedJobs.lastDocument;
    }

    if (!initialLoad) setState(() {});
  }

  Future<void> _loadMoreJobs() async {
    // Manage loader
    if (ref.read(loadingNotifierProvider) || !_hasMoreData) return;
    ref.read(loadingNotifierProvider.notifier).setLoading(true);
    
    // Call repository to get more results
    final paginatedJobs =
        await ref.read(getJobsAvailableProvider(_lastDocument).future);

    if (paginatedJobs.jobs.isEmpty) {
      _hasMoreData = false;
    } else {
      _allJobs.addAll(paginatedJobs.jobs);
      _lastDocument = paginatedJobs.lastDocument;
    }
    
    // Manage loader
    ref.read(loadingNotifierProvider.notifier).setLoading(false);
  }

  @override
  Widget build(BuildContext context) {
    final isLoadingMore = ref.watch(loadingNotifierProvider);
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () =>
            _loadJobs(postType: _filterPostType, initialLoad: true),
        child: FutureBuilder<void>(
          future: _initialLoadFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                  child: ErrorMessageWidget(snapshot.error.toString()));
            } else {
              // NotificationListener to handle scroll down event
              return NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  // Check if it is the bottom of the list
                  if (scrollInfo.metrics.pixels ==
                          scrollInfo.metrics.maxScrollExtent &&
                      !isLoadingMore) {
                    _loadMoreJobs();
                  }
                  return false;
                },
                // Load the list view
                child: ListView.builder(
                  itemCount: _allJobs.length + (_hasMoreData ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == _allJobs.length) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 4),
                      child: JobPostCard(
                        jobPost: _allJobs[index],
                        onTap: () => context.goNamed(
                          AppRoute.jobDetail.name,
                          pathParameters: {'id': index.toString()},
                          extra: _allJobs[index],
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
