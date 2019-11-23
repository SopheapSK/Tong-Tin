
class Language {
  static final int KH =0;
  static final int ENG = 1;
  static String  khmerLang = 'TRUE';
  static int CURRENT_LANG =   khmerLang.toLowerCase() == 'true' ? KH : ENG;


  static String app_name({int lang=0}){
    return lang == KH ? "តុងទីន" : "Tong Tin";
  }

  static String loading({int lang=0}){
     return lang == KH ? "កំពុងដំណើរការ" : "Loading";
  }
  static String register({int lang =0}){
    return lang == KH ? "ចុះឈ្មោះ" : "Register";
  }
  static String login({int lang =0}){
    return lang == KH ? "ចូល" : "Login";
  }
  static String phoneNumber({int lang =0}){
    return lang == KH ? "លេខទូរស័ព្ទ" : "Phone Number";
  }
  static String password({int lang =0}){
    return lang == KH ? "លេខសម្ងាត់" : "Password";
  }

  static String confirmPassword({int lang =0}){
    return lang == KH ? "បញ្ជាក់​​​" + password() : "Confirm Password";
  }
  static String errorFieldRequire({int lang = 0}){
     return lang == KH ? "សូមបំពេញពត័មាន" : "Please Fill All Infomation";
  }
  static String errorInternetConnection({int lang = 0}){
    return lang == KH ? "មានបញ្ហាអ៊ីនធឺណិត" : "Error Internet Connection";
  }
}