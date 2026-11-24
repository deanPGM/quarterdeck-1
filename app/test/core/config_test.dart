import 'package:deck/core/models/config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('an old GitLab config on the local MCP server loads as glab', () {
    final p = ProviderConfig.fromJson({
      'access': 'mcp',
      'mcp': {'file': '~/projects/acme/.mcp.json', 'server': 'gitlab'},
    });
    expect(p.access, Access.cli);
  });
}
