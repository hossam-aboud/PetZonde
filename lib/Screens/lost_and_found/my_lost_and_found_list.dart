import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:petzone/Screens/lost_and_found/posts_map_view.dart';
import 'package:petzone/model/lost_and_found.dart';

import '../../bloc/lost_and_found/lost_and_found_list_bloc.dart';
import '../../constants.dart';
import '../../widgets/lfpost_widget.dart';
import 'lost_and_found_add.dart';
import 'lost_and_found_details.dart';
import 'my_lost_and_found_details.dart';



class MyLostAndFoundList extends StatefulWidget {
  @override
  createState() => _MyLostAndFoundList();
}

class _MyLostAndFoundList extends State<MyLostAndFoundList> {
  List<lostAndFoundPost>? posts;
  LostAndFoundListBloc? _lostBloc;

  @override
  initState()  {
    super.initState();
    _lostBloc = BlocProvider.of<LostAndFoundListBloc>(context);
    _lostBloc!.add(LoadMyLostAndFoundList());
  }

  @override
  Widget build(BuildContext context) {
    return  BlocBuilder<LostAndFoundListBloc, LostAndFoundListState>(
        builder: (context, state) {

          if (state is LostAndFoundListInitial) {
            return const Center(
              child: CircularProgressIndicator(),
            );

          } else if (state is LostAndFoundListLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );

          }

          else if (state is LostAndFoundListSuccess) {

            posts = state.docs;
if(posts!.isEmpty)
  return Center(child: Text("No Nearby Lost and Found posts",style: Theme.of(context).textTheme.headline5));

            return Padding(
              padding: const EdgeInsets.fromLTRB(9,16,9,9),
              child: Center(
                child: GridView.count(
                  childAspectRatio: 0.8,
                  crossAxisCount: 2,
                  children: List.generate(state.docs.length, (index) {
                    lostAndFoundPost p = state.docs[index];
                    return lostAndFoundWidget(pet: p, nextPage: MyLostAndFoundDetails(pet: p));

                  }),
                ),
              ),
            );


          } else if (state is LostAndFoundListFail){
            return Center(
              child: Text(state.message),
            );
          }else{return Center(child: Text("something went wrong"));}
        }
    );
  }

}
