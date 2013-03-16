part of json_rpc;

/**
 * A JSON-RPC proxy.
 */
class JsonRpcProxy extends JsonRpcClient {
  noSuchMethod(InvocationMirror invocation) {
    return call(invocation.memberName, params: invocation.positionalArguments);
  }

  JsonRpcProxy(String uri) : super(uri);
}