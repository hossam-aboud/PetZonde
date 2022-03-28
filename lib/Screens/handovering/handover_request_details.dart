import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petzone/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import '../../bloc/handover_request/handover_decision_bloc.dart';
import '../../model/Pet.dart';
import '../../model/PetLover.dart';
import '../../model/handover_request.dart';
import '../../widgets/custom_dialog.dart';
import '../adoption/decision_result.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HandoverRequestDetails extends StatefulWidget {
  const HandoverRequestDetails({Key? key, required this.request})
      : super(key: key);
  final Handover request;

  @override
  State<HandoverRequestDetails> createState() => _HandoverRequestDetails();
}

class _HandoverRequestDetails extends State<HandoverRequestDetails> {
  double sysWidth = 0.0;
  double sysHeight = 0.0;
  late int age;
  late final Handover request;
  late final PetLover petLover;
  late final Pet pet;

  Widget wdQuestion(String title) {
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.fromLTRB(3, 3, 3, 3),
      child: Text(
        title,
        style: const TextStyle(color: Colors.black54, fontSize: 16),
      ),
    );
  }

  @override
  initState() {
    super.initState();
    request = widget.request;
    petLover = request.petLover!;
    pet = request.pet;
    DateTime birthdate = DateFormat('MMM d, yyyy').parse(petLover.birthDate);
    age = DateTime.now().difference(birthdate).inDays ~/ 365;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    sysWidth = size.width;
    sysHeight = size.height;
    return Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            "View Request",
            style: TextStyle(
              color: Colors.teal[800],
            ),
          ),
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
        body: BlocListener<HandoverDecisionBloc, HandoverDecisionState>(
            listener: (context, state) {
              if (state is HandoverDecisionLoading) print('booo loading');
              if (state is HandoverDecisionChanged) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const DecisionResult(wasAccept: true)));
              }
              if (state is HandoverDecisionError) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.error)));
              }
            },
            child: SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 75,
                    backgroundColor: Colors.grey[400],
                    backgroundImage: petLover.img == null
                        ? AssetImage('assets/defaultpfp.png') as ImageProvider
                        : Image.network(petLover.img!).image,
                  ),
                  const SizedBox(height: 10),
                  Container(
                    child: Text(
                      petLover.firstName + ' ' + petLover.lastName,
                      style: TextStyle(color: Colors.black54, fontSize: 30),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      const Text("Phone: "),
                      Text(petLover.phoneNum),
                      const SizedBox(width: 5),
                      IconButton(
                          onPressed: () => _launchWhatsapp(petLover.phoneNum),
                          icon: Icon(
                            Icons.whatsapp,
                            size: 20,
                            color: Colors.green,
                          ))
                    ],
                  ),
                  Row(
                    children: [
                      const Text("Email: "),
                      Text(petLover.email),
                      const SizedBox(width: 5)
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Text("Age: "),
                      Text(age.toString() + ' years old'),
                      const SizedBox(width: 5)
                    ],
                  ),
                  const SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.grey[400],
                              radius: 45,
                              foregroundImage: pet.imgUrl == null
                                  ? AssetImage('assets/pet_profile_picture.png')
                                      as ImageProvider
                                  : Image.network(pet.imgUrl).image, //Text
                            ),
                            Container(
                              height: 90,
                              padding: const EdgeInsets.only(left: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    pet.petName,
                                    style: TextStyle(
                                      color: Colors.teal[800],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        pet.petAge + ' | ',
                                        style: const TextStyle(
                                            color: Colors.teal,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      pet.petGender == 'male'
                                          ? Icon(Icons.male, color: Colors.blue)
                                          : Icon(Icons.female,
                                              color: Colors.pinkAccent)
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  wdQuestion("Reason of Surrender"),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      request.reason.toString(),
                      style: TextStyle(color: Color(0xFF63D2CC), fontSize: 15),
                    ),
                  ),
                  const SizedBox(height: 10),
                  wdQuestion("Pet Description"),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      request.description.toString(),
                      style: TextStyle(color: Color(0xFF63D2CC), fontSize: 15),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (request.status != 'Accepted')
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                              barrierColor: Colors.black26,
                              context: context,
                              builder: (context) {
                                return CustomAlertDialog(
                                  title: "Reject Request",
                                  description:
                                      "Are you sure you want to reject this request?",
                                  optionOne: 'Reject',
                                  optionTwo: 'Cancel',
                                  pressed: () {
                                    BlocProvider.of<HandoverDecisionBloc>(
                                            context)
                                        .add(
                                      DecideHandover(
                                          request.requestID, "Rejected"),
                                    );
                                  },
                                );
                              },
                            );
                          },
                          style: ButtonStyle(
                              minimumSize: MaterialStateProperty.all<Size>(
                                  const Size(140, 40)),
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Color(0xFFF88A8A)),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      side: BorderSide(
                                          color: Color(0xFFF88A8A))))),
                          child: const Text("Reject",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20)),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                              barrierColor: Colors.black26,
                              context: context,
                              builder: (context) {
                                return CustomAlertDialog(
                                  title: "Accept Request",
                                  description:
                                      "Are you sure you want to accept this request?",
                                  optionOne: 'Accept',
                                  optionTwo: 'Cancel',
                                  pressed: () {
                                    BlocProvider.of<HandoverDecisionBloc>(
                                            context)
                                        .add(
                                      DecideHandover(
                                          request.requestID, "Accepted"),
                                    );
                                    Navigator.pop(context);
                                  },
                                );
                              },
                            );
                          },
                          style: ButtonStyle(
                              minimumSize: MaterialStateProperty.all<Size>(
                                  const Size(140, 40)),
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Color(0xFF63D2CC)),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      side: BorderSide(
                                          color: Color(0xFF63D2CC))))),
                          child: const Text("Accept",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20)),
                        ),
                      ],
                    )
                ],
              ),
            ))));
  }

  buildPetFeature(String value, Color? color, String feature, Size size) {
    return Expanded(
      child: Container(
        height: size.height * 0.09,
        margin: EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: Color.fromRGBO(226, 246, 240, 1),
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              feature,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              value,
              softWrap: true,
              style: TextStyle(
                color: color,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _launchWhatsapp(String number) async {
    String phoneNum = number.substring(1);
    String url = "https://wa.me/966$phoneNum";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
