enum LogStatus {
  pending,
  completed,
  skipped,
  failed;

  // Add this getter
  String get name {
    switch (this) {
      case LogStatus.pending:
        return 'pending';
      case LogStatus.completed:
        return 'completed';
      case LogStatus.skipped:
        return 'skipped';
      case LogStatus.failed:
        return 'failed';
    }
  }
}