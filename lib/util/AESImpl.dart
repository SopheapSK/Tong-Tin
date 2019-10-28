import 'dart:convert';
import 'dart:typed_data';
import "package:pointycastle/pointycastle.dart";

class AESUtil{


  static String _encryptAES(String src, String keyAES){
    //2008
    //b9h0sCSTt1B+7Ez/jhXn0Q==
    //HG58YZ3CR9

    // Key must be multiple of block size (16 bytes).
   // Digest digest = new SHA256Digest();
    //var key = digest.process( utf8.encode("HG58YZ3CR9"));
    //new Digest('SHA-256');

    var key = new Digest("SHA-256").process(utf8.encode(keyAES));
    // Can be anything.
    // The initialization vector must be unique for every message, so it is a
    // good idea to use a message digest as the IV.
    // IV must be equal to block size (16 bytes).
    Uint8List iv = new Uint8List(16).sublist(0, 16);
   // var iv = new Digest("SHA-256").process(me).sublist(0, 16);
    // The parameters your cipher will need. (PKCS7 does not need params.)
    CipherParameters params = new PaddedBlockCipherParameters(
        //new ParametersWithIV(new KeyParameter(key), iv), null);
        new ParametersWithIV(new KeyParameter(key), iv), null );


    ////////////////
    // Encrypting //
    ////////////////

    // As for why you would need CBC mode and PKCS7 padding, consult the internet
    // (f.e. http://www.di-mgt.com.au/properpassword.html).
    BlockCipher encryptionCipher = new PaddedBlockCipher("AES/CBC/PKCS7");
    encryptionCipher.init(true, params);
    Uint8List encrypted = encryptionCipher.process(utf8.encode(src));

    print("me->>>: " +encrypted.toString());
    var finalText = base64.encode(encrypted);
    print("Encrypted->>>>>: " + finalText);
    if(finalText.endsWith("\n"))
      finalText=finalText.substring(0,finalText.length - 1);
    return finalText;

  }
  static String  _decryptAES(String encryptedText, String keyAES){

    var key = new Digest("SHA-256").process(utf8.encode(keyAES));
    // Can be anything.
    // The initialization vector must be unique for every message, so it is a
    // good idea to use a message digest as the IV.
    // IV must be equal to block size (16 bytes).
    Uint8List iv = new Uint8List(16).sublist(0, 16);
    CipherParameters params = new PaddedBlockCipherParameters(
      //new ParametersWithIV(new KeyParameter(key), iv), null);
        new ParametersWithIV(new KeyParameter(key), iv), null );

    ////////////////
    // Decrypting //
    ////////////////

    BlockCipher decryptionCipher = new PaddedBlockCipher("AES/CBC/PKCS7");
    decryptionCipher.init(false, params);
    String decrypted = utf8.decode(decryptionCipher.process(base64.decode(encryptedText)));
    print("Decrypted: $decrypted");
    return decrypted;

  }
  static String  encryptAES(String src, String keyAES){
    String enText = "";
      try{
       enText =  _encryptAES(src, keyAES);
      }catch(e){
        enText = "";
        print(e.toString());
      }
      return enText;
  }
  static String  decryptAES(String encryptedText, String keyAES){
    String deText = "";
    try{
      deText =  _decryptAES(encryptedText, keyAES);
    }catch(e){
      deText = "";
      print(e.toString());
    }
    return deText;
  }
  void meEncrypt(){
    //Digest

  }


  String formatBytesAsHexString(Uint8List bytes) {
    var result = new StringBuffer();
    for( var i=0 ; i<bytes.lengthInBytes ; i++ ) {
      var part = bytes[i];
      result.write('${part < 16 ? '0' : ''}${part.toRadixString(16)}');
    }
    return result.toString();
  }

  static Map<String, dynamic> parseJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('invalid token');
    }

    final payload = _decodeBase64(parts[1]);
    final payloadMap = json.decode(payload);
    if (payloadMap is! Map<String, dynamic>) {
      throw Exception('invalid payload');
    }

    return payloadMap;
  }

  static String _decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');

    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception('Illegal base64url string!"');
    }

    return utf8.decode(base64Url.decode(output));
  }
}