// The project info run's save: the config it writes and the logo it copies.
import 'dart:io';

import 'package:deck/core/models/config.dart';
import 'package:deck/data/deck_home.dart';
import 'package:deck/data/stores.dart';
import 'package:deck/mcp/project_tools.dart';
import 'package:deck/state/project_info.dart';
import 'package:deck/state/settings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

class _Home extends Home {
  _Home(this.dir);
  final String dir;

  @override
  DeckHome build() => DeckHome(dir);
}

ProjectInfo info({
  String name = 'Acme VPN',
  String? description,
  List<String> aliases = const [],
  String? logo,
  List<String> platforms = const [],
  String? tech,
  String? board,
  List<String> channels = const [],
  String? ide,
}) => (name: name, description: description, aliases: aliases, logo: logo, platforms: platforms, tech: tech, board: board, channels: channels, ide: ide);

void main() {
  late Directory tmp, repo;
  late ProviderContainer ref;

  setUp(() async {
    tmp = Directory.systemTemp.createTempSync('deck-info-');
    repo = Directory(p.join(tmp.path, 'repo'))..createSync();
    File(p.join(repo.path, 'icon.png')).writeAsBytesSync([1, 2, 3]);
    File(p.join(repo.path, 'icon.ico')).writeAsBytesSync([0]);
    final home = DeckHome(p.join(tmp.path, 'deck'));
    await ConfigStore(home).save(
      DeckConfig(
        projects: [ProjectConfig(id: 'vpn', name: 'repo', dir: repo.path)],
      ),
    );
    ref = ProviderContainer(overrides: [homeProvider.overrideWith(() => _Home(home.dir))]);
  });

  tearDown(() {
    ref.dispose();
    tmp.deleteSync(recursive: true);
  });

  ProjectConfig project() => ref.read(settingsProvider).requireValue.projects.single;

  test('saves the info and copies the logo into state, dropping the old one', () async {
    await ref.read(settingsProvider.future);
    final infos = ref.read(projectInfosProvider.notifier);
    expect(await infos.setProjectInfo('vpn', info(description: 'A VPN.', aliases: ['AVPN'], logo: 'icon.png')), isNull);
    final first = project();
    expect(
      [first.name, first.description, first.aliases],
      [
        'Acme VPN',
        'A VPN.',
        ['AVPN'],
      ],
    );
    final file = File(logoFile(ref.read(homeProvider), first)!);
    expect(file.readAsBytesSync(), [1, 2, 3]);

    await Future<void>.delayed(const Duration(milliseconds: 2));
    expect(await infos.setProjectInfo('vpn', info(logo: p.join(repo.path, 'icon.png'))), isNull);
    expect(project().logo, isNot(first.logo));
    expect(file.existsSync(), isFalse);
    // Left out, the description stays.
    expect(project().description, 'A VPN.');
  });

  test('refuses a logo Flutter cannot draw, or a missing file, and saves nothing', () async {
    await ref.read(settingsProvider.future);
    final infos = ref.read(projectInfosProvider.notifier);
    expect(await infos.setProjectInfo('vpn', info(logo: 'icon.ico')), contains('not .ico'));
    expect(await infos.setProjectInfo('vpn', info(logo: 'gone.png')), contains('No file'));
    expect(project().name, 'repo');
  });

  test('what the run did not find keeps what was there; what it found replaces it', () async {
    await ref.read(settingsProvider.future);
    final infos = ref.read(projectInfosProvider.notifier);
    expect(
      await infos.setProjectInfo('vpn', info(aliases: ['AVPN'], platforms: ['android'], tech: 'Flutter', board: 'jira:AVPN', channels: ['#vpn-team'])),
      isNull,
    );
    expect(await infos.setProjectInfo('vpn', info(name: 'Acme VPN 2')), isNull);
    var pr = project();
    expect(pr.name, 'Acme VPN 2');
    expect(pr.aliases, ['AVPN']);
    expect(pr.platforms, ['android']);
    expect(pr.tech, 'Flutter');
    expect(pr.board, 'jira:AVPN');
    expect(pr.channels, ['#vpn-team']);

    expect(await infos.setProjectInfo('vpn', info(aliases: ['VPN'], platforms: ['apple'], tech: 'Swift', board: 'jira:VPN', channels: ['#ios'])), isNull);
    pr = project();
    expect(
      [pr.aliases, pr.platforms, pr.tech, pr.board, pr.channels],
      [
        ['VPN'],
        ['apple'],
        'Swift',
        'jira:VPN',
        ['#ios'],
      ],
    );
  });

  test('ignores a board that is not a forge or Jira, adds # to channels', () async {
    await ref.read(settingsProvider.future);
    final infos = ref.read(projectInfosProvider.notifier);
    expect(await infos.setProjectInfo('vpn', info(board: 'jira:AVPN')), isNull);
    expect(await infos.setProjectInfo('vpn', info(board: 'trello:abc', channels: ['vpn-team', '#vpn-alerts'])), isNull);
    expect(project().board, 'jira:AVPN');
    expect(project().channels, ['#vpn-team', '#vpn-alerts']);
  });

  test('keeps an IDE only when its command is on the PATH', () async {
    await ref.read(settingsProvider.future);
    final infos = ref.read(projectInfosProvider.notifier);
    expect(await infos.setProjectInfo('vpn', info(ide: 'definitely-not-an-ide-xyz')), isNull);
    expect(project().ide, isNull);
    expect(await infos.setProjectInfo('vpn', info(ide: 'git')), isNull);
    expect(project().ide, 'git');
  });
}
