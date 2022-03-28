import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petzone/Profiles/profile_view.dart';
import 'package:petzone/Profiles/profile_view_org.dart';
import 'package:petzone/Profiles/profile_view_vet.dart';
import 'package:petzone/bloc/auth/auth_bloc.dart';

class ProfileScreen extends StatelessWidget {

  Widget p(String role){
    if(role == 'Pet Lover'){
      return  ProfileView();
    }else if(role=='adoption organization'){
      return ProfileViewOrg();
    }else{
      return ProfileViewVet();
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
    if (state is Authenticated)
    return Scaffold(
    body:p(state.role)


    );

    return Text('');
    });
  }
}
