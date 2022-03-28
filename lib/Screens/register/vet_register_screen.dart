import 'dart:io';
import 'package:email_validator/email_validator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petzone/model/globals.dart' as globals;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petzone/service/authentication_service.dart';
import 'package:petzone/widgets/slide/slide_dots.dart';
import '../../UserRegType-UI.dart';
import '../../constants.dart';
import '../Background.dart';
import '../log_in.dart';
import 'package:petzone/model/LoginRequestData.dart' as log;

class VetReg extends StatefulWidget {
  @override
  VetRegScreen createState() => VetRegScreen();
}

List<GlobalKey<FormState>> formKeys = [
  GlobalKey<FormState>(),
  GlobalKey<FormState>(),
  GlobalKey<FormState>()
];

class VetRegScreen extends State<VetReg> {
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();
  final _form1Key = GlobalKey<FormState>();
  final _form2Key = GlobalKey<FormState>();
  int _currentPage = 0;
  final PageController _pageController =
      PageController(initialPage: 0, keepPage: true);

  String? _photoPath, _city;
  bool? _emailValid, _passValid, _confPassValid, _phoneValid;

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
    return Scaffold(
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
                          : MediaQuery.of(context).size.height * 0.35,
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
                            (_currentPage == 0)
                                ? SizedBox(height: size.height * 0.06)
                                : SizedBox(height: size.height * 0.1),
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
                              registerUser();
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
                                          builder: (context) => LoginScreen()),
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
                    "Veterinarian Registration",
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
  }

  bool validatePassword(String value) {
    RegExp regex = new RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$');
    if (!regex.hasMatch(value))
      return true;
    else
      return false;
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  Widget form1() {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.only(top: 50, right: 20.0, left: 20),
      child: Form(
        key: _form1Key,
        child: Column(
          children: <Widget>[
            //email
            TextFormField(
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
              onChanged: (value) {
                globals.loginRequestData.email = value;
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return ("Email cannot be Empty");
                } else if (EmailValidator.validate(value.trim()))
                  return null;
                else if (EmailValidator.validate(value))
                  return null;
                else
                  return "Please enter a valid email";
                return null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),

            SizedBox(
              height: 10,
            ),

            //password
            TextFormField(
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
              onChanged: (value) {
                globals.loginRequestData.password = value;
              },
              validator: (value) {
                if (value!.trim().isEmpty) {
                  return ("Password cannot be Empty");
                }
                if (value.trim().length < 8)
                  return ('Password must be at least 8 characters');

                if (validatePassword(value.trim()))
                  return 'Password must contain 1 uppercase letter, 1 lowercase letter and 1 number';

                return null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
            SizedBox(
              height: 10,
            ),

            //confirm password
            TextFormField(
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
                return (globals.loginRequestData.password.toString() !=
                        value.toString())
                    ? "Password don't match"
                    : null;
                return null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
            SizedBox(
              height: 10,
            ),
            //phone
            TextFormField(
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
              onChanged: (value) {
                globals.loginRequestData.phoneNumber = value;
              },
              validator: (value) {
                if (value!.trim().isEmpty) {
                  return ("Phone cannot be Empty");
                } else if (!isNumeric(value)) {
                  return 'phone number must be numeric';
                }
                if (value.trim().length != 10)
                  return 'phone number must be 10 digits';

                if (!(value.startsWith('05')))
                  return 'Invalid phone number format (ex.05########)';

                return null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              textInputAction: TextInputAction.next,
            ),

            SizedBox(
              height: 10,
            ),

            TextFormField(
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.badge,
                  color: Colors.black12,
                  size: 20,
                ),
                labelText: "Degree",
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
              onChanged: (value) {
                globals.loginRequestData.degree = value;
              },
              validator: (value) {
                if (value!.trim().isEmpty) {
                  return ("Degree cannot be Empty");
                }

                if (value.trim().length > 100)
                  return ("Degree Number must be at most 100 characters");
                return null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              textInputAction: TextInputAction.next,
            ),
            SizedBox(
              height: 2,
            ),
            Expanded(
              child: Center(
                child: Container(
                  height: size.height * 0.145,
                  width: size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.grey.shade300,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10.0, top: 10),
                    child: Column(
                      children: [
                        Icon(
                          Icons.note_add,
                          size: 30,
                          color: Colors.grey,
                          semanticLabel:
                              'Text to announce in accessibility modes',
                        ),
                        Container(
                            child: Padding(
                          padding: EdgeInsets.only(
                              left: size.width * 0.1, right: size.width * 0.1),
                          child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
                              onPressed: () {
                                _pickFiles();
                              },
                              textColor: Colors.white,
                              color: AcceptButton,
                              child: Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0, right: 8),
                                        child: Container(
                                          color: AcceptButton,
                                          child: Text(
                                            'Add Degree Certificate',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      Icon(
                                        Icons.add,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                    ],
                                  ))),
                        ))
                      ],
                    ),
                  ),
                ),
              ),
            )
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
                        backgroundColor: Color(0xffe57285).withOpacity(0.7),
                        child: Icon(CupertinoIcons.add, color: Colors.white),
                      ),
                    ),
                  ]),
                )),
            SizedBox(height: 10),

            //fname
            TextFormField(
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.account_circle,
                  color: Colors.black12,
                  size: 23,
                ),
                labelText: "First Name",
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
              onChanged: (value) {
                globals.loginRequestData.firstName = value;
              },
              validator: (value) {
                if (value!.trim().isEmpty) {
                  return ("First Name cannot be Empty");
                }
                if (value.trim().length < 3)
                  return ("First Name must be at least 3 characters");

                if (!RegExp("^[A-Za-z ]*\$").hasMatch((value)))
                  return 'First name must contain only letters';

                if (value.trim().length > 25)
                  return ("First Name must be at most 25 characters");
                return null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
            ),
            SizedBox(
              height: 10,
            ),

            //lname
            TextFormField(
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.account_circle,
                  color: Colors.black12,
                  size: 23,
                ),
                labelText: "Last Name",
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
              onChanged: (value) {
                globals.loginRequestData.lastName = value;
              },
              validator: (value) {
                if (value!.trim().isEmpty) {
                  return ("Last Name cannot be Empty");
                }
                if (value.trim().length < 3)
                  return ("Last Name must be at least 3 characters");

                if (!RegExp("^[A-Za-z ]*\$").hasMatch((value)))
                  return 'Last name must contain only letters';

                if (value.trim().length > 25)
                  return ("Last Name must be at most 25 characters");
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
              minLines: 2,
              maxLines: 8,
              //      controller: _description,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.medical_services,
                  color: Colors.black12,
                  size: 23,
                ),
                labelText: "Speciality",
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
              onChanged: (value) {
                globals.loginRequestData.speciality = value;
              },
              validator: (value) {
                if (value!.trim().isEmpty) {
                  return ("Speciality cannot be Empty");
                }
                if (value.trim().length < 10)
                  return ("Speciality must be at least 10 characters");
                if (value.trim().length > 80)
                  return ("Speciality must be at most 80 characters");
                return null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
                child: TextFormField(
              minLines: 5,
              maxLines: 15,
              // controller: _description,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.stars_sharp,
                  color: Colors.black12,
                  size: 23,
                ),
                labelText: "Experience",
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
              onChanged: (value) {
                globals.loginRequestData.experience = value;
              },
              validator: (value) {
                if (value!.trim().isEmpty) {
                  return ("Experience cannot be Empty");
                }
                if (value.trim().length < 10)
                  return ("Experience must be at least 10 characters");
                if (value.trim().length > 150)
                  return ("Experience must be at most 150 characters");
                return null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ))
          ],
        ),
      ),
    );
  }

  bool isValid(log.LoginRequestData loginRequestData) {
    final FormState? formState = _form2Key.currentState;

    if (!formState!.validate()) {
      return false;
    } else {
      formState.save();
      if (globals.loginRequestData.email != '' &&
          globals.loginRequestData.password != '' &&
          globals.loginRequestData.phoneNumber != '' &&
          globals.loginRequestData.firstName != '' &&
          globals.loginRequestData.lastName != '') {
        return true;
      } else
        return false;
    }
  }

  registerUser() async {
    ScaffoldMessenger.of(context).showSnackBar(
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
    AuthenticationService authenticationService = new AuthenticationService();
    var result = await authenticationService.registerUserInfo(
        globals.loginRequestData, context);
    if (result) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const <Widget>[
              Text('Register Success'),
              Icon(Icons.check_circle),
            ],
          ),
          backgroundColor: Color(0xff7edcad),
        ),
      );
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => _successPage()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
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
                takePhoto(ImageSource.camera);
              },
              label: Text("Camera"),
            ),
            FlatButton.icon(
              icon: Icon(Icons.image),
              onPressed: () {
                takePhoto(ImageSource.gallery);
              },
              label: Text("Gallery"),
            ),
          ])
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    var pickedFile = await _picker.pickImage(
      source: source,
    );
    setState(() {
      _photoPath = pickedFile!.path;
      _imageFile = pickedFile;
      globals.loginRequestData.imageFile = _imageFile;
      Navigator.pop(context);
    });
  }

  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  String? _fileName;
  String? _saveAsFileName;
  List<PlatformFile>? _paths;
  String? _directoryPath;
  String? _extension;
  bool _isLoading = false;
  bool _userAborted = false;
  FileType _pickingType = FileType.custom;

  void _pickFiles() async {
    _resetState();
    try {
      _directoryPath = null;
      _paths = (await FilePicker.platform.pickFiles(
        type: _pickingType,
        allowMultiple: false,
        onFileLoading: (FilePickerStatus status) => print(status),
        allowedExtensions: ['pdf', 'jpg', 'png'],
      ))
          ?.files;
      globals.loginRequestData.paths = _paths;
    } on PlatformException catch (e) {
      _logException('Unsupported operation' + e.toString());
    } catch (e) {
      _logException(e.toString());
    }
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _fileName =
          _paths != null ? _paths!.map((e) => e.name).toString() : '...';
      _userAborted = _paths == null;
    });
  }

  void _logException(String message) {
    print(message);
    _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
    _scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _resetState() {
    if (!mounted) {
      return;
    }
    setState(() {
      _isLoading = true;
      _directoryPath = null;
      _fileName = null;
      _paths = null;
      _saveAsFileName = null;
      _userAborted = false;
    });
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
