import '../lib/json_rpc.dart';

/**
 * A simple JSON-RPC example, connect to bitcoind:
 * bitcoind -rpcuser=user -rpcpassword=password -daemon
 */
void main() {
  final btc = new JsonRpcProxy('http://user:password@127.0.0.1:8332');

  btc.getinfo().then((info) {
    print(info);
  });
}
