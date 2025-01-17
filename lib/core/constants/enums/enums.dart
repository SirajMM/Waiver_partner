enum DropDownState { hidden, loading, loaded }

enum ImageState { empty, loading, uploaded }

enum ApprovalStatus { notUpload, waitingForApproval, approved, rejected }

enum DriverState {
  idle,
  goingToPickUp,
  arrivedAtPickUp,
  readyToGoToDestination,
  goingToDestination,
  loading,
  reachedDestination,
  paymentInitiated,
  completed,
}
