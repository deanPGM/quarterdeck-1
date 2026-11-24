// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mcp_host.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The Deck MCP server, up as long as the app runs. Background sessions and
/// your own terminal sessions reach it at http://127.0.0.1:4777/mcp.

@ProviderFor(mcpHost)
final mcpHostProvider = McpHostProvider._();

/// The Deck MCP server, up as long as the app runs. Background sessions and
/// your own terminal sessions reach it at http://127.0.0.1:4777/mcp.

final class McpHostProvider extends $FunctionalProvider<AsyncValue<HttpMcpHost>, HttpMcpHost, FutureOr<HttpMcpHost>>
    with $FutureModifier<HttpMcpHost>, $FutureProvider<HttpMcpHost> {
  /// The Deck MCP server, up as long as the app runs. Background sessions and
  /// your own terminal sessions reach it at http://127.0.0.1:4777/mcp.
  McpHostProvider._()
    : super(from: null, argument: null, retry: null, name: r'mcpHostProvider', isAutoDispose: false, dependencies: null, $allTransitiveDependencies: null);

  @override
  String debugGetCreateSourceHash() => _$mcpHostHash();

  @$internal
  @override
  $FutureProviderElement<HttpMcpHost> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<HttpMcpHost> create(Ref ref) {
    return mcpHost(ref);
  }
}

String _$mcpHostHash() => r'f37e73f244b4ee725738a6daeaa2d793cc6a4e00';
