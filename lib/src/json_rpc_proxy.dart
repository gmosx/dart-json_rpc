part of json_rpc;

/**
 * A JSON-RPC proxy.
 */
class JsonRpcProxy extends JsonRpcClient {
  noSuchMethod(InvocationMirror invocation) {
    // TODO: also handle arguments!
    return call(invocation.memberName);
  }

  JsonRpcProxy(String uri) : super(uri);
}