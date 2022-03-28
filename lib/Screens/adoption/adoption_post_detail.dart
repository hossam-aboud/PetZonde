import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:petzone/Screens/adoption/send_adoption_request.dart';
import 'package:petzone/model/adoption_post.dart';
import 'package:petzone/widgets/custom_button.dart';

import '../../constants.dart';

class adoptionPostDetail extends StatelessWidget {
  final adoptionPost pet;
  bool? viewOnly;

  adoptionPostDetail({required this.pet, this.viewOnly});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: true,
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
        body: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  pet.imgUrl.length == 1
                      ? Container(
                          height: size.height * 0.5,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: pet.imgUrl.isEmpty
                                  ? AssetImage('assets/pet_profile_picture.png')
                                      as ImageProvider
                                  : NetworkImage(pet.imgUrl[0]),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(25),
                              bottomRight: Radius.circular(25),
                            ),
                          ),
                        )
                      : CarouselSlider(
                          options: CarouselOptions(
                            height: size.height * 0.5,
                            enableInfiniteScroll: false,
                            enlargeCenterPage: true,
                            viewportFraction: 0.8,
                            aspectRatio: 2,
                          ),
                          items: pet.imgUrl.map((i) {
                            return Builder(
                              builder: (BuildContext context) {
                                return Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: pet.imgUrl.isEmpty
                                          ? AssetImage(
                                                  'assets/pet_profile_picture.png')
                                              as ImageProvider
                                          : NetworkImage(i),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(25),
                                      bottomRight: Radius.circular(25),
                                    ),
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        ),
                  Expanded(
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      pet.name,
                                      style: TextStyle(
                                        color: Colors.teal[800],
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24,
                                      ),
                                    ),
                                    SizedBox(
                                      height: size.height * 0.01,
                                    ),
                                    Text(
                                      pet.petAge,
                                      style: const TextStyle(
                                          color: Colors.teal,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(8, 0, 10, 8),
                            child: Row(
                              children: [
                                buildPetFeature(
                                    pet.petGender,
                                    pet.petGender == "Female"
                                        ? Colors.red[200]
                                        : Colors.blue[200],
                                    "Sex",
                                    size),
                                buildPetFeature(
                                    pet.city, Colors.teal[700], "City", size),
                                buildPetFeature(
                                    pet.breed, Colors.teal[700], "Breed", size),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.03,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              "Details",
                              style: TextStyle(
                                color: Colors.teal[800],
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.01,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                Icon(
                                  pet.isVacc == 'True'
                                      ? Icons.done_sharp
                                      : Icons.close,
                                  color: Colors.red[200],
                                  size: 20,
                                ),
                                SizedBox(
                                  width: size.width * 0.01,
                                ),
                                Text(
                                  pet.isVacc == 'True'
                                      ? 'Vaccinated    '
                                      : 'Not Vaccinated ',
                                  style: TextStyle(
                                      color: Colors.red[200],
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700),
                                ),
                                Icon(
                                  pet.isSet == 'True'
                                      ? Icons.done_sharp
                                      : Icons.close,
                                  color: Colors.red[200],
                                  size: 20,
                                ),
                                SizedBox(
                                  width: size.width * 0.005,
                                ),
                                Text(
                                  pet.isSet == 'True'
                                      ? 'Sterilized'
                                      : 'Not Sterilized',
                                  style: TextStyle(
                                      color: Colors.red[200],
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ),
                          Container(
                              margin: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                              padding: const EdgeInsets.all(10),
                              width: size.width,
                              decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  )),
                              child: Text(
                                pet.petDesc.isEmpty
                                    ? "No description"
                                    : pet.petDesc,
                                softWrap: true,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 17,
                                ),
                              )),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Visibility(
                                  visible: viewOnly == null ? true : false,
                                  child: Container(
                                    alignment: Alignment.center,
                                    //margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                                    child: CustomButton(
                                      text: 'Adopt',
                                      textSize: 20,
                                      textColor: Colors.white,
                                      color: PrimaryButton,
                                      size: Size(size.width * 0.5, 55),
                                      pressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    sendAdoptionRequest(
                                                        postID: pet.postID,
                                                        pet: pet)));
                                      },
                                    ),
                                  ))
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ));
  }

  buildPetFeature(String value, Color? color, String feature, Size size) {
    return Expanded(
      child: Container(
        height: size.height * 0.1,
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
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Text(
                value,
                softWrap: true,
                style: TextStyle(
                  color: color,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
