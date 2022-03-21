import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fleet_management/providerClass/providerData.dart';
import 'package:fleet_management/screens/LoginScreens/loginScreen.dart';
import 'package:fleet_management/screens/errorScreen.dart';
import 'package:fleet_management/screens/spashScreenToGetTransporterData.dart';
import 'package:fleet_management/widgets/splashScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

import 'constants/color.dart';
import 'language/localization_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

var firebase;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await GetStorage.init();
  await GetStorage.init('TransporterIDStorage');
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          messagingSenderId: '291069338054',
          appId: '1:291069338054:web:80d986c353a1c39f9b92c7',
          projectId: 'liveasytransporterapp',
          apiKey: 'AIzaSyDNgqelUhqMZpGcDykhkKDeJroiEsRY4wQ'));
  // GlobalBindings().dependencies();
  runApp( MyApp());
}


class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();


  var _connectionStatus = "Unknown";
  Connectivity? connectivity;
  StreamSubscription<ConnectivityResult>? subscription;
  bool isDisconnected = false;

  @override
  void initState() {
    super.initState();
    setState(() {});
    // checkConnection();
    // connectivityChecker();
  }

  // void checkConnection() {
  //   // configOneSignel();
  //   connectivity = new Connectivity();
  //   subscription =
  //       connectivity!.onConnectivityChanged.listen((ConnectivityResult result) {
  //         _connectionStatus = result.toString();
  //         print(_connectionStatus);
  //         if (result == ConnectivityResult.mobile ||
  //             result == ConnectivityResult.wifi) {
  //           if (isDisconnected) {
  //             isDisconnected = false;
  //             connectivityChecker();
  //             Get.back();
  //           }
  //         } else {
  //           if (!isDisconnected) {
  //             isDisconnected = true;
  //             Get.defaultDialog(
  //                 barrierDismissible: false,
  //                 content: NoInternetConnection.noInternetDialogue(),
  //                 onWillPop: () async => false,
  //                 title: "\nNo Internet",
  //                 titleStyle: TextStyle(
  //                   fontWeight: FontWeight.bold,
  //                 ));
  //           } else
  //             // connectivityChecker();
  //         }
  //       });
  // }

  // Future<void> connectivityChecker() async {
  //   print("Checking internet...");
  //   try {
  //     await InternetAddress.('google.com');
  //   } on SocketException catch (_) {
  //     isDisconnected = true;
  //     Future.delayed(const Duration(milliseconds: 500), () {
  //       Get.defaultDialog(
  //           barrierDismissible: false,
  //           content: NoInternetConnection.noInternetDialogue(),
  //           onWillPop: () async => false,
  //           title: "\nNo Internet",
  //           titleStyle: TextStyle(
  //             fontWeight: FontWeight.bold,
  //           ));
  //     });
  //   }
  // }

  @override
  void dispose() {
    subscription!.cancel();
    super.dispose();
  }

  // void configOneSignel() {
  //   OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
  //   String oneSignalAppId = FlutterConfig.get('oneSignalAppId').toString();
  //   OneSignal.shared.setAppId(oneSignalAppId);
  // }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: ChangeNotifierProvider<ProviderData>(
        create: (context) => ProviderData(),
        builder: (context, child) {
          return FutureBuilder(
              future: _initialization,
              builder: (context, snapshot) {
                final provider = Provider.of<ProviderData>(context);
                if (snapshot.connectionState == ConnectionState.done) {
                  if (FirebaseAuth.instance.currentUser == null) {
                    return GetMaterialApp(
                      builder: EasyLoading.init(),
                      theme: ThemeData(fontFamily: "montserrat"),
                      translations: LocalizationService(),
                      locale: LocalizationService().getCurrentLocale(),
                      fallbackLocale: Locale('en', 'US'),
                      // locale: provider.locale,
                      // supportedLocales: L10n.all,
                      // localizationsDelegates: [
                      //   AppLocalizations.delegate,
                      //   GlobalMaterialLocalizations.delegate,
                      //   GlobalCupertinoLocalizations.delegate,
                      //   GlobalWidgetsLocalizations.delegate,
                      // ],
                      home: SplashScreen(),
                    );
                  } else {
                    return GetMaterialApp(
                      builder: EasyLoading.init(),
                      theme: ThemeData(
                          fontFamily: "montserrat",
                          appBarTheme: AppBarTheme(
                              color: statusBarColor,
                              iconTheme: IconThemeData(color: grey))),
                      translations: LocalizationService(),
                      locale: LocalizationService().getCurrentLocale(),
                      fallbackLocale: Locale('en', 'US'),
                      // locale: provider.locale,
                      // supportedLocales: L10n.all,
                      // localizationsDelegates: [
                      //   AppLocalizations.delegate,
                      //   GlobalMaterialLocalizations.delegate,
                      //   GlobalCupertinoLocalizations.delegate,
                      //   GlobalWidgetsLocalizations.delegate,
                      // ],
                      home:
                      SplashScreenToGetTransporterData(
                        mobileNum: FirebaseAuth
                            .instance.currentUser!.phoneNumber
                            .toString()
                            .substring(3, 13),
                      ),
                    );
                  }
                }
                else
                  return ErrorScreen();
              }
              );
        },
      ),
    );
  }
}


