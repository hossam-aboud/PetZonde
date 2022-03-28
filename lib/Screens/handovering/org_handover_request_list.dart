import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petzone/Screens/adoption_request/user_adoption_list.dart';
import 'package:petzone/bloc/adoption_req_list/adoption_req_list_bloc.dart';
import 'package:petzone/model/adoption_post.dart';

import '../../bloc/handover_list/org_handover_list_bloc.dart';
import '../../model/Pet.dart';
import '../../model/PetLover.dart';
import '../../model/handover_request.dart';
import 'handover_request_details.dart';

class orgHandoverRequest extends StatefulWidget{
  const orgHandoverRequest({Key? key}) : super(key: key);

  @override
  _orgHandoverRequest createState() => _orgHandoverRequest();
}

class _orgHandoverRequest extends State<orgHandoverRequest> {
  
  late List<Handover> requests;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HandoverListBloc, HandoverListState>(
        builder: (context, state) {
          if (state is HandoverListInitial) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is HandoverListLoading) {

            return const Center(
              child: CircularProgressIndicator(),
            );

          }
          if (state is HandoverListSuccess) {
            requests = state.request;
            if(requests.isEmpty)
              return Center(
                child: Text('No Handover Requests', style: Theme.of(context).textTheme.headline5,),
              );
            else
              return ListView.builder(
                  shrinkWrap: true,

                  scrollDirection: Axis.vertical,
                  itemCount: requests.length,
                  itemBuilder: (context, index) {
                    Handover req = requests[index];
                    PetLover pl = req.petLover!;
                    Pet pet = req.pet;
                    return GestureDetector(
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

                                child: ListTile(

                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[

                                      Row(
                                        children: [
                                          Container(

                                              padding: EdgeInsets.only( top: 10 , bottom: 10 ),
                                              child:  CircleAvatar(
                                                radius: 50,
                                                foregroundImage: pl.img == null ?
                                                AssetImage('assets/pet_profile_picture.png') as ImageProvider
                                                    :
                                                Image.network(pl.img!).image,
                                              )

                                          ),




                                          const SizedBox(width: 10),
                                          // Text(pl.firstName+' '+pl.lastName
                                          //     +'\n\nPet: ' + pet.petName
                                          //     +'\n\nStatus: ' + req.status,style: TextStyle( color:Colors.red)),
                                          RichText(
                                            text: TextSpan(

                                           text: pl.firstName+' '+pl.lastName +'\n\nPet: ' + pet.petName, style: TextStyle(color: Colors.black87),
                                              children: <TextSpan>[
                                                if(req.status == 'Accepted')
                                                TextSpan(text: '\n\nStatus: ' + req.status, style: TextStyle(color: (Colors.green))),
                                               if (req.status == 'Rejected')
                                                TextSpan(text: '\n\nStatus: ' + req.status, style: TextStyle(color: (Colors.red))),
                                                if (req.status == 'Pending')
                                                  TextSpan(text: '\n\nStatus: ' + req.status, style: TextStyle(color: (Colors.deepOrangeAccent))),
                                                ],
                                            ),
                                          ),
                                        ],
                                      ),


                                      Column(
                                        children: <Widget>[
                                          Icon(Icons.arrow_forward_ios_outlined),

                                          SizedBox(height: 5.0),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                            )),

                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> HandoverRequestDetails(request: req)));
                        }
                    );
                  }
              );
          }

          if (state is HandoverListFail){
            return Center(
              child: Text(state.error),
            );
          }

          else{return Center(child: Text("something went wrong",style: Theme.of(context).textTheme.headline5));}
        }

    );
  }
}