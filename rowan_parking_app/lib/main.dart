// @dart=2.7

// TODO: there's some duplication between loginAction and initState that I suspect could be refactored away

import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'parking_app.dart';
import 'package:rowan_parking_app/api/requests.dart';

final FlutterAppAuth appAuth = FlutterAppAuth();
const FlutterSecureStorage secureStorage = FlutterSecureStorage();

/// -----------------------------------
///           Auth0 Variables
/// -----------------------------------

const String AUTH0_DOMAIN = 'dev-qovew7wy.us.auth0.com';
const String AUTH0_CLIENT_ID = 'v1oM4ZLJJ4iJGMNC3GnfQvP73vpbMgV9';

const String AUTH0_REDIRECT_URI = 'com.auth0.flutterdemo://login-callback';
const String AUTH0_ISSUER = 'https://$AUTH0_DOMAIN';

/// -----------------------------------
///           Profile Widget
/// -----------------------------------

class Profile extends StatelessWidget {
  final Future<void> Function() logoutAction;
  final String name;
  final String picture;

  const Profile(this.logoutAction, this.name, this.picture, {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue, width: 4),
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.fill,
              image: NetworkImage(picture ?? ''),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text('Name: $name'),
        const SizedBox(height: 48),
        RaisedButton(
          onPressed: () async {
            await logoutAction();
          },
          child: const Text('Logout'),
        ),
      ],
    );
  }
}

/// -----------------------------------
///            Login Widget
/// -----------------------------------

class Login extends StatelessWidget {
  final Future<void> Function() loginAction;
  final String loginError;

  const Login(this.loginAction, this.loginError, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Center(
          child: Text(
            'Welcome To the Rowan Parking App',
            textAlign: TextAlign.center,
            overflow: TextOverflow.clip,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
              color: Color(0xFFFFCC00)
            ),
          ),
        ),
        RaisedButton(
          onPressed: () async {
            await loginAction();
          },
          child: const Text('Login'),
        ),
        Text(loginError ?? ''),
      ],
    );
  }
}

/// -----------------------------------
///                 App
/// -----------------------------------

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

/// -----------------------------------
///              App State
/// -----------------------------------

class _MyAppState extends State<MyApp> {
  LoginReceipt userInfo;
  bool isBusy = false;
  bool isLoggedIn = false;
  String errorMessage;
  String name;
  String picture;
  String accessToken;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Rowan Parking App',
        theme: appTheme,
        home: Scaffold(
          // Once logged in, the Parking App provides its own AppBar, so set to null to prevent two appearing
          appBar: isLoggedIn? null : AppBar(title: const Text('Rowan Parking App')),
          body: Center(
            child: Container(
              alignment: Alignment.center,
              child: isBusy
                  ? const CircularProgressIndicator()
                  : isLoggedIn
                      ? ParkingApp(userInfo: userInfo, logoutAction: logoutAction)
                      : Login(loginAction, errorMessage),
            ),
          ),
        ),
        );
  }

  Map<String, Object> parseIdToken(String idToken) {
    final List<String> parts = idToken.split('.');
    assert(parts.length == 3);

    return jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))));
  }

  Future<Map<String, Object>> getUserDetails(String accessToken) async {
    const String url = 'https://$AUTH0_DOMAIN/userinfo';
    final http.Response response = await http.get(
      url,
      headers: <String, String>{'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get user details');
    }
  }

  Future<void> loginAction() async {
    setState(() {
      isBusy = true;
      errorMessage = '';
    });

    try {
      final AuthorizationTokenResponse result =
          await appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          AUTH0_CLIENT_ID,
          AUTH0_REDIRECT_URI,
          issuer: 'https://$AUTH0_DOMAIN',
          scopes: <String>['openid', 'profile', 'offline_access'],
          // promptValues: ['login']
        ),
      );

      final Map<String, Object> idToken = parseIdToken(result.idToken);
      final Map<String, Object> profile =
          await getUserDetails(result.accessToken);

      await secureStorage.write(
          key: 'refresh_token', value: result.refreshToken);

      await secureStorage.write(
          key: 'access_token', value: result.accessToken);

      final prefs = await SharedPreferences.getInstance();
      LoginReceipt receivedUserInfo = await Requests.login(profile['nickname'], 1);

      prefs.setInt('user_id', receivedUserInfo.id);

      setState(() {
        isBusy = false;
        isLoggedIn = true;
        userInfo = receivedUserInfo;
        name = idToken['name'];
        picture = profile['picture'];
      });
    } on Exception catch (e, s) {
      debugPrint('login error: $e - stack: $s');

      setState(() {
        isBusy = false;
        isLoggedIn = false;
        errorMessage = e.toString();
      });
    }
  }

  Future<void> logoutAction() async {
    await secureStorage.delete(key: 'refresh_token');
    setState(() {
      isLoggedIn = false;
      isBusy = false;
    });
  }

  @override
  void initState() {
    initAction();
    super.initState();
  }

  Future<void> initAction() async {
    final String storedRefreshToken =
        await secureStorage.read(key: 'refresh_token');
    if (storedRefreshToken == null) return;

    setState(() {
      isBusy = true;
    });

    try {
      final TokenResponse response = await appAuth.token(TokenRequest(
        AUTH0_CLIENT_ID,
        AUTH0_REDIRECT_URI,
        issuer: AUTH0_ISSUER,
        refreshToken: storedRefreshToken,
      ));

      final Map<String, Object> idToken = parseIdToken(response.idToken);
      final Map<String, Object> profile =
          await getUserDetails(response.accessToken);

      LoginReceipt receivedUserInfo = await Requests.login(profile['nickname'], 1);

      await secureStorage.write(
          key: 'refresh_token', value: response.refreshToken);

      setState(() {
        isBusy = false;
        isLoggedIn = true;
        userInfo = receivedUserInfo;
        name = idToken['name'];
        picture = profile['picture'];
      });
    } on Exception catch (e, s) {
      debugPrint('error on refresh token: $e - stack: $s');
      await logoutAction();
    }
  }

  static ThemeData appTheme = ThemeData(
    appBarTheme: AppBarTheme(backgroundColor: Color(0xFFFFCC00)),
    iconTheme: IconThemeData(color: Colors.white),
    canvasColor: Color(0xFF57150B),
    primaryColor: Colors.grey[700],
    cardTheme: CardTheme(color: Colors.grey[700]), // Button background
    textTheme: TextTheme(
        bodyText1: TextStyle(color: Colors.white), // Nav drawer labels
        bodyText2: TextStyle(color: Colors.white)), // Text on cards
    buttonTheme: ButtonThemeData(buttonColor: Colors.brown[700]),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(primary: Colors.brown[700])),

  );
}
