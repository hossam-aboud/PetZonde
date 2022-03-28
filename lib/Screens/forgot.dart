import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petzone/bloc/forgot_password/forgot_bloc.dart';
import 'package:petzone/constants.dart';
import 'package:petzone/widgets/custom_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _ctrlEmail = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.teal[800],
            ),
          ),
        ),
        body: BlocListener<ForgotBloc, ForgotState>(listener: (context, state) {
          if (state is ForgotSuccess) {
            // Navigating to the dashboard screen if the user is authenticated
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.green,
                content: Text('Reset link has been sent to your email')));
            Navigator.pop(context);
          }
          if (state is ForgotError) {
            // Showing the error message if the user has entered invalid credentials
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
          }
        }, child:
            BlocBuilder<ForgotBloc, ForgotState>(builder: (context, state) {
          if (state is ForgotRequest) {
            return const Center(
              child: Text("Please check Email"),
            );
          }
          if (state is NoForgotRequest) {
            return Center(
              child: Column(
                children: [
                  const SizedBox(height: 150),
                  Text(
                    'Forgot Your Password?',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 30),
                  ),
                  SizedBox(height: 15),
                  Text('Please Enter your Registered Email to Reset it.',
                      style: TextStyle(fontSize: 16)),
                  Padding(
                    padding: EdgeInsets.only(top: 10, left: 20, right: 20),
                    child: TextField(
                      decoration: const InputDecoration(hintText: "Email"),
                      controller: _ctrlEmail,
                    ),
                  ),
                  SizedBox(height: 20),
                  CustomButton(
                    pressed: () {
                      doUserResetPassword();
                    },
                    text: 'Send Email',
                    textColor: Colors.white,
                    color: PrimaryButton,
                    size: Size(size.width * 0.5, 55),
                    textSize: 20,
                  )
                ],
              ),
            );
          }
          return const Text("Forgot password page");
        })));
  }

  void doUserResetPassword() async {
    BlocProvider.of<ForgotBloc>(context).add(
      ForgotPassword(_ctrlEmail.text),
    );
  }
}
