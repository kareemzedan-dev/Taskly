import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/services/supabase_service.dart';

@Injectable()
class UserStatusService with WidgetsBindingObserver {
  final SupabaseService supabaseService;
  final String userId;

  UserStatusService({required this.supabaseService, required this.userId}) {
    // Register observer
    WidgetsBinding.instance.addObserver(this);

    // Set online when service is initialized
    _setOnlineStatus(true);
  }

  /// Call when app goes background or inactive
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _setOnlineStatus(false);
    } else if (state == AppLifecycleState.resumed) {
      _setOnlineStatus(true);
    }
  }

  Future<void> _setOnlineStatus(bool online) async {
    await supabaseService.supabaseClient
        .from('users')
        .update({
      'is_online': online,
      'last_seen': online ? null : DateTime.now().toIso8601String(),
    })
        .eq('id', userId);
  }

  Future<void> setOfflineOnLogout() async {
    await _setOnlineStatus(false);
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }
}
