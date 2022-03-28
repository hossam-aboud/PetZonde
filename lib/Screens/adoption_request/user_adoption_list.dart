import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petzone/bloc/adoption_req_list/user_reqs_list_bloc.dart';
import 'package:petzone/model/PetLover.dart';
import 'package:petzone/model/adoption_request.dart';


import '../../model/adoption_post.dart';
import '../post_request_screen.dart';
import 'adopt_request_list.dart';
import 'org_request_screen.dart';


class userAdoptionList extends StatefulWidget {
  final adoptionPost post;
  userAdoptionList(this.post, {Key? key}) : super(key: key);


  @override
  _userAdoptionListState createState() => _userAdoptionListState();
}

class _userAdoptionListState extends State<userAdoptionList> {
  late UserReqsListBloc _reqsBloc;
  late List<adoptionRequest> requests;
  late String postID;
  late adoptionPost post;
  @override
  initState() {
    super.initState();
    post = widget.post;
    postID = post.postID;
    _reqsBloc = BlocProvider.of<UserReqsListBloc>(context);
    _reqsBloc.add(LoadUserReqsListEvent(postID));

  }


  @override
  Widget build(BuildContext context) {
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
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>  orgRequestScreen()),
                      (route) => false);
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.teal[800],
            ),
          ),
        ),
        body:  BlocBuilder<UserReqsListBloc, UserReqsListState>(
        builder: (context, state) {

    if (state is UserReqsListInitial) {
    return const Center(
    child: CircularProgressIndicator(),
    );

    } else if (state is UserReqsListLoading) {
    return const Center(
    child: CircularProgressIndicator(),
    );

    } else if (state is UserReqsListLoaded) {
    requests = state.userRequests;
    if(requests.isEmpty)
    return Center(
    child: Text('No Adoption Requests', style: Theme.of(context).textTheme.headline5,),
    );
    else   return ListView.builder(
    physics: NeverScrollableScrollPhysics(), //<--here
    shrinkWrap: true,

    scrollDirection: Axis.vertical,
    itemCount: requests.length,
    itemBuilder: (context, index) {
      PetLover petLover = requests[index].perLover;
    return  GestureDetector(
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
                              foregroundImage: petLover.img == null ?
                              AssetImage('assets/defaultpfp.png') as ImageProvider
                                  :
                              Image.network(petLover.img!).image,
                            )
                        ),

                        const SizedBox(width: 10),
                        Text(petLover.firstName+ ' ' + petLover.lastName +"\n\nStatus:"+requests[index].status),
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

      onTap: ()
      {
        Navigator.push(context, MaterialPageRoute(builder: (context)=> PostsRequestScreen(petLover: requests[index], post: post)));
      }
    );
    }


    );




    } else if (state is UserReqsListFail){
    return Center(
    child: Text(state.message),
    );
    }else{return Center(child: Text("something went wrong",style: Theme.of(context).textTheme.headline5));}
    }
    )

    );
  }
}