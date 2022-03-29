import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:petzone/Screens/welcome_screen.dart';
import 'package:petzone/bloc/forgot_password/forgot_bloc.dart';
import 'package:petzone/bloc/vet_requests/pet_lover/bloc/pl_vet_request_list_bloc.dart';
import 'package:petzone/repositories/auth_repository.dart';
import 'package:petzone/repositories/data_repository.dart';
import 'package:petzone/repositories/decision_repository.dart';
import 'package:petzone/repositories/request_repository.dart';
import 'package:petzone/repositories/user_repository.dart';
import 'ReqList/Repository.dart';
import 'ReqList/reqBloc.dart';
import 'bloc/PetLover Registration/PetLover_bloc.dart';
import 'bloc/adoption_post/adoption_post_bloc.dart';
import 'bloc/adoption_req_list/adoption_req_list_bloc.dart';
import 'bloc/adoption_req_list/user_reqs_list_bloc.dart';
import 'bloc/adoption_request.dart/adopt_req_bloc.dart';
import 'bloc/auth/auth_bloc.dart';
import 'bloc/authentication_bloc/authentication_bloc.dart';
import 'bloc/authentication_bloc/authentication_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petzone/repositories/admin_repository.dart';
import 'bloc/adoption_decision/adopt_decision_bloc.dart';
import 'bloc/data_bloc/data_bloc.dart';
import 'bloc/handover_list/org_handover_list_bloc.dart';
import 'bloc/handover_request/handover_decision_bloc.dart';
import 'bloc/lost_and_found/lost_and_found_add_bloc.dart';
import 'bloc/lost_and_found/lost_and_found_list_bloc.dart';
import 'bloc/organization_register_bloc/org_reg_bloc.dart';
import 'bloc/registerList/register_request_bloc.dart';
import 'bloc/registerProfile/register_profile_bloc.dart';

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // If you're going to use other Firebase services in the background, such as Firestore,
//   // make sure you call `initializeApp` before using other Firebase services.
//   await Firebase.initializeApp();
//   print('Handling a background message ${message.messageId}');
//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final UserRepository userRepository = UserRepository();
  runApp(MultiBlocProvider(providers: [
    BlocProvider(
        create: (_) => RegisterRequestBloc(adminRepository: AdminRepository())),
    BlocProvider(
        create: (_) => RegisterProfileBloc(adminRepository: AdminRepository())),
    BlocProvider(
        create: (_) => orgRegisterBloc(userRepository: UserRepository())),
    BlocProvider(create: (_) => PetLoverBloc(userRepository: UserRepository())),
    BlocProvider(create: (_) => AuthBloc(authRepository: AuthRepository())),
    BlocProvider(create: (_) => AdoptionPostBloc()),
    BlocProvider(create: (_) => ForgotBloc(authRepository: AuthRepository())),
    BlocProvider(create: (_) => DataBloc(DataRepository: DataRepository())),
    BlocProvider(create: (_) => LostAndFoundAddBloc()),
    BlocProvider(create: (_) => LostAndFoundListBloc()),
    BlocProvider(create: (_) => HandoverDecisionBloc()),
    BlocProvider(
        create: (_) =>
            AdoptRequestBloc(requestRepository: RequestRepository())),
    BlocProvider(create: (_) => AdoptionReqListBloc()),
    BlocProvider(
        create: (_) =>
            AdoptDecisionBloc(decisionRepository: DecisionRepository())),
    BlocProvider(create: (_) => PLReqAdoptionBloc(repository: Repository())),
    BlocProvider(create: (_) => UserReqsListBloc()),
    BlocProvider(create: (_) => HandoverListBloc()),
    BlocProvider(create: (_) => HandoverDecisionBloc()),
    BlocProvider(create: (_) => PlVetRequestListBloc()),
    BlocProvider(
        create: (_) => AuthenticationBloc(
              userRepository: userRepository,
            )..add(AuthenticationStarted()))
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> fbApp = Firebase.initializeApp();

  MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PetZone',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      home: FutureBuilder(
        future: fbApp,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print("An error has occured ${snapshot.error.toString()}");
            return const Text("Something went wrong");
          } else if (snapshot.hasData) {
            return WelcomeScreen();
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
