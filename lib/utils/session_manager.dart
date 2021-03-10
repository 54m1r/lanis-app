import 'dart:developer' as developer;

import 'dart:io';
import 'dart:math';

import 'package:crypton/crypton.dart';
import 'package:flutter/services.dart';
import 'package:schulportal_hessen_app/models/nutzer.dart';
import 'package:schulportal_hessen_app/utils/cryptojs_aes_encryption_helper.dart';

import 'package:http/http.dart' as http;

import 'package:html/parser.dart'
    as htmlParser; // Contains HTML parsers to generate a Document object
import 'package:html/dom.dart'
    as htmlDom; // Contains DOM related classes for extracting data from elements

import 'dart:convert' as convert;
import 'package:intl/intl.dart';
import 'package:schulportal_hessen_app/utils/utility.dart';

class SessionManager {
  Map<String, String> headers = {
    "User-Agent":
        "Mozilla/5.0 (Unknown; UNIX BSD/SYSV system) AppleWebKit/538.1 (KHTML, like Gecko) QupZilla/1.7.0 Safari/538.1",
    "Accept": "*/*",
    "Accept-Language": "de,en-US;q=0.7,en;q=0.3",
    "Accept-Encoding": "gzip, deflate, br",
    "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
    //"X-Requested-With": "XMLHttpRequest",
    "Host": "start.schulportal.hessen.de",
    "Origin": "https://start.schulportal.hessen.de",
    //"Content-Length": "36",
    "Pragma": "no-cache",
  "Referer": "https://start.schulportal.hessen.de/nachrichten.php",
    "X-Requested-With": "XMLHttpRequest",
    //"DNT": "1",
    "Connection": "keep-alive",
    //"Referer": "https://start.schulportal.hessen.de/index.php",
    "Cookie": "",
    "Cache-Control": "no-cache",
    "Sec-Fetch-User": "?1",
    //"Cookie": "complianceCookie=on; sid=hpdb4htb3l7ppt76o653frff18soj3356nfh4ggp3kc10vrgkdo423k8sgmc2r4mf79iagm6itr9861mf74jv124gi8q62f0rdinsk0;",
  };

  static SessionManager instance;
  //Nutzer nutzer;

  final String loginPageUrl;
  final String publicKeyUrl;
  final String handshakeUrl;
  final String loginUrl;

  SessionManager(
      this.loginPageUrl, this.publicKeyUrl, this.handshakeUrl, this.loginUrl) {
    //aesKey = generateAesKey();

    instance = this;
  }

  Future<Nutzer> login(String username, String password) async {
    Nutzer loginNutzer = await _login(username, password);
    if (loginNutzer == null) {
      loginNutzer = await _login(username, password);
    }

    return loginNutzer;
  }

  Future<Nutzer> _login(String username, String password) async {
    String aesKey = generateAesKey();

    var csrfToken = await getCSRFToken();
    RSAPublicKey rsaPublicKey = await getRsaPublicKey();
    var encryptedAesKey = encryptAesKey(rsaPublicKey, aesKey);

    bool shake = await handshake(encryptedAesKey, aesKey);

    if (shake) {
      var loginData =
          'f=alllogin&art=all&sid=&ikey=$csrfToken&user=$username&passw=$password';
      var loginDataCrypt = encryptAESCryptoJS(loginData, aesKey);

      //developer.log('loginData\n ' + 'f=alllogin&art=all&sid=&ikey=$csrfToken&user=$username&passw=$password');
      developer.log('loginDataCrypt\n $loginDataCrypt\n---');

      var loginResponse = await http
          .post(loginUrl, headers: headers, body: {'crypt': loginDataCrypt});
      developer.log("Headers:");
      developer.log(headers.toString());
      developer.log(loginResponse.body);

      if (!(loginResponse.body is String)) {
        return null;
      }

      var loginJsonResponse = convert.jsonDecode(loginResponse.body);
      developer.log("Login JSON Response:");
      developer.log(loginJsonResponse.toString());

      try {
        var back = loginJsonResponse['back'];

        if (!back) {
          return null; //login nicht erfolgreich
        }

        var name = loginJsonResponse['name'];

        developer.log('Willkommen $name!');

        return new Nutzer(name, headers, aesKey);
      } catch (e) {}
    }

    return null;
  }

  String generateAesKey() {
    //TODO generate random
    return "U2FsdGVkX1/qivbk/1nD4kJnp6Exl5vIrzG59F58/23ViKMD6B63f6II27qtCVTVLTuTVpnqYaYgv1LlSI+Fsw==";
  }

  Future<String> getCSRFToken() async {
    var isRedirect = true;
    var url = loginPageUrl;

    while (isRedirect) {
      final client = http.Client();
      final request = http.Request('GET', Uri.parse(loginPageUrl))
        ..followRedirects = false
        ..headers['cookie'] = headers['Cookie'];
      var loginPageResponse = await client.send(request);

      developer.log("EXIT");
      developer.log(loginPageResponse.headers.toString());
      developer.log("EXIT");

      //exit(0);

      developer.log("Hallo?");
      developer.log(loginPageResponse.headers.toString());

      if (loginPageResponse.statusCode == HttpStatus.movedTemporarily) {
        isRedirect = loginPageResponse.isRedirect;
        url = loginPageResponse.headers['location'];
        //setCookies(loginPageResponse.headers['set-cookie'].toString());
        developer.log(loginPageResponse.headers.toString());
        // final receivedCookies = response.headers['set-cookie'];
      } else if (loginPageResponse.statusCode == HttpStatus.ok) {
        //setCookies(loginPageResponse.headers['set-cookie']);
        developer.log(loginPageResponse.statusCode.toString() + " <---");
        developer.log(loginPageResponse.headers.toString());
        //setCookies(loginPageResponse.headers['set-cookie'].toString());
      }

      developer.log(loginPageResponse.isRedirect.toString());
      developer.log(loginPageResponse.statusCode.toString());
      developer.log(loginPageResponse.headers.toString());
      developer.log(loginPageResponse.request.headers.toString());
      if (loginPageResponse.statusCode == 200) {
        var body = await loginPageResponse.stream.bytesToString();
        var document = htmlParser.parse(body);
        String csrfToken =
            document.querySelector('[name="ikey"]').attributes['value'];
        developer.log('csrfToken\n $csrfToken\n---');
        return csrfToken;
      }
    }

    return null;
  }

  Future<bool> handshake(String encryptedAesKey, String aesKey) async {
    var handshakeResponse = await http
        .post(handshakeUrl, headers: headers, body: {'key': encryptedAesKey});
    if (handshakeResponse.statusCode == 200) {
      //developer.log(handshakeResponse.headers.toString());
      //setCookies("sid=hpdb4htb3l7ppt76o653frff18soj3356nfh4ggp3kc10vrgkdo423k8sgmc2r4mf79iagm6itr9861mf74jv124gi8q62f0rdinsk0;");
      //headers['Cookie'] = defaultCookie+handshakeResponse.headers['Cookie'];
      //developer.log('set-cookie\n $cookies\n---');

      developer.log(handshakeResponse.headers.toString());
      setCookies(handshakeResponse.headers['set-cookie']);

      var challenge = convert.jsonDecode(handshakeResponse.body)['challenge'];

      developer.log('Challenge\n $challenge\n---');

      //String plainText = 'PlainText is Me';
      //var aes_encrypted = encryptAESCryptoJS(plainText, "password");
      var aesDecrypted = decryptAESCryptoJS(challenge, aesKey);

      //developer.log('aes_encrypted\n $aes_encrypted\n---');
      developer.log('aes_decrypted\n $aesDecrypted\n---');

      return aesDecrypted == aesKey;
    }

    return false;
  }

  Future<RSAPublicKey> getRsaPublicKey() async {
    var publicKeyResponse = await http.get(publicKeyUrl, headers: headers);
    if (publicKeyResponse.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(publicKeyResponse.body);
      var publicKeyPem = jsonResponse['publickey'];

      return RSAPublicKey.fromPEM(publicKeyPem);
    }

    return null;
  }

  String encryptAesKey(RSAPublicKey rsaPublicKey, String aesKey) {
    return rsaPublicKey.encrypt(aesKey);
  }

  void setCookies(String setCookiesHeader) {
    developer.log('--------------------------------');
    developer.log(setCookiesHeader);
    developer.log('complianceCookie=on; ' + setCookiesHeader);
    developer.log('--------------------------------');
    var defaultCookie = 'complianceCookie=on; schulportal_lastschool=6271; schulportal_logindomain=login.schulportal.hessen.de;';

    // Cookie
    // 	complianceCookie=on; schulportal_lastschool=6271; schulportal_logindomain=login.schulportal.hessen.de; sid=01ds645ies2h3h662liepeo6t2seesuv5mf9avqguartk0uv4jn94031uggoctav7loldmfo0uc04kq3gnap26obsiujqa1jph8kcu3

    headers['Cookie'] = defaultCookie + setCookiesHeader;
  }

  SessionManager getInstance() {
    return instance;
  }
}
