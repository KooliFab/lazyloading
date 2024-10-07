class JobPostRepository {
  JobPostRepository(this._firestore);
  final FirebaseFirestore _firestore;

  Future<PaginatedJobPosts> getJobsAvailable(
      {DocumentSnapshot? lastDocument, int limit = 6}) async {
    try {
      // Define a query with a limit
      Query query = _firestore.collection("jobPosts").limit(limit);

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      // Map the data from firestore
      final querySnapshot = await query
          .withConverter<JobPost>(
            fromFirestore: (snapshot, _) => JobPost.fromMap(snapshot.data()!),
            toFirestore: (job, _) => job.toMap(),
          )
          .get();

      // Prepare the data to return
      final jobs = querySnapshot.docs.map((doc) => doc.data()).toList();

      final lastDoc =
          querySnapshot.docs.isNotEmpty ? querySnapshot.docs.last : null;

      // Return an object PaginatedJobPosts to be manipulated in the view
      return PaginatedJobPosts(jobs, lastDoc);
    } catch (e) {
      debugPrint("Error fetching jobs: $e");
      return PaginatedJobPosts([], null);
    }
  }
}

@Riverpod(keepAlive: true)
JobPostRepository jobPostRepository(JobPostRepositoryRef ref) {
  return JobPostRepository(FirebaseFirestore.instance);
}

@riverpod
Future<PaginatedJobPosts> getJobsAvailable(
    GetJobsAvailableRef ref, DocumentSnapshot? lastDocument) async {
  final repo = ref.watch(jobPostRepositoryProvider);
  final jobsAvailable = await repo.getJobsAvailable(lastDocument: lastDocument);

  return jobsAvailable;
}

class PaginatedJobPosts {
  final List<JobPost> jobs;
  final DocumentSnapshot? lastDocument;

  PaginatedJobPosts(this.jobs, this.lastDocument);
}

