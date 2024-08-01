import 'dart:io';

// TODO : REMOVE THIS
// This class is used to override the http request to allow the self-signed certificates
// WARNING : this is not recommended for PRODUCTION use
class MyHttpOverrides extends HttpOverrides
{
  @override
  HttpClient createHttpClient(SecurityContext? context)
  {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
