class Failures {
  final String message;
  const Failures(this.message);
}

class ServerFailure extends Failures {
  const ServerFailure(super.message);
}

class CacheFailure extends Failures {
  const CacheFailure(super.message);
}

class NetworkFailure extends Failures {
  const NetworkFailure(super.message);
}

class LocationFailure extends Failures {
  const LocationFailure(super.message);
}

class PermissionFailure extends Failures {
  const PermissionFailure(super.message);
}

class CameraFailure extends Failures {
  const CameraFailure(super.message);
}

class AudioFailure extends Failures {
  const AudioFailure(super.message);
}

class VideoFailure extends Failures {
  const VideoFailure(super.message);
}

class OtherFailure extends Failures {
  const OtherFailure(super.message);
}
