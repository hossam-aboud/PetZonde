// Pet Lover :)
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petzone/Screens/adoption_request/user_adoption_list.dart';
import 'package:petzone/bloc/adoption_req_list/adoption_req_list_bloc.dart';
import 'package:petzone/model/adoption_post.dart';

import '../../bloc/handover_list/org_handover_list_bloc.dart';
import '../../model/Pet.dart';
import '../../model/PetLover.dart';
import '../../model/handover_request.dart';
import '../Screens/handovering/handover_request_details.dart';
import '../Screens/handovering/handovering_profile.dart';
import '../constants.dart';
import '../model/poster.dart';
import '../widgets/custom_dialog.dart';

class PlHandoverRequest extends StatefulWidget{
  const PlHandoverRequest({Key? key}) : super(key: key);

  @override
  _PlHandoverRequest createState() => _PlHandoverRequest();
}

class _PlHandoverRequest extends State<PlHandoverRequest> {

  late List<Handover> requests;
  @override
  void initState() {
    super.initState();
    BlocProvider.of<HandoverListBloc>(context).add(LoadPetLoverRequests());

  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Handover Requests",
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
      body: BlocConsumer<HandoverListBloc, HandoverListState>(
          listener: (context, state) {
            if(state is HandoverCanceled) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(
                  SnackBar(
                      backgroundColor: Colors.green,
                      content: Text('Request canceled successfully.')
                  ));
              BlocProvider.of<HandoverListBloc>(context).add(LoadPetLoverRequests());
            }
            if(state is HandoverCancelFail){
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
          buildWhen: (previous, current) => !(current is HandoverCanceled || current is HandoverCancelFail),
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
                    physics: NeverScrollableScrollPhysics(), //<--here
                    shrinkWrap: true,

                    scrollDirection: Axis.vertical,
                    itemCount: requests.length,
                    itemBuilder: (context, index) {
                      Handover req = requests[index];
                      Poster org = req.org!;
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

                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: <Widget>[

                                    Row(
                                      children: [
                                        Container(
                                            padding: EdgeInsets.only( top: 10 , bottom: 10 ),
                                            child:  CircleAvatar(
                                              radius: 50,
                                              foregroundImage: pet.imgUrl == null ?
                                              AssetImage('assets/pet_profile_picture.png') as ImageProvider
                                                  :
                                              Image.network(pet.imgUrl).image,
                                            )
                                        ),

                                        const SizedBox(width: 10),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(pet.petName, style: TextStyle(
                                                  color: TextColor,
                                                  fontSize: 19.0,
                                                )),
                                                Visibility(
                                                    visible: req.status == 'Pending',
                                                    child: Container(
                                                      child: ElevatedButton.icon(
                                                        icon: Icon(Icons.cancel_outlined, color: DeclineButton,),
                                                        onPressed: (){
                                                          showDialog(
                                                              barrierColor: Colors.black26,
                                                              context: context,
                                                              builder: (context)
                                                              {
                                                                return CustomAlertDialog(
                                                                  title: "Cancel Request",
                                                                  description: "Are you sure you want to cancel this request?",
                                                                  optionOne: 'Confirm',
                                                                  optionTwo: 'Return',
                                                                  pressed: () {
                                                                    BlocProvider.of<HandoverListBloc>(context).add(CancelPetLoverRequest(req.requestID));
                                                                    Navigator.pop(context);

                                                                  },
                                                                );

                                                              });
                                                        },
                                                        label: Text('Cancel', style: TextStyle(color: DeclineButton, fontSize: 12)),
                                                        style: ElevatedButton.styleFrom(
                                                            primary: Colors.white,
                                                            elevation: 0,
                                                            fixedSize: Size(size.width*0.27, size.height*0.05
                                                        ),

                                                      ),
                                                    )
                                                )
                                                )
                                              ],
                                            ),
                                            SizedBox(height: 5.0),
                                            Container(
                                              width: MediaQuery.of(context).size.width * 0.45,
                                              child: Text(
                                                'Sent To: ' + org.name,
                                                style: TextStyle(
                                                  color: Colors.blueGrey,
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            SizedBox(height: 5.0),
                                            Container(
                                              width: MediaQuery.of(context).size.width * 0.45,
                                              child: Text(
                                                'Status: ' + req.status,
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

                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context)=> HandoveringOrgProfile(org: org, viewOnly: true))),
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

      ),
    );
  }

  cancelDialog(context, String req){
    return CustomAlertDialog(
      title: "Cancel Request",
      description: "Are you sure you want to cancel this request?",
      optionOne: 'Confirm',
      optionTwo: 'Return',
      pressed: () {
        BlocProvider.of<HandoverListBloc>(context).add(CancelPetLoverRequest(req));
        Navigator.pop(context);
      },
    );
  }

}