
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Schedule/VetDetails.dart';

class ReqVetList extends StatefulWidget {
  const ReqVetList({Key? key}) : super(key: key);

  @override
  _ReqVetListState createState() => _ReqVetListState();
}
class _ReqVetListState extends State<ReqVetList> {
// List q = [];
  @override
  final TextEditingController _ctrlSearch = TextEditingController();

  String searchValue="";
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(

        appBar: AppBar(
          brightness: Brightness.light,
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            "  Consultation  ",
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
        body: SingleChildScrollView(
    child:


    Column(
        children: [
    Container(
    padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
          child: Material(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            elevation: 1,
            child: TextField(
              controller: _ctrlSearch,
              onChanged: (value){
                setState(() {
                  searchValue=value;
                });
              },
              decoration: InputDecoration(
                hintText: "Search Vet",
                contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black26),
                    borderRadius: BorderRadius.all(Radius.circular(15))
                ),
                prefixIcon: GestureDetector(
                  child: Icon(Icons.search,size: 20,color: Colors.lightBlue,),
                ),

              ),
            ),
          ),
        ),

    Padding(
    padding: EdgeInsets.all(10),
       child:
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("veterinarian")
                    .snapshots(),

                builder: (context2, snapshot2) {
                  if (!snapshot2.hasData) return const Center(child: CircularProgressIndicator());

                  if (snapshot2.data!.docs.isEmpty) return  Center(child: Text('No Available Veterinarians', style: Theme.of(context).textTheme.bodyText1,));

                  return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot2.data!.docs.length,
                      itemBuilder: (context2, index) {


                        if (((snapshot2.data!).docs[index]['first name'].toString().toLowerCase() +
                            (snapshot2.data!).docs[index]['last name'].toString().toLowerCase())
                            .contains(searchValue.toLowerCase())) {
                          return
                          InkWell(
                              onTap: () {
                                Navigator.push(
                                    context2,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            VetDetailss(vet: (snapshot2.data!)
                                                .docs[index])));
                              },
                              child: Card(

                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          20.0)),

                                  child: Container(

                                      child: ListTile(

                                          title: Row(

                                              children: <Widget>[

                                                Container(

                                                    padding: EdgeInsets.only(
                                                        top: 10, bottom: 10),
                                                    child: CircleAvatar(
                                                      radius: 50,
                                                      child: Hero(
                                                        tag: ((snapshot2.data!)
                                                            .docs[index]['photoUrl'] ==
                                                            null ||
                                                            (snapshot2.data!)
                                                                .docs[index]['photoUrl']
                                                                .toString()
                                                                .isEmpty)
                                                            ? 'assets/defaultpfp.png'
                                                            : (snapshot2.data!)
                                                            .docs[index]['photoUrl'],
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            image: DecorationImage(
                                                              image: ((snapshot2
                                                                  .data!)
                                                                  .docs[index]['photoUrl'] ==
                                                                  null ||
                                                                  (snapshot2
                                                                      .data!)
                                                                      .docs[index]['photoUrl']
                                                                      .toString()
                                                                      .isEmpty)
                                                                  ? const AssetImage(
                                                                  'assets/defaultpfp.png') as ImageProvider
                                                                  : NetworkImage(
                                                                  (snapshot2
                                                                      .data!)
                                                                      .docs[index]['photoUrl']),
                                                              fit: BoxFit.cover,
                                                            ),
                                                            borderRadius: BorderRadius
                                                                .all(
                                                                Radius.circular(
                                                                    50)

                                                            ),
                                                          ),
                                                        ),
                                                      ),

                                                    )


                                                ),

                                                const SizedBox(width: 10),
                                                Flexible(
                                                  child: Text(
                                                      (snapshot2.data!)
                                                          .docs[index]['first name'] +
                                                      " " + (snapshot2.data!)
                                                      .docs[index]['last name'] +
                                                      "\n\nspeciality: " +
                                                      (snapshot2.data!)
                                                          .docs[index]['speciality'],
                                                      overflow: TextOverflow
                                                          .fade,
                                                      style: TextStyle(
                                                          color: Colors
                                                              .black54)),
                                                ),
                                                SizedBox(width: 15,)
                                                ,
                                                Icon(Icons
                                                    .arrow_forward_ios_rounded,
                                                    color: Colors.black54)

                                                // Text('Name: '+(snapshot.data!).docs[index]['last name']+" "+(snapshot.data!).docs[index]['last name']+"\nspeciality: "+(snapshot.data!).docs[index]['speciality'],overflow: TextOverflow.ellipsis),


                                              ])
                                      )

                                  ))
                          );
                        } else {
                          return const SizedBox(height: 0.0);
                        }
                      });
                }
            ),

      )
    ])));
  }


}