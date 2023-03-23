import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';

import 'snapshot_guard_platform_interface.dart';

/// An implementation of [SnapshotGuardPlatform] that uses method channels.
class MethodChannelSnapshotGuard extends SnapshotGuardPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('snapshot_guard');

  final BehaviorSubject<bool> _guardStatusSubject = BehaviorSubject.seeded(false);

  @override
  Future<bool?> toggleGuard() async {
    final result = await methodChannel.invokeMethod<bool>('toggleGuard');
    return result;
  }

  @override
  Future<bool?> switchGuardStatus(bool status) async {
    final result = await methodChannel.invokeMethod<bool>('switchGuardStatus', status);
    if (result != null) {
      _guardStatusSubject.add(result);
    }
    return result;
  }

  @override
  Stream<bool> get guardStatusStream => _guardStatusSubject.stream;

  @override
  bool get isGuardEnabled => _guardStatusSubject.value!;
}
