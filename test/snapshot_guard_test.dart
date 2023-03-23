import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';
import 'package:snapshot_guard/snapshot_guard.dart';
import 'package:snapshot_guard/snapshot_guard_platform_interface.dart';
import 'package:snapshot_guard/snapshot_guard_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockSnapshotGuardPlatform with MockPlatformInterfaceMixin implements SnapshotGuardPlatform {
  final BehaviorSubject<bool> _guardStatusSubject = BehaviorSubject.seeded(false);

  @override
  Future<bool?> toggleGuard() => Future.value(true);

  @override
  Stream<bool> get guardStatusStream => _guardStatusSubject.stream;

  @override
  Future<bool?> switchGuardStatus(bool status) {
    _guardStatusSubject.add(status);
    return Future.value(status);
  }

  @override
  bool get isGuardEnabled => _guardStatusSubject.value!;
}

void main() {
  final SnapshotGuardPlatform initialPlatform = SnapshotGuardPlatform.instance;

  test('$MethodChannelSnapshotGuard is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelSnapshotGuard>());
  });

  test('toggleGuard', () async {
    MockSnapshotGuardPlatform fakePlatform = MockSnapshotGuardPlatform();
    SnapshotGuardPlatform.instance = fakePlatform;

    expect(await SnapshotGuard.toggleGuard(), true);
  });

  test('switchGuardStatus', () async {
    MockSnapshotGuardPlatform fakePlatform = MockSnapshotGuardPlatform();
    SnapshotGuardPlatform.instance = fakePlatform;

    expect(await SnapshotGuard.switchGuardStatus(true), true);
    expect(await SnapshotGuard.switchGuardStatus(false), false);
  });
}
