import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../constants.dart';
import '../widgets/custom_button.dart';
import 'SendVatRequest2.dart';

class SendVetRequest extends StatefulWidget {
  final vet;
  const SendVetRequest({ required this.vet});

  @override
  State<SendVetRequest> createState() => _SendVetRequestState(vet: vet);
}

class _SendVetRequestState extends State<SendVetRequest> {
  final vet;
  DateTime _dateTime = DateTime.now();

  String getuser(){
    User? user = FirebaseAuth.instance.currentUser;
    return user!.uid.toString();
  }
  _SendVetRequestState( {required this.vet});
  @override
  DateTime setDate = DateTime.now();

      DocumentReference resumedata =FirebaseFirestore.instance.collection('veterinarian').doc().collection('schedule').doc('SUN');
  String reason = '';
  int t = 0;
  String? date = ' no pet have been selected';
  String? pets = 'no pet have been selected';
  String? pid;
  String? time = 'no time have been \n selected';
  String? appointID;
  int? timeIndex;
  int? petIndex;
  String title = ' ';
  String emp = '';
  String img="";
  // Future<dynamic> TimesList = [] as Future ;

  DateTime selectedDate = DateTime.now();
  TextEditingController _date = new TextEditingController();

  showDialog() async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2100)); //from db
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _date.value = TextEditingValue(
            text: DateFormat('EEE, MMM dd yyyy').format(selectedDate));
      });
    }
  }
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(


        appBar: AppBar(
          brightness: Brightness.light,
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            "Send Request",
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
        backgroundColor: Colors.white,
    body:

    SingleChildScrollView(
    child :Column(
        crossAxisAlignment: CrossAxisAlignment.start,
          children:  <Widget>[
SizedBox(height: 20),
      Container(
        margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),

        child: Text(
          'Select Day:',

          style: TextStyle(
              color:  Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.bold),
     ),
      ),
            SizedBox(height: 20),
            Container(
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
                child: GestureDetector(
                    onTap: () {

                        showDialog();
                    },
                    child: AbsorbPointer(
                      child: TextField(
                        controller: _date,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          height: 1.5,
                          fontWeight: FontWeight.bold
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xFFF6F6F6),
                          hintText: "Enter Date",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                width: 0,
                                style: BorderStyle.none,
                              )),
                        ),
                      ),
                    ))),

            // openDatePicker(),
        Container(
            margin: const EdgeInsets.fromLTRB(10, 20, 0, 0),

            child: Text(
              "Select Time:",

              style: TextStyle(
                  color:  Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
        ),
            // TimeSelection(),



            Container(
                height: 120,
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("veterinarian")
                        .doc(vet)
                        .collection("schedule")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const Text('loading');
                      if (snapshot.data!.docs.isEmpty)
                        return Padding(
                            padding: EdgeInsets.all(20),
                            child: const Text('No Available Times',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.grey),
                                textAlign: TextAlign.center));

                      int i = 0, j = 0;
                      // String txt = '';

                      return ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            // var s =  (snapshot.data!).docs[index]['data'][0].toString().split(":")[0];
                            // var t = DateTime.now().hour.toString();
                            //
                            // var date =  (snapshot.data!).docs[index]['date'].toString();
                            // DateTime d =   DateFormat('dd/MM/yyyy').parse(date);
                            // DateTime now = DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,0,0);
                            // if(s.compareTo(t)<=0 ){
                            //   if(index==(snapshot.data!.docs.length-1) && i==0)
                            //     return Text('No Available Times',
                            //         style: TextStyle(
                            //             fontWeight: FontWeight.bold,
                            //             fontSize: 20,
                            //             color: Colors.grey),
                            //         textAlign: TextAlign.center);
                            //   else
                            //     return Text('');}
                            //
                            String? stime = ((snapshot.data!).docs[index]['data'][0] );
                            //
                            //
                            //
                            //
                            // i++;

                            return OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                    padding: EdgeInsets.all(0),
                                    side: BorderSide(color: Colors.transparent)),
                                onPressed: () => changeTimeSelected(
                                    index,
                                    stime,
                                ),
                                child: Card(
                                    color: timeIndex == index
                                        ? Color(0XFF8CD3CB)
                                        : Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(20.0)),
                                    child: Container(
                                      padding:
                                      EdgeInsets.only(top: 10, bottom: 10),
                                      margin:
                                      EdgeInsets.only(left: 20, right: 20),
                                      width: 145,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50.0),
                                      ),
                                      child: Container(
                                        // margin: EdgeInsets.only(top: 10),
                                        child: ListTile(
                                          title: Text(
                                              ((snapshot.data!).docs[index]['data'][0] ) //,style: statusStyles[document['species']]
                                              ,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                  color: timeIndex == index
                                                      ? Colors.white
                                                      : Color(0XFF2F3542))),
                                        ),
                                      ),
                                    )));
                          });
                    })),










            // VVV(),
            Container(
              margin: const EdgeInsets.fromLTRB(10, 20, 0, 0),

              child: Text(
                "Select Pet:",

                style: TextStyle(
                    color:  Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),

            Container(
          padding: const EdgeInsets.all(10),
          height: 245,
          child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("pet")
                  .where('uid', isEqualTo: getuser())
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Text('loading');
                if (snapshot.data!.docs.isEmpty)
                  return Padding(
                      padding: EdgeInsets.all(20),
                      child: const Text('You haven\'t added Any Pets!',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.grey),
                          textAlign: TextAlign.center));
                return ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) => _buildListItem(
                      index, context, (snapshot.data!).docs[index]),
                );
              })),


            SizedBox(height: 15),
            // Container(
            //
            //
            //     child:      Center(
            //
            //       child: ElevatedButton(
            //         onPressed:(){
            //           Navigator.push(
            //               context,
            //               MaterialPageRoute(
            //                   builder: (BuildContext context) => SendVetRequestSec()));
            //
            //         },
            //         child: Padding(
            //             padding: EdgeInsets.only( top: 10 , bottom: 10, left: 30, right: 30),
            //             child: Text('Next', style: TextStyle( fontSize: 20 ))),
            //         style: ButtonStyle(
            //           backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFF88A8A)),
            //         ) ,
            //       ),
            //
            //
            //     )
            //
            //
            //
            //
            // ),
            Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child:
                CustomButton(
                    text: 'Next',
                    textSize: 20,
                    textColor: Colors.white,
                    color: PrimaryButton,
                    size: Size(size.width*0.5,55),
                    pressed: () {
                      // Scaffold.of(context)
                      //   ..removeCurrentSnackBar()
                      //   ..showSnackBar(
                      //     SnackBar(
                      //       content: Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: const <Widget>[
                      //           Text('Invalid Fields'),
                      //           Icon(Icons.error),
                      //         ],
                      //       ),
                      //       backgroundColor: Color(0xffffae88),
                      //     ),
                      //   );
                      Navigator.push(context, new MaterialPageRoute(builder: (context) => new SendVetRequestSec()));
                    }

                )),
  ])));
  }


  Widget _buildListItem(
      int index, BuildContext context, DocumentSnapshot document) {
    String? petName = document['name'];
    String? petID = document['petID'];
    String? url =document['img'];




    return OutlinedButton(
        style: OutlinedButton.styleFrom(
            padding: EdgeInsets.all(0),
            side: BorderSide(color: Colors.transparent)),
        onPressed: () => changePetSelected(index, petName, petID),
        child: Card(
            color: petIndex == index ?Color(0XFF8CD3CB)  : Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            child: Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(left: 20, right: 20),
              width: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                color: petIndex == index ? Color(0XFF8CD3CB) : Colors.white,
              ),
              child: Column(children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(

                        padding: EdgeInsets.only(
                            top: 10, bottom: 0),
                        child: CircleAvatar(
                          radius: 65,
                          child: Hero(
                            tag: (url ==
                                null ||
                                url.toString()
                                    .isEmpty)
                                ? 'assets/pet_profile_picture.png'
                                : new AssetImage(url),
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: (url ==
                                      null ||
                                      url
                                          .toString()
                                          .isEmpty)
                                      ? const AssetImage(
                                      'assets/pet_profile_picture.png') as ImageProvider
                                      : NetworkImage(
                                      url),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius
                                    .all(
                                    Radius.circular(
                                        30)

                                ),
                              ),
                            ),
                          ),

                        )


                    ),

                  ],
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: 0,
                  ),
                  child: ListTile(
                      title: Text(
                          "   " +
                              document['name'] //,style: statusStyles[document['species']]
                          ,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color: petIndex == index
                                  ? Colors.white
                                  : Color(0XFF2F3542)))),
                ),





              ]),
            )));
  }
  changePetSelected(int index, String? p, String? petId) {
    setState(() {
      petIndex = index;
      pets = p;
      pid = petId;
    });
  }

  Widget openDatePicker() {
    // getDays();
    return Center(
        child: Container(
          // margin: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 60),
            width: 350,
            height: 200,
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.blueGrey, width: 2),
                borderRadius: BorderRadius.all(Radius.circular(40)),
             ),
            child: CalendarDatePicker(
              initialDate: setDate,
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(Duration(days: 100000)),
              onDateChanged: (DateTime value) {
                setState(() {
                  _dateTime = value;
                });
              },

            )));
  }
//
// Widget TimeSelection (){
//
//     var ref;
//     return  Container(
//   height: 120,
//   padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
//   child: StreamBuilder<QuerySnapshot>(
//   stream: FirebaseFirestore.instance
//       .collection('veterinarian')
//       .doc('cKP2en2osew0HbvhUQUL')
//       .collection('schedule')
//       .where('data',
//       arrayContains: {
//     "start",
//     "end"
//   }).snapshots(),
//   builder: (context, snapshot) {
//   if (!snapshot.hasData) return const Text('loading');
//   if (snapshot.data!.docs.isEmpty)
//   return Padding(
//   padding: EdgeInsets.all(20),
//   child: const Text('No Available Times',
//   style: TextStyle(
//   fontWeight: FontWeight.bold,
//   fontSize: 20,
//   color: Colors.grey),
//   textAlign: TextAlign.center));
//   //
//   // int i = 0, j = 0;
//   // String txt = '';
//
//   return ListView.builder(
//   shrinkWrap: true,
//   scrollDirection: Axis.horizontal,
//   itemCount: snapshot.data!.docs.length,
//   itemBuilder: (context, index) {
//   // var s =  (snapshot.data!).docs[index]
//   // ['start'].toString().split(":")[0];
//   // var t = DateTime.now().hour.toString();
//
//   // var date =  (snapshot.data!).docs[index]
//   // ['date'].toString();
//   // DateTime d =   DateFormat('dd/MM/yyyy').parse(date);
//   // DateTime now = DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,0,0);
//   // if(s.compareTo(t)<=0 && d.isAtSameMomentAs(now)){
//   // if(index==(snapshot.data!.docs.length-1) && i==0)
//   // return Text('No Available Times',
//   // style: TextStyle(
//   // fontWeight: FontWeight.bold,
//   // fontSize: 20,
//   // color: Colors.grey),
//   // textAlign: TextAlign.center);
//   // else
//   // return Text('');}
//
//   String? stime = ((snapshot.data!).docs[index]
//   ['data'][0]+ ' - ' + (snapshot.data!).docs[index]['data'][0]);
//
//
//
//
//   // i++;
//
//   return OutlinedButton(
//   style: OutlinedButton.styleFrom(
//   padding: EdgeInsets.all(0),
//   side: BorderSide(color: Colors.transparent)),
//   onPressed: () => changeTimeSelected(
//   index,
//   stime,
//  "0"),
//   child: Card(
//   color: timeIndex == index
//   ? Color(0XFFFF6B81)
//       : Colors.white,
//   shape: RoundedRectangleBorder(
//   borderRadius:
//   BorderRadius.circular(20.0)),
//   child: Container(
//   padding:
//   EdgeInsets.only(top: 10, bottom: 10),
//   margin:
//   EdgeInsets.only(left: 20, right: 20),
//   width: 145,
//   decoration: BoxDecoration(
//   borderRadius: BorderRadius.circular(50.0),
//   ),
//   child: Container(
//   // margin: EdgeInsets.only(top: 10),
//   child: ListTile(
//   title: Text(
//   ((snapshot.data!).docs[index]
//   ['data'][0] +
//   ' - ' +
//   (snapshot.data!).docs[index][
//   'data'][0]) //,style: statusStyles[document['species']]
//   ,
//   style: TextStyle(
//   fontWeight: FontWeight.bold,
//   fontSize: 18,
//   color: timeIndex == index
//   ? Colors.white
//       : Color(0XFF2F3542))),
//   ),
//   ),
//   )));
//   });
//   }));
//   }
//
//
//   Stream<Time> get firebaseTime {
//     return FirebaseFirestore.instance.collection('students').snapshots().map(_firebaseStudentsFromSnapshot);
//   }
//   List<List<Time>> _firebaseStudentsFromSnapshot(QuerySnapshot snapshot) {
//     return snapshot.docs.map((doc) {
//       List<Time> t = [];
//       List<dynamic> markMap = snapshot.docs[0]['data'];
//       markMap.forEach((element) {
//         t.add(new Time(
//             start: element['start'],
//              end: element['end']
//         ));
//       });
//       return t;
//     }).toList();
//   }
  changeTimeSelected(int index, String? t) {
    setState(() {
      timeIndex = index;
      time = t;
    });
  }
//   gettimes() async {
//     final value = await FirebaseFirestore.instance
//         .collection("veterinarian")
//         .doc()
//         .collection("schedule").doc()
//         .get();
//
//     TimesList = value.data()!["data"];
//   }
}