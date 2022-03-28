import 'package:flutter/material.dart';
import 'package:petzone/constants.dart';
import 'Screens/register/org_register_screen.dart';
import 'Screens/register/petlover_register_screen.dart';
import 'Screens/register/vet_register_screen.dart';

class UserRegType extends StatelessWidget {
  const UserRegType({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = 165;

    return Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
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
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  "Select Your Role",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                Container(
                  height: size.height * 0.25,
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: ElevatedButton(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.topCenter,
                            child: Image.asset(
                              "assets/Picture1.png",
                              width: size.width * 0.35,
                              height: size.height * 0.2,
                            ),
                          ),
                          Text(
                            'Pet Lover',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ]),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      //  fixedSize: Size(size.width*0.8,height),
                      primary: PrimaryButton,
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PetLoverRegister()),
                      );
                    },
                  ),
                ),
                Container(
                  height: size.height * 0.25,
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: ElevatedButton(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.topCenter,
                            child: Image.asset(
                              "assets/PetHandPrint.png",
                              width: size.width * 0.35,
                            ),
                          ),
                          Text(
                            'Adoption Organization',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ]),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      // fixedSize: Size(size.width*0.8,height),
                      primary: PrimaryButton,
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                    ),
                    onPressed: () {
                      {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OrgRegister()),
                          //OrgRegisterScreen()),
                        );
                      }
                      ;
                    },
                  ),
                ),
                Container(
                  height: size.height * 0.25,
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: ElevatedButton(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.topCenter,
                            child: Image.asset(
                              "assets/doctor.png",
                              width: size.width * 0.3,
                              height: size.height * 0.2,
                            ),
                          ),
                          SizedBox(height: size.height * 0.001),
                          Text(
                            'Veterinarian',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ]),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      //fixedSize: Size(size.width*0.8,height),
                      primary: PrimaryButton,
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                    ),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => VetReg()));
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
