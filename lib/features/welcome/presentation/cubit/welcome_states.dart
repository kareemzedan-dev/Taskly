import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

enum WelcomeStatus { initial, loading, videoReady }

enum UserRole { freelancer, client }

class WelcomeState {
  final UserRole? selectedRole; // null لو لسه ما اختارش
  final WelcomeStatus status;

  WelcomeState({
    this.selectedRole,
    this.status = WelcomeStatus.initial,
  });

  WelcomeState copyWith({
    UserRole? selectedRole,
    WelcomeStatus? status,
  }) {
    return WelcomeState(
      selectedRole: selectedRole ?? this.selectedRole,
      status: status ?? this.status,
    );
  }
}
