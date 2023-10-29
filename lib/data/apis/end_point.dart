import 'package:mini_project/utils/configs/api_config.dart';

class EndPoint {
  static String test = '${getBaseUrl()}/rumahsakit/test';
  static String getRs = '${getBaseUrl()}/rumahsakit/getrumahsakit';
  static String getSpesialis = '${getBaseUrl()}/rumahsakit/getSpesialis';
  static String getAllRs = '${getBaseUrl()}/rumahsakit/getAllRumahSakit';
  static String addRumahSakitSpesialis = '${getBaseUrl()}/rumahsakit/addRumahSakitSpesialis';
  static String filterRumahSakit = '${getBaseUrl()}/rumahsakit/filterSpesialis';
  static String getDetailSpesialis = '${getBaseUrl()}/rumahsakit/getDetailSpesialis';
  static String openAiChat = 'https://api.openai.com/v1/completions';

  static String daftarAkun = '${getBaseUrl()}/user/daftar';
  static String loginAuth = '${getBaseUrl()}/user/loginAuth';
  static String uploadProfile = '${getBaseUrl()}/user/uploadProfile';
}
