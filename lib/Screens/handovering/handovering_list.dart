import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petzone/bloc/handovering/handovering_list_bloc.dart';

import '../../model/poster.dart';
import 'handovering_profile.dart';


class HandoveringOrgList extends StatefulWidget{
  const HandoveringOrgList({Key? key}) : super(key: key);

  @override
  _HandoveringOrgListState createState() => _HandoveringOrgListState();
}

class _HandoveringOrgListState extends State<HandoveringOrgList> {

  // with AutomaticKeepAliveClientMixin<orgAdoptionRequest> { @override bool get wantKeepAlive => true;

  late List<Poster> orgList;

  @override
  Widget build(BuildContext context) {
   return Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            "Adoption Organization",
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

        body: BlocProvider(create: (_) => HandoveringListBloc()..add(const LoadHandoveringList()),
    child: BlocBuilder<HandoveringListBloc, HandoveringListState>(
        builder: (context, state) {
          if (state is HandoveringListInitial) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is HandoveringListLoading) {

            return const Center(
              child: CircularProgressIndicator(),
            );

          }
          if (state is HandoveringListLoaded) {
            orgList = state.orgList;
            if(orgList.isEmpty)
              return Center(
                child: Text('No Nearby Adoption Organization', style: Theme.of(context).textTheme.headline5,),
              );
            else   return SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                      physics: NeverScrollableScrollPhysics(), //<--here
                      shrinkWrap: true,

                      scrollDirection: Axis.vertical,
                      itemCount: orgList.length,
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
                                                    backgroundColor: Colors.white,
                                                    foregroundImage:                                                     orgList[index].img == null ?
                                                    AssetImage('assets/defaultpfp.png') as ImageProvider
                                                        :
                                                    Image.network(orgList[index].img!).image,

                                                  )


                                              ),

                                              const SizedBox(width: 10),
                                              Text(orgList[index].name),
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

                             onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> HandoveringOrgProfile(org: orgList[index]))),
                          ))


                ],


              )

            );




          }

          if (state is HandoveringListFail){
            return Center(
              child: Text(state.message),
            );
          }

          else{return Center(child: Text("something went wrong",style: Theme.of(context).textTheme.headline5));}
        }

    )
        )
   );
  }
}