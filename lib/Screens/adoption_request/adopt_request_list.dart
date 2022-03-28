import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petzone/Screens/adoption_request/user_adoption_list.dart';
import 'package:petzone/bloc/adoption_req_list/adoption_req_list_bloc.dart';
import 'package:petzone/model/adoption_post.dart';

class orgAdoptionRequest extends StatefulWidget{
  const orgAdoptionRequest({Key? key}) : super(key: key);

  @override
  _orgAdoptionRequest createState() => _orgAdoptionRequest();
}

class _orgAdoptionRequest extends State<orgAdoptionRequest> {

  // with AutomaticKeepAliveClientMixin<orgAdoptionRequest> { @override bool get wantKeepAlive => true;

  late List<adoptionPost> posts;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<AdoptionReqListBloc>(context).add(LoadRequestPostEvent());
  }


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdoptionReqListBloc, AdoptionReqListState>(
        builder: (context, state) {
          if (state is AdoptionReqListInitial) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is AdoptionReqListLoading) {

            return const Center(
              child: CircularProgressIndicator(),
            );

          }
          if (state is AdoptionReqListLoaded) {
            posts = state.posts;
            if(posts.isEmpty)
              return Center(
                child: Text('No Adoption Posts', style: Theme.of(context).textTheme.headline5,),
              );
            else   return ListView.builder(
                shrinkWrap: true,

                scrollDirection: Axis.vertical,
                itemCount: posts.length,
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
                                              foregroundImage: posts[index].imgUrl == null ?
                                                  AssetImage('assets/pet_profile_picture.png') as ImageProvider
                                                      :
                                                  Image.network(posts[index].imgUrl[0]).image,
                                                )

                                            ),




                                        const SizedBox(width: 10),
                                        Text(posts[index].name+'\n\nStatus: ' + (posts[index].adopted ? 'Adopted' : 'Open for Adoption')),

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

                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context)=> userAdoptionList(posts[index]))),
                    ));




          }

          if (state is AdoptionReqListFail){
            return Center(
              child: Text(state.message),
            );
          }

          else{return Center(child: Text("something went wrong",style: Theme.of(context).textTheme.headline5));}
        }

    );
  }
}