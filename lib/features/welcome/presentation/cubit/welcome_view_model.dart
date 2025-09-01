import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
import 'welcome_states.dart';

class WelcomeViewModel extends Cubit<WelcomeState> {
  late VideoPlayerController _controller;

  VideoPlayerController get controller => _controller;

  WelcomeViewModel() : super(  WelcomeState()) {
    _initVideo();
  }

  Future<void> _initVideo() async {
    emit(state.copyWith(status: WelcomeStatus.loading));

    _controller = VideoPlayerController.asset("assets/videos/welcome_video.mp4");
    await _controller.initialize();

    _controller
      ..setLooping(true)
      ..setVolume(0.0)
      ..play();

    emit(state.copyWith(status: WelcomeStatus.videoReady));
  }

void selectRole(UserRole role) {
  emit(state.copyWith(selectedRole: role));
}


  @override
  Future<void> close() {
    _controller.dispose();
    return super.close();
  }
}
