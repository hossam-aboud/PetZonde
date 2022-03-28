import 'package:carousel_slider/carousel_slider.dart';
import 'package:petzone/model/globals.dart' as globals;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../constants.dart';
import '../widgets/custom_button.dart';



class SendVetRequestSec extends StatefulWidget {
  const SendVetRequestSec({Key? key}) : super(key: key);

  @override
  State<SendVetRequestSec> createState() => _SendVetRequestSecState();
}

class _SendVetRequestSecState extends State<SendVetRequestSec> {
  final ImagePicker imagePicker = ImagePicker();
  List<Image>? imageFileList = [];
  int _current = 0;
  final CarouselController _controller = CarouselController();


  final ReasonControl = TextEditingController();


  final TextEditingController Reason = TextEditingController();

  void initState() {
    Image _add = Image.asset('assets/add.jpg');
    imageFileList!.add(_add);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Send Request', style: TextStyle(
            fontSize: 23,
            color: Colors.grey),),
        backgroundColor: Colors.white24,
        bottomOpacity: 0.0,
        elevation: 0.0,
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(
          color: Colors.grey, //change your color here
        ),
        toolbarHeight: 50,
      ),
      // backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
       children: [
         SizedBox(height: 20),
         Container(
           height: 300.0,
           child: Stack(
             children: <Widget>[
               Positioned(
                 top: 10.0,
                 left: 0.0,
                 right: 0.0,
                 child: Container(
                   padding: EdgeInsets.symmetric(horizontal: 20.0),
                   child: DecoratedBox(
                     decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(10.0),
                     ),
                     child: Row(
                       children: [
                         Expanded(
                           child: imageFileList!.length !=1 ?
                           Container(
                             height:  210,
                             //  color: Color(0xFFf0f4f4),
                             child:  Column(
                                 mainAxisAlignment: MainAxisAlignment.center,
                                 children: [
                                   CarouselSlider(
                                     items: imageFileList!.map((img) {
                                       return Builder(
                                         builder: (BuildContext context) {
                                           int i = imageFileList!.indexOf(img);
                                           return i== 0 ?
                                           GestureDetector(
                                               onTap: () {
                                                 selectImages();
                                               },
                                               child: Container(
                                                   width: MediaQuery.of(context).size.width,
                                                   margin: EdgeInsets.symmetric(horizontal: 5.0),
                                                   decoration: BoxDecoration(
                                                       color: Colors.white
                                                   ),
                                                   child: Image(image: img.image,
                                                     fit: BoxFit.cover,)
                                               ))
                                               :  Stack(
                                             children: [
                                               Container(
                                                   width: MediaQuery.of(context).size.width,
                                                   margin: EdgeInsets.symmetric(horizontal: 5.0),
                                                   decoration: BoxDecoration(
                                                       color: Colors.white,


                                                   ),
                                                   child: Image(image: img.image,
                                                     fit: BoxFit.cover,)
                                               ),
                                               ElevatedButton(
                                                 onPressed: () {
                                                   setState(() {
                                                     imageFileList!.removeAt(i);
                                                   });
                                                 },
                                                 child: Text('✖'),
                                                 style: ElevatedButton.styleFrom(
                                                   primary: Colors.black.withOpacity(0.4),
                                                   shape: CircleBorder(),
                                                   padding: EdgeInsets.all(0.5),
                                                 ),
                                               )
                                             ],
                                           );
                                         },
                                       );
                                     }).toList(),
                                     carouselController: _controller,
                                     options: CarouselOptions(
                                         height: 180,
                                         enlargeCenterPage: true,
                                         aspectRatio:1.0,
                                         onPageChanged: (index, reason) {
                                           setState(() {
                                             _current = index;
                                           });
                                         }),
                                   ),
                                   Row(
                                     mainAxisAlignment: MainAxisAlignment.center,
                                     children: imageFileList!.asMap().entries.map((entry) {
                                       return GestureDetector(
                                         onTap: () => _controller.animateToPage(entry.key),
                                         child: Container(
                                           width: 12.0,
                                           height: 12.0,
                                           margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                                           decoration: BoxDecoration(
                                               shape: BoxShape.circle,
                                               color: (Theme.of(context).brightness == Brightness.dark
                                                   ? Colors.white
                                                   : DeclineButton)
                                                   .withOpacity(_current == entry.key ? 1 : 0.4)),
                                         ),
                                       );
                                     }).toList(),
                                   ),

                                 ]
                             ),) :
                           Container(
                             decoration: BoxDecoration(
                                 borderRadius: BorderRadius.circular(10.0),
                                 boxShadow: [ //background color of box
                                   BoxShadow(
                                     color: Colors.grey.withOpacity(0.5),
                                     blurRadius: 20.0, // soften the shadow
                                     spreadRadius: 5.0, //extend the shadow
                                     offset: Offset(
                                       1.0, // Move to right 10  horizontally
                                       5.0, // Move to bottom 10 Vertically
                                     ),
                                   )
                                 ],
                                 color: Colors.white),
                             height:  210,
                             //  color: Color(0xFFf0f4f4),
                             child: GestureDetector(
                                 onTap: () {
                                   selectImages();
                                 },
                                 child:
                                 Column(
                                     mainAxisAlignment: MainAxisAlignment.center,
                                     children: [
                                       Text('Upload Pet\'s Picture', style: TextStyle(fontSize: 18, color: SubTextColor)),
                                       SizedBox(height: 10,),
                                       CircleAvatar(
                                         radius: 40,
                                         backgroundColor: Color(0xffD0F1EB),
                                         foregroundImage: Image.asset('assets/pickimage.png').image,
                                       )
                                     ]



                                 )
                             ),),
                         )


                       ],
                     ),
                   ),
                 ),
               )
             ],
           ),
         ),

         descField("Reason...."),


         SizedBox(height: 15),


             // Center(
             //
             //   child: ElevatedButton(
             //     onPressed:(){
             //       // Navigator.push(
             //       //     context,
             //       //     MaterialPageRoute(
             //       //         builder: (BuildContext context) => SendVetRequestSec()));
             //
             //     },
             //     child: Padding(
             //         padding: EdgeInsets.only( top: 10 , bottom: 10, left: 30, right: 30),
             //         child: Text('Send Request', style: TextStyle( fontSize: 20 ))),
             //     style: ButtonStyle(
             //       backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFF88A8A)),
             //     ) ,
             //   ),
             //
             //
             // )

           Container(
             alignment: Alignment.center,
             margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
             child:
             CustomButton(
                 text: 'Send Request ',
                 textSize: 20,
                 textColor: Colors.white,
                 color: PrimaryButton,
                 size: Size(size.width*0.8,55),
                 pressed: () {
                   Scaffold.of(context)
                     ..removeCurrentSnackBar()
                     ..showSnackBar(
                       SnackBar(
                         content: Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: const <Widget>[
                             Text('Invalid Fields'),
                             Icon(Icons.error),
                           ],
                         ),
                         backgroundColor: Color(0xffffae88),
                       ),
                     );

                 }

             )),



       ],
        ),
      ),
    );
  }


  Widget descField(String _label){  return Container(
    width: double.infinity,
    height: 200,
    padding: const EdgeInsets.only(left: 20, right: 15),

    child: TextFormField(
      controller: ReasonControl,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter description';
        }
        if (value.length < 10) {
          return 'Pet description must be 10 characters or longer';
        }
        if (value.length > 250) {
          return 'Pet description must not exceed 250 characters';
        }
        if(!RegExp(r'^[A-Za-z0-9,. ]+$').hasMatch(value))
          return 'Pet description must not have special characters.';
        return null;
      },
      textAlign: TextAlign.start,
      minLines: 6,
      maxLines: 10,
      decoration: InputDecoration(
        labelText: 'Reason',
        filled: true,
        fillColor: Color(0xFFE5E5E5),
        floatingLabelStyle: TextStyle(fontWeight: FontWeight.bold, color: TextColor),
        focusedBorder: OutlineInputBorder(
          borderRadius: new BorderRadius.circular(25.0),
          borderSide: BorderSide(color: Color(0xFFE5E5E5), width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: new BorderRadius.circular(30.0),
          borderSide: BorderSide(color: Color(0xFFE5E5E5), width: 2.0),
        ),
      ),

      style: TextStyle(
          fontSize: 18,
          color: SubTextColor
      ),
    ),
  );}




  void selectImages() async {

    final List<XFile>? selectedImages = await
    imagePicker.pickMultiImage();
    if (selectedImages!.isNotEmpty) {
      //imageFileList!.addAll(selectedImages);
      for(XFile i in selectedImages){
        Image img = Image.file(File(i.path));
        imageFileList!.add(img);}
    }
    print("Image List Length:" + imageFileList!.length.toString());
    setState((){});
  }
}
