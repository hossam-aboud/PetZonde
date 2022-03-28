import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petzone/Screens/adoption/request_confirm.dart';
import 'package:petzone/Screens/posts_decision_screen.dart';
import 'package:petzone/bloc/adoption_decision/adopt_decision_bloc.dart';
import 'package:petzone/bloc/adoption_request.dart/adopt_req_bloc.dart';
import 'package:petzone/model/PetLover.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import '../constants.dart';
import '../model/adoption_post.dart';
import '../model/adoption_request.dart';
import '../widgets/custom_button.dart';
import 'adoption/adoption_post_detail.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';

class PostsRequestScreen extends StatefulWidget {
  const PostsRequestScreen(
      {Key? key, required this.petLover, required this.post})
      : super(key: key);
  final adoptionRequest petLover;
  final adoptionPost post;

  @override
  State<PostsRequestScreen> createState() => _PostsRequestScreenState();
}

class _PostsRequestScreenState extends State<PostsRequestScreen> {
  double sysWidth = 0.0;
  double sysHeight = 0.0;
  late int age;
  late final PetLover petLover;

  bool viewOnly = true;

  @override
  initState() {
    super.initState();
    petLover = widget.petLover.perLover;
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
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 75,
                  backgroundColor: Colors.grey[400],
                  backgroundImage: petLover.img == null
                      ? AssetImage('assets/defaultpfp.png') as ImageProvider
                      : Image.network(petLover.img!).image,
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Container(
                  child: Text(
                    petLover.firstName + ' ' + petLover.lastName,
                    style: TextStyle(color: Colors.black54, fontSize: 30),
                  ),
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
              Text("Request details:"),
              const SizedBox(height: 15),
                 Container(
                     padding: const EdgeInsets.fromLTRB(5,0,5,0),
                     decoration: BoxDecoration(
                         border: Border.all(color: Colors.grey),
                         borderRadius: BorderRadius.circular(15)),
                     child: PostsDecisionScreen(request: widget.petLover, post: widget.post,)),
            ],
          ),
        )));
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
