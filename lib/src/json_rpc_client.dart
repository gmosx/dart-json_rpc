part of json_rpc;

/**
 * JSON-RPC client.
 *
 * JSON-RPC is a lightweight remote procedure call protocol.
 *
 * http://json-rpc.org/wiki/specification
 */
class JsonRpcClient {
  String uri;

  HttpClient _client = new HttpClient();

  /** [RFC 4627](http://tools.ietf.org/html/rfc4627) */
  static const String JSON_MIME_TYPE = 'application/json';

  /** JSON-RPC version. */
  static const String JSON_RPC_VERSION = '1.0';

  JsonRpcClient(this.uri);

  /**
   * method - A String containing the name of the method to be invoked.
   * params - An Array of objects to pass as arguments to the method.
   * id - The request id. This can be of any type. It is used to match the response with the request that it is replying to.
   */
  Future call(String method, {params: const [], id}) { // TODO: rename to request?
    final completer = new Completer(),
          conn = _client.postUrl(new Uri.fromString(uri)).then(
              (HttpClientRequest req) {
                final payload = JSON.stringify({
                  'jsonrpc': JSON_RPC_VERSION,
                  'method': method,
                  'params': params,
                  'id': id != null ? id : new DateTime.now().millisecondsSinceEpoch
                });

                req.headers.add('content-type', JSON_MIME_TYPE);
                req.contentLength = payload.length;
                req.addString(payload);
                req.close();

                req.response.then(
                    (HttpClientResponse resp) {
                      resp.listen(
                        (data) {
                          final payload = JSON.parse(codepointsToString(data));
                          if (payload['result'] != null) {
                            completer.complete(payload['result']);
                          } else if (payload['error'] != null) {
                            completer.completeError(payload['error']);
                          }
                        },
                        onError: (e) {
                          print(e);
                        },
                        onDone: () {
                          _client.close();
                        });
                    });
              },
              onError: (e) {
                print(e);
              });

    return completer.future;
  }
}
