
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:petzone/Screens/forgot.dart';
import 'package:petzone/bloc/auth/auth_bloc.dart';
import 'package:petzone/bloc/forgot_password/forgot_bloc.dart';
import 'package:petzone/widgets/custom_button.dart';
import '../UserRegType-UI.dart';
import '../constants.dart';
import 'admin_register_request/admin_register_list.dart';
import 'main_screen/org_main.dart';
import 'main_screen/petLover_main.dart';
import 'main_screen/vet_main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class LoginRequestData {
  String email = '';
  String password = '';
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _key = GlobalKey();
  final LoginRequestData _loginData = LoginRequestData();
  bool _obscureText = true;

  late AndroidNotificationChannel channel;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {

    super.initState();

    requestPermission();

    loadFCM();

    listenFCM();
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  void listenFCM() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              // TODO add a proper drawable resource to android, for now using
              //      one that already exists in example app.
              icon: 'launch_background',
            ),
          ),
        );
      }
    });
  }

  void loadFCM() async {
    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        importance: Importance.high,
        enableVibration: true,
      );

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      /// Create an Android Notification Channel.
      ///
      /// We use this channel in the `AndroidManifest.xml` file to override the
      /// default FCM channel to enable heads up notifications.
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      /// Update the iOS foreground notification presentation options to allow
      /// heads up notifications.
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            // Navigating to the dashboard screen if the user is authenticated
            if (state.role == 'admin')
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RegisterRequestList()));

            if (state.role == 'adoption organization')
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => orgScreen()));

            if (state.role == 'Pet Lover')
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => petLoverScreen()));

            if (state.role == 'veterinarian')
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => vetScreen()));
          }
          if (state is AuthError) {
            // Showing the error message if the user has entered invalid credentials
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is Loading) {
              // Showing the loading indicator while the user is signing in
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is UnAuthenticated) {
              // Showing the sign in form if the user is not authenticated
              return Container(
                color: Colors.white,
                height: size.height,
                width: double.infinity,
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: size.height * 0.05),
                          Image.asset(
                            "assets/logo.png",
                            height: size.height * 0.35,
                          ),
                          SizedBox(height: size.height * 0.05),
                          Container(
                            padding: const EdgeInsets.fromLTRB(25, 5, 25, 5),
                            child: Form(
                              key: _key,
                              child: _getFormUI(size),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

  Widget _getFormUI(Size size) {
    return Column(
      children: <Widget>[
        TextFormField(
          keyboardType: TextInputType.emailAddress,
          autofocus: false,
          decoration: InputDecoration(
            hintText: 'Email',
            fillColor: Colors.grey.shade300,
            filled: true,
            contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(32.0),
                borderSide: const BorderSide(color: Colors.white, width: 1.0)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(32.0),
                borderSide: const BorderSide(color: Colors.white, width: 1.0)),
          ),
          validator: (value) {
            return validateEmail(value);
          },
          onChanged: (value) {
            _loginData.email = value;
          },
        ),
        const SizedBox(height: 20.0),
        TextFormField(
            autofocus: false,
            obscureText: _obscureText,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              hintText: 'Password',
              contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              fillColor: Colors.grey.shade300,
              filled: true,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(32.0),
                borderSide: const BorderSide(color: Colors.blue, width: 1.0),
              ),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0),
                  borderSide:
                      const BorderSide(color: Colors.white, width: 1.0)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0),
                  borderSide:
                      const BorderSide(color: Colors.white, width: 1.0)),
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                child: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                  semanticLabel:
                      _obscureText ? 'show password' : 'hide password',
                ),
              ),
            ),
            validator: (value) {
              return validatePassword(value);
            },
            onChanged: (String value) {
              _loginData.password = value;
            }),
        const SizedBox(height: 15.0),
        FlatButton(
            child: const Text("Forgot Password?",
                style: TextStyle(color: PrimaryButton)),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ForgotPasswordScreen()));
            }),
        Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            child: CustomButton(
                text: 'Login',
                textSize: 20,
                textColor: Colors.white,
                color: PrimaryButton,
                size: Size(size.width * 0.8, 55),
                pressed: () => _authenticateWithEmailAndPassword(context))),
        FlatButton(
            onPressed: _sendToRegisterPage,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text("Don't have an account? "),
                Text(
                  "Register here",
                  style: TextStyle(color: PrimaryButton),
                )
              ],
            )),
      ],
    );
  }

  _sendToRegisterPage() {
    ///Go to register page
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => const UserRegType()));
  }

  String? validatePassword(String? value) {
    // String patttern = r'(^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{6,}$)';
    // RegExp regExp = RegExp(patttern);
    if (value!.isEmpty) {
      return "Password is Required";
    } else if (value.length < 8) {
      return "Password must be min. eight characters";
    }
    return null;
  }

  String? validateEmail(String? value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(pattern);
    if (value!.isEmpty) {
      return "Email is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Invalid Email";
    } else {
      return null;
    }
  }

  void _authenticateWithEmailAndPassword(context) {
    if (_key.currentState!.validate()) {
      BlocProvider.of<AuthBloc>(context).add(
        SignInRequested(_loginData.email, _loginData.password),
      );
    }
  }

  void doUserResetPassword(String email) async {
    BlocProvider.of<ForgotBloc>(context).add(
      ForgotPassword(_loginData.email),
    );
  }
}
