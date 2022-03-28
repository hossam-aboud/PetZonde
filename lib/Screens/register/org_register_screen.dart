import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petzone/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:petzone/bloc/authentication_bloc/authentication_event.dart';
import 'package:petzone/bloc/organization_register_bloc/org_reg_bloc.dart';
import 'package:petzone/bloc/organization_register_bloc/org_reg_event.dart';
import 'package:petzone/bloc/organization_register_bloc/org_reg_state.dart';
import 'package:petzone/widgets/slide/slide_dots.dart';

import '../../UserRegType-UI.dart';
import '../../constants.dart';
import '../Background.dart';
import '../log_in.dart';

class OrgRegister extends StatefulWidget {
  @override
  _RegisterScreen createState() => _RegisterScreen();
}

List<GlobalKey<FormState>> formKeys = [
  GlobalKey<FormState>(),
  GlobalKey<FormState>(),
  GlobalKey<FormState>()
];

class _RegisterScreen extends State<OrgRegister> {
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  final _form1Key = GlobalKey<FormState>();
  final _form2Key = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _passwordConfirm = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _website = TextEditingController();
  final TextEditingController _license = TextEditingController();
  String? _city, _photoPath;
  bool? _emailValid, _passValid, _confPassValid, _phoneValid;
  int _currentPage = 0;

  RegExp webRegExp =
      new RegExp(r"^[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,6}$");

  final PageController _pageController =
      PageController(initialPage: 0, keepPage: true);

  bool get isPopulated =>
      _email.text.isNotEmpty &&
      _password.text.isNotEmpty &&
      _passwordConfirm.text.isNotEmpty &&
      _phone.text.isNotEmpty;

  bool isButtonEnabled(orgRegisterState state) {
    return state.isFormValid! && isPopulated && !state.isSubmitting!;
  }

  late orgRegisterBloc _registerBloc;

  @override
  void initState() {
    super.initState();
    _registerBloc = BlocProvider.of<orgRegisterBloc>(context);
    _email.addListener(_onEmailChange);
    _password.addListener(_onPasswordChange);
    _passwordConfirm.addListener(_onPasswordConfirmChange);
    _phone.addListener(_onPhoneChange);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocListener<orgRegisterBloc, orgRegisterState>(
        listener: (context, state) {
      if (state.isFailure!) {
        _scaffoldkey.currentState!.showSnackBar(
          SnackBar(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const <Widget>[
                Text('Register Failure'),
                Icon(Icons.error),
              ],
            ),
            backgroundColor: Color(0xffffae88),
          ),
        );
      }

      if (state.isSubmitting!) {
        _scaffoldkey.currentState!.showSnackBar(
          SnackBar(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const <Widget>[
                Text('Registering...'),
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
              ],
            ),
            backgroundColor: Color(0xffffae88),
          ),
        );
      }

      if (state.isSuccess!) {
        BlocProvider.of<AuthenticationBloc>(context).add(
          AuthenticationLoggedIn(),
        );
        Navigator.push(
          context,
          new MaterialPageRoute(builder: (context) => new _successPage()),
        );
      }
    }, child: BlocBuilder<orgRegisterBloc, orgRegisterState>(
            builder: (context, state) {
      _emailValid = state.isEmailValid;
      _passValid = state.isPasswordValid;
      _confPassValid = state.isPasswordConfirmValid;
      _phoneValid = state.isPhoneValid;
      _photoPath = state.photoPath;
      return Scaffold(
        key: _scaffoldkey,
        resizeToAvoidBottomInset: false,
        body: Container(
          color: Colors.white,
          height: size.height,
          width: double.infinity,
          child: Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              Positioned(
                top: 0,
                left: 0,
                child: Column(
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width,
                        height: (_currentPage == 0)
                            ? MediaQuery.of(context).size.height * .4
                            : MediaQuery.of(context).size.height * .35,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            WavyHeader(_currentPage),
                          ],
                        )),
                  ],
                ),
              ),
              Column(
                children: [
                  Expanded(
                      child: PageView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    controller: _pageController,
                    onPageChanged: _onPageChanged,
                    itemCount: 2,
                    itemBuilder: (ctx, i) => Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Container(
                          width: double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(height: size.height * 0.15),
                              Expanded(
                                child: i == 0
                                    ? Container(
                                        // margin: const EdgeInsets.only(top: 130),
                                        child: form1(),
                                      )
                                    : Container(
                                        // margin: const EdgeInsets.only(top: 130),
                                        child: form2(),
                                      ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )),
                  Container(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        for (int i = 0; i < 2; i++)
                          if (i == _currentPage)
                            SlideDots(true)
                          else
                            SlideDots(false)
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: size.width * 0.1, right: size.width * 0.1),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: () {
                            if (_currentPage == 1) {
                              if (_form2Key.currentState!.validate()) {
                                if (isButtonEnabled(state)) {
                                  _onFormSubmitted();
                                }
                              }
                            } else {
                              if (_form1Key.currentState!.validate()) {
                                _currentPage++;
                                _pageController.animateToPage(
                                  _currentPage,
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeIn,
                                );
                              }
                            }
                          },
                          child: Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 10, bottom: 10),
                              child: Text(
                                (_currentPage != 1) ? 'Next' : 'Register',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              )),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Color(0xFFF88A8A)),
                          ),
                        ),
                        (_currentPage == 0)
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Already have an account?"),
                                  Container(
                                      child: new GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                LoginScreen()),
                                      );
                                    },
                                    child: Text(
                                      " Log In",
                                      style: TextStyle(color: PrimaryButton),
                                    ),
                                  ))
                                ],
                              )
                            : Container(
                                child: Text(''),
                              )
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * .105,
                        child: Stack(
                          fit: StackFit.passthrough,
                          children: [
                            WavyFooter(),
                          ],
                        )),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // const SizedBox(width: 10.0),
                    new GestureDetector(
                        onTap: () {
                          if (_currentPage == 0) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserRegType()),
                            );
                          } else {
                            _currentPage--;
                            _pageController.animateToPage(
                              _currentPage,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.teal[800],
                        )),
                    const SizedBox(width: 20.0),
                    Text(
                      "Adoption Organization Registration",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: TextColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }));
  }

  Widget form1() {
    return Container(
      padding: const EdgeInsets.only(top: 45, right: 20.0, left: 20),
      child: Form(
        key: _form1Key,
        child: Column(
          children: <Widget>[
            //email
            TextFormField(
              controller: _email,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.mail,
                  color: Colors.black12,
                  size: 20,
                ),
                labelText: "Email",
                filled: true,
                fillColor: Color(0xFFF6F6F6),
                focusedBorder: OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(25.0),
                  borderSide: BorderSide(color: Color(0xFFF6F6F6), width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(30.0),
                  borderSide: BorderSide(color: Color(0xFFF6F6F6), width: 2.0),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              validator: (value) {
                if (value!.isEmpty) {
                  return ("Email cannot be Empty");
                }
                return !_emailValid! ? 'Email is invalid' : null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),

            SizedBox(
              height: 20,
            ),

            //password
            TextFormField(
              controller: _password,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.password_sharp,
                  color: Colors.black12,
                  size: 20,
                ),
                labelText: "Password",
                filled: true,
                fillColor: Color(0xFFF6F6F6),
                focusedBorder: OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(25.0),
                  borderSide: BorderSide(color: Color(0xFFF6F6F6), width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(30.0),
                  borderSide: BorderSide(color: Color(0xFFF6F6F6), width: 2.0),
                ),
              ),
              obscureText: true,
              autocorrect: false,
              validator: (value) {
                if (value!.trim().isEmpty) {
                  return ("Password cannot be Empty");
                }
                if (value.trim().length < 8)
                  return ('Password must be at least 8 characters');

                return !_passValid!
                    ? 'Password must contain 1 uppercase letter, 1 lowercase letter and 1 number'
                    : null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
            SizedBox(
              height: 20,
            ),

            //confirm password
            TextFormField(
              controller: _passwordConfirm,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.password_sharp,
                  color: Colors.black12,
                  size: 20,
                ),
                labelText: "Confirm Password",
                filled: true,
                fillColor: Color(0xFFF6F6F6),
                focusedBorder: OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(25.0),
                  borderSide: BorderSide(color: Color(0xFFF6F6F6), width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(30.0),
                  borderSide: BorderSide(color: Color(0xFFF6F6F6), width: 2.0),
                ),
              ),
              obscureText: true,
              validator: (value) {
                if (value!.trim().isEmpty) {
                  return ("Password confirmation cannot be Empty");
                }
                return !_confPassValid! ? "Password don't match" : null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
            SizedBox(
              height: 20,
            ),
            //phone
            TextFormField(
              controller: _phone,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.phone,
                  color: Colors.black12,
                  size: 20,
                ),
                labelText: "Phone number",
                filled: true,
                fillColor: Color(0xFFF6F6F6),
                focusedBorder: OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(25.0),
                  borderSide: BorderSide(color: Color(0xFFF6F6F6), width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(30.0),
                  borderSide: BorderSide(color: Color(0xFFF6F6F6), width: 2.0),
                ),
              ),
              validator: (value) {
                if (value!.trim().isEmpty) {
                  return ("Phone cannot be Empty");
                }

                if (value.trim().length != 10)
                  return 'Phone number must be 10 digits';

                if (!(value.startsWith('05') || value.startsWith('01')))
                  return 'Invalid phone number format (ex.05######## or 01########)';

                return !_phoneValid! ? "Phone number is invalid" : null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              textInputAction: TextInputAction.next,
            ),
            SizedBox(
              height: 20,
            ),

            Expanded(
              child: TextFormField(
                controller: _license,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.badge,
                    color: Colors.black12,
                    size: 20,
                  ),
                  labelText: "Licensing Number",
                  filled: true,
                  fillColor: Color(0xFFF6F6F6),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                    borderSide:
                        BorderSide(color: Color(0xFFF6F6F6), width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(30.0),
                    borderSide:
                        BorderSide(color: Color(0xFFF6F6F6), width: 2.0),
                  ),
                ),
                validator: (value) {
                  if (value!.trim().isEmpty) {
                    return ("Licensing Number cannot be Empty");
                  }
                  if (value.trim().length < 4)
                    return ("Licensing Number must be at least 4 characters");
                  if (value.trim().length > 10)
                    return ("Licensing Number must be at most 10 characters");
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget form2() {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0, left: 20),
      child: Form(
        key: _form2Key,
        child: Column(
          children: <Widget>[
            Container(
              alignment: AlignmentDirectional.topStart,
              child: RichText(
                text: TextSpan(
                    text: '   Profile Photo',
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        color: Color(0xFF191D21),
                        fontWeight: FontWeight.normal),
                    children: <TextSpan>[
                      TextSpan(
                          text: ' (Optional) ',
                          style: TextStyle(
                              fontFamily: 'Nexa',
                              color: Color(0xFF191D21),
                              fontStyle: FontStyle.italic)),
                    ]),
              ),
            ),
            GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: ((builder) => bottomSheet()),
                  );
                },
                child: CircleAvatar(
                  radius: 70,
                  backgroundColor: Colors.grey,
                  backgroundImage: _photoPath == null
                      ? AssetImage("assets/defaultpfp.png")
                      : Image.file(
                          File(_photoPath!),
                          fit: BoxFit.cover,
                        ).image,
                  child: Stack(children: [
                    Align(
                      alignment: Alignment.bottomRight,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: Color(0xFFF88A8A),
                        child: Icon(CupertinoIcons.add, color: Colors.white),
                      ),
                    ),
                  ]),
                )),
            SizedBox(height: 10),
            //name
            TextFormField(
              controller: _name,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.account_circle,
                  color: Colors.black12,
                  size: 23,
                ),
                labelText: "Name",
                filled: true,
                focusedBorder: OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(25.0),
                  borderSide: BorderSide(color: Color(0xFFF6F6F6), width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(30.0),
                  borderSide: BorderSide(color: Color(0xFFF6F6F6), width: 2.0),
                ),
              ),
              validator: (value) {
                if (value!.trim().isEmpty) {
                  return ("Name cannot be Empty");
                }
                if (value.trim().length < 3)
                  return ("Name must be at least 3 characters");
                if (value.trim().length > 50)
                  return ("Name must be at most 50 characters");
                return null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _website,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.web,
                  color: Colors.black12,
                  size: 23,
                ),
                labelText: "Website",
                filled: true,
                fillColor: Color(0xFFF6F6F6),
                focusedBorder: OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(25.0),
                  borderSide: BorderSide(color: Color(0xFFF6F6F6), width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(30.0),
                  borderSide: BorderSide(color: Color(0xFFF6F6F6), width: 2.0),
                ),
              ),
              validator: (value) {
                if (value!.trim().isEmpty) {
                  return ("Website cannot be Empty");
                }
                if (!webRegExp.hasMatch(value)) return ("Website is invalid");
                return null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
            ),

            SizedBox(
              height: 10,
            ),

            //location
            DropdownButtonHideUnderline(
              child: DropdownButtonFormField<String>(
                isExpanded: true,
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                ),
                style: const TextStyle(color: Color(0xff000000), fontSize: 15),
                validator: (value) {
                  if (value == null) return "Please select a city";
                  return null;
                },
                focusColor: Colors.white,
                value: _city,
                iconEnabledColor: Colors.black,
                items: <String>[
                  'Riyadh',
                  'Makkah',
                  'Dammam',
                  'Abha',
                  'Jazan',
                  'Madinah',
                  'Buraidah',
                  'Tabuk',
                  'Ha\'il',
                  'Najran',
                  'Sakaka',
                  'Al-Baha',
                  'Arar'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _city = value;
                  });
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: const InputDecoration(
                  fillColor: Color(0xFFF6F6F6),
                  prefixIcon: Icon(
                    Icons.location_city_rounded,
                    color: Colors.black12,
                    size: 23,
                  ),
                  labelText: 'City',
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0xFFF6F6F6), width: 0.0),
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
                child: TextFormField(
              minLines: 5,
              maxLines: 15,
              controller: _description,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.description,
                  color: Colors.black12,
                  size: 23,
                ),
                labelText: "Description",
                filled: true,
                fillColor: Color(0xFFF6F6F6),
                focusedBorder: OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(25.0),
                  borderSide: BorderSide(color: Color(0xFFF6F6F6), width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(30.0),
                  borderSide: BorderSide(color: Color(0xFFF6F6F6), width: 2.0),
                ),
              ),
              validator: (value) {
                if (value!.trim().isEmpty) {
                  return ("Description cannot be Empty");
                }
                if (value.trim().length < 10)
                  return ("Description must be at least 10 characters");
                if (value.trim().length > 300)
                  return ("Description must be at most 300 characters");
                return null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ))
          ],
        ),
      ),
    );
  }

  void _onEmailChange() {
    _registerBloc.add(RegisterEmailChanged(email: _email.text));
  }

  void _onPasswordChange() {
    _registerBloc.add(RegisterPasswordChanged(password: _password.text));
  }

  void _onPasswordConfirmChange() {
    _registerBloc.add(RegisterPasswordConfirmChanged(
        password: _password.text, passwordConfirm: _passwordConfirm.text));
  }

  void _onPhoneChange() {
    _registerBloc.add(RegisterPhoneChanged(phone: _phone.text));
  }

  void _onFormSubmitted() {
    _registerBloc.add(RegisterSubmitted(
      _photoPath,
      name: _name.text,
      email: _email.text,
      password: _password.text,
      phone: _phone.text,
      license: _license.text,
      website: _website.text,
      city: _city.toString(),
      description: _description.text,
    ));
  }

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text(
            "Choose Profile photo",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.camera),
              onPressed: () {
                _registerBloc
                    .add(RegisterPhotoChanged(source: ImageSource.camera));
              },
              label: Text("Camera"),
            ),
            FlatButton.icon(
              icon: Icon(Icons.image),
              onPressed: () {
                _registerBloc
                    .add(RegisterPhotoChanged(source: ImageSource.gallery));
              },
              label: Text("Gallery"),
            ),
          ])
        ],
      ),
    );
  }
}

class _successPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                    left: 20.0, right: 20.0, bottom: 20.0, top: 100.0),
                child: Container(
                  child: Image.asset(
                    "assets/review.png",
                    height: size.height * 0.25,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: 20.0, right: 20.0, bottom: 10.0, top: 10.0),
                child: Container(
                    alignment: Alignment.center,
                    child: ListTile(
                      title: Text(
                        "Sent for Review",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
//    color: Color(0xff037d50),

                          color: Colors.grey,
                        ),
                      ),
                      subtitle: Text(
                        "Your account has been sent for review. We'll email  you as soon as the review is complete.",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
//    color: Color(0xff037d50),

                          color: Colors.grey,
                        ),
                      ),
                    )),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: 20.0,
                    right: 20.0,
                    bottom: 20.0,
                    top: size.height * 0.05),
                child: TextButton(
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const LoginScreen()));
                  },
                  child: const Text(
                    'Go Back to Login',
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
