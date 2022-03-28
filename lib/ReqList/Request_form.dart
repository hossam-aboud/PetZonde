// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:petzone/repositories/request_repository.dart';
//
// class ReqFormPL extends StatefulWidget {
//   const ReqFormPL({Key? key}) : super(key: key);
//
//   @override
//   _ReqFormPLState createState() => _ReqFormPLState();
// }
// final RequestRepository _requestRepository = RequestRepository();
// class _ReqFormPLState extends State<ReqFormPL> {
//   @override
//
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text(
//                 'Adoption Requests', style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 25,
//                 color: Colors.grey),),
//           backgroundColor: Colors.white24,
//           bottomOpacity: 0.0,
//           elevation: 0.0,
//           automaticallyImplyLeading: false,
//           toolbarHeight: 70,
//         ),
// // backgroundColor: Colors.white,
//         body:SingleChildScrollView(
//
//         child: Padding(
//         padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
//
//             child: loop()
//
//         )
//
//   )
//     );
//   }
// }
// Widget Req(String postID){
//   return Container(
//       height: 100,
//       width: 200,
//       child: StreamBuilder<QuerySnapshot>(
//           stream: FirebaseFirestore.instance
//               .collection("adoption post")
//               .where("postID", isEqualTo: postID)
//               .snapshots(),
//           builder: (context, snapshot) {
//             if (!snapshot.hasData) return const Text('loading');
//             if (snapshot.data!.docs.isEmpty) {
//               return    Container(
//                   padding: EdgeInsets.only(left:25,right:25,top: 20),
//                   child: const Text("You don't have any Request",
//                       style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 20,
//                           color: Colors.grey),
//                       textAlign: TextAlign.center)
//               );
//             }               return ListView.builder(
//                 physics: NeverScrollableScrollPhysics(), //<--here
//                 shrinkWrap: true,
//
//                 scrollDirection: Axis.vertical,
//                 itemCount: snapshot.data!.docs.length,
//                 itemBuilder: (context, index) =>
//                     Card(
//
//                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
//                         child: Container(
//
//
//                             child: ListTile(
//
//                               title: Row(
//                                 children: <Widget>[
//
//                                   Container(
//
//                                       padding: EdgeInsets.only( top: 10 , bottom: 10 ),
//                                       child:  CircleAvatar(
//                                         radius: 50,
//
//                                         child:  Hero(
//                                           tag:   (snapshot.data!).docs[index]['imgUrl'].isEmpty ? 'assets/pet_profile_picture.png':   (snapshot.data!).docs[index]['imgUrl'][0],
//                                           child: Container(
//                                             decoration: BoxDecoration(
//                                               image: DecorationImage(
//                                                 image:   (snapshot.data!).docs[index]['imgUrl'].isEmpty ? AssetImage('assets/pet_profile_picture.png') as ImageProvider: NetworkImage(  (snapshot.data!).docs[index]['imgUrl'][0]),
//                                                 fit: BoxFit.cover,
//                                               ),
//                                               borderRadius: BorderRadius.all(Radius.circular(12)
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//
//                                       )
//
//
//                                   ),
//
//                                   const SizedBox(width: 10),
//                                   Text('pet name: '+(snapshot.data!).docs[index]['pet name']+"\n\n"+"status: "+(snapshot.data!).docs[index]['status']),
//                                 ],
//                               ),
//                             )
//                         )));
//
//           }
//       ));
// }
// var postIDs;
// Widget loop()  {
//   postIDs =  getOrgAdoptionPostsReq(postIDs);
//   for(var i = 0; i < postIDs.length ; ){
//
//     return Text(postIDs[i].toString());
//     i++;
// }
//
//   return  Text("No Requests");
//
// }
// int num =0;
// List getOrgAdoptionPostsReq(var PostIDs)  {
//   postIDs = [];
// int i=0;
//   final String uid = FirebaseAuth.instance.currentUser!.uid;
//  var c = FirebaseFirestore.instance.collection('requests')
//       .where('petLoverID' , isEqualTo: uid)
//       .get()
//       .then((QuerySnapshot querySnapshot) => {
//    querySnapshot.docs.forEach((doc) =>
//         PostIDs.add(doc['postID'])
//
//     )});
//  num = PostIDs.length;
//   return PostIDs;
// }
//
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petzone/ReqList/Repository.dart';
import 'package:petzone/ReqList/reqBloc.dart';
import 'package:petzone/model/adoption_post.dart';

import '../Screens/adoption/adoption_post_detail.dart';
import '../constants.dart';
import '../widgets/custom_dialog.dart';

class ReqFormPL extends StatefulWidget {
  const ReqFormPL({Key? key}) : super(key: key);

  @override
  _ReqFormPLState createState() => _ReqFormPLState();
}
class _ReqFormPLState extends State<ReqFormPL> {
  late List<adoptionPost> reqs;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<PLReqAdoptionBloc>(context).add(DisplayReq());
  }

  @override
  late final adoptionPost pet;
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Adoption Requests",
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
      body: BlocConsumer<PLReqAdoptionBloc, PLReqAdoptionState>(
           listener: (context, state) {
             if(state is PLReqAdoptionCanceled) {
               ScaffoldMessenger.of(context)
                   .showSnackBar(
                   SnackBar(
                       backgroundColor: Colors.green,
                       content: Text('Request canceled successfully.')
                   ));
               BlocProvider.of<PLReqAdoptionBloc>(context).add(DisplayReq());
             }
             if(state is PLReqAdoptionCancelFail){
               ScaffoldMessenger.of(context)
                   .showSnackBar(
                   SnackBar(
                       backgroundColor: Color(0xffffae88),
                       content: Row(
                         children: [
                           Text('Canceling Failed. Please Try again later.'),
                           Icon(Icons.error),
                         ],
                       )
                   ));
             }
           },
            buildWhen: (previous, current) => !(current is PLReqAdoptionCanceled || current is PLReqAdoptionCancelFail),
            builder: (context, state) {
              if (state is PLReqAdoptionInitial) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is PLReqAdoptionLoading) {

                return const Center(
                  child: CircularProgressIndicator(),
                );

              }
              if (state is PLReqAdoptionSuccess) {
                reqs = state.posts;
                if(reqs.isEmpty)
                  return Center(
                    child: Text('No Adoption Requests', style: Theme.of(context).textTheme.headline5,),
                  );
                else   return ListView.builder(
                    physics: NeverScrollableScrollPhysics(), //<--here
                    shrinkWrap: true,

                    scrollDirection: Axis.vertical,
                    itemCount: reqs.length,
                    itemBuilder: (context, index) =>
                        GestureDetector(
                          child:   Card(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                              child: Container(
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(Radius.circular(20.0)
                                    ),
                                  ),

                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: <Widget>[

                                        /*
                                            ElevatedButton.icon(
                                                icon: Icon(Icons.cancel_outlined),
                                                onPressed: (){
                                                  showDialog(
                                                      barrierColor: Colors.black26,
                                                      context: context,
                                                      builder: (context)
                                                      {
                                                      return cancelDialog(context, reqs[index].reqID!, reqs[index].postID);
                                                      });
                                                },
                                                label: Text(''),
                                              style: ElevatedButton.styleFrom(
                                                primary: DeclineButton
                                              ),

                                            ), */

                                      Row(
                                        children: [
                                          Container(
                                              padding: EdgeInsets.only( top: 10 , bottom: 10 ),
                                              child:  CircleAvatar(
                                                radius: 50,
                                                foregroundImage: reqs[index].imgUrl == null ?
                                                AssetImage('assets/pet_profile_picture.png') as ImageProvider
                                                    :
                                                Image.network(reqs[index].imgUrl[0]).image,
                                              )
                                          ),
                                          const SizedBox(width: 10),
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(reqs[index].name, style: TextStyle(
                                                    color: TextColor,
                                                    fontSize: 19.0,
                                                  )),
                                                  Visibility(
                                                    visible: !reqs[index].adopted,
                                                    child:  ElevatedButton.icon(
                                                      icon: Icon(Icons.cancel_outlined, color: DeclineButton),
                                                      onPressed: (){
                                                        showDialog(
                                                            barrierColor: Colors.black26,
                                                            context: context,
                                                            builder: (context)
                                                            {
                                                              return cancelDialog(context, reqs[index].reqID!, reqs[index].postID);
                                                            });
                                                      },
                                                      label: Text('Cancel', style: TextStyle(color: DeclineButton, fontSize: 12)),
                                                      style: ElevatedButton.styleFrom(
                                                          primary: Colors.white,
                                                          elevation: 0,
                                                          fixedSize: Size(size.width*0.27, size.height*0.05)
                                                      ),
                                                  ),
                                                  )
                                                ],
                                              ),
                                              SizedBox(height: 5.0),
                                              Container(
                                                width: MediaQuery.of(context).size.width * 0.45,
                                                child: Text(
                                                  'Status: ' + reqs[index].reqStatus!,
                                                  style: TextStyle(
                                                    color: Colors.blueGrey,
                                                    fontSize: 15.0,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Icon(Icons.arrow_forward_ios_outlined),
                                    ],
                                  )
                              )),

                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context)=> adoptionPostDetail( pet: reqs[index], viewOnly: true))),
                        ));




              }

              if (state is PLReqAdoptionFail){
                return Center(
                  child: Text(state.message),
                );
              }

              else{return Center(child: Text("something went wrong",style: Theme.of(context).textTheme.headline5));}
            }

        ),
    );
  }

  cancelDialog(context, String req, String post){
    return CustomAlertDialog(
      title: "Cancel Request",
      description: "Are you sure you want to cancel this request?",
      optionOne: 'Confirm',
      optionTwo: 'Return',
      pressed: () {
        BlocProvider.of<PLReqAdoptionBloc>(context).add(CancelReq(req, post));
        Navigator.pop(context);

      },
    );
  }
}

