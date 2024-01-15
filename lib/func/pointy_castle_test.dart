import 'dart:developer';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pointycastle/asymmetric/api.dart';

const String key =
    "MIICXQIBAAKBgQDO/DG/3ssQwKH6TLAKf0Pi6BzTDKIs9LnSHtBhZ2+YgpE+K2qSw7BldlEpE5uXmvGho0g9p9XdLroMufwD+jSq/p0wmpbb4cqWVXkF0uo8SO1Hf7AZMBsNjQpWbFF8rOxHCN/+cHzHDBj5t8RmjeUB9kRviB6gb+oGInMvpDncxQIDAQABAoGAILURV3RpOjh2YAsGNmJt48kx5Ne2OMxjIKTl4L5rj/nx4ZUSviZWFXJg2NDUYVyGmjgnDjcbQFxF4gTxod9DuwjHhHx6dPeiAsYDr7+T/LAEXOSinNK544I3Fp4fkmJ3r8xXXBmofpNiMazCgvxu4/J0MpRS/6fQB3xqYfRyFoECQQDpEfXAZJuBJFEP2t5nAlhQZ/IbrD5MxlRlHE7++GctMNJgK2nC+/JgSNBcou1SnzmkI2VoVzuIdqiawXfhWMhZAkEA41lDpxn9e6tBBP0I/BRH8DBfjPaq/z82CeeuG9EckWFrQ8UVMkjClEK8tn28GbS3YQ5ssckTW4sdJfRnM/8qTQJAUXbomg3QWMxT1SHgWMr2CWy7sDZ9NCKifxDs/6vdjGsjLWAfQHsF1ee9hJOiNh3XbOq+WEEdWu52sljrSQXaSQJBAKVWLIIgv5ypja6ACoGwiiSeOU79sJvSL42ChLdMGzeLHoP5lxGron5KDo204Q/cwiP+ZoPg1IgVoowQsuE4p10CQQCjAtGrPGsXSUCh4HWX5kJV9vz/7H0TWB/4A21S+K58vOT4VT9NqjeLo1v6VYlJrzqSJ4gDlCfZdY00/KPp2PRr";

class CryptTest extends StatelessWidget {
  const CryptTest({Key? key}) : super(key: key);

  void decr() async {
    log("Hey");

    String s =
        "J12Ag8f+N+y95NmxFoCN5sGL+rIalJIBaB+QmoMa2nnA3nGeI6WaOJxDdAOKJAvmPSZ/yj4bkeG35M8Z6Dc1xu1czxDcP1vYNtVWgji0T+WhIEypN39DnFcqoFQxPEP7wgXv1j/u1t1kkcvzgOOE41N8fG2MGIf3w/SsuUdTJwQ=";
    // log(s);

    // String str = decrypt(s, _privateKey);
    // log(s);
    try {
      // final privKey =
      //     await parseKeyFromFile<RSAPrivateKey>('assets/private.pem');
      final privatePem = await rootBundle.loadString('assets/private.pem');
      final privKey = enc.RSAKeyParser().parse(privatePem) as RSAPrivateKey;

      // final publicPem = await rootBundle.loadString('assets/public.pem');
      // final pubKey = enc.RSAKeyParser().parse(publicPem) as RSAPublicKey;

      final encrypter = enc.Encrypter(enc.RSA(
        privateKey: privKey,
      ));

      // final encrypted = encrypter.encrypt(
      //     '{"key":"rzp_test_JOC0wRKpLH1cVW","secret":"9EzSlxvJbTyQ2Hg0Us5ZX4VD"}');

      // log(encrypted.base64);

      final en = enc.Encrypted.fromBase64(s);
      final decrypted = encrypter.decrypt(en);

      log(decrypted);
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    decr();
    return TextButton(onPressed: () {}, child: const Text("Hey"));
  }
}
