import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petzone/bloc/data_bloc/data_bloc.dart';
import 'package:petzone/model/adoption_post.dart';
import 'package:petzone/widgets/pet_widget.dart';

import '../../constants.dart';
import '../homepage/home_page.dart';
import 'add_adoption.dart';
import 'org_adoption_post_detail.dart';

class orgAdoptionList extends StatefulWidget {

  @override
  _orgAdoptionListState createState() => _orgAdoptionListState();
}

class _orgAdoptionListState extends State<orgAdoptionList> {

  late DataBloc _dataBloc;

  @override
  initState() {
    super.initState();
    _dataBloc = BlocProvider.of<DataBloc>(context);
    _dataBloc.add(OrgAdoptionPostEventLoad());
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
          "Adoption Posts",
          style: TextStyle(
            color: Colors.teal[800],
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => homePage()),
                    (Route<dynamic> route) => false);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.teal[800],
          ),
        ),
      ),
      body: BlocBuilder<DataBloc, DataState>(
          builder: (context, state) {

            if (state is DataInitialState) {
              return const Center(
                child: CircularProgressIndicator(),
              );

            } else if (state is DataStateLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );

            } else if (state is DataStateEmpty) {
              return Center(
                child: Text('No Adoption Posts', style: Theme.of(context).textTheme.headline5,),
              );

            } else if (state is DataStateLoadSuccess) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(9,16,9,9),
                child: Center(
                  child: GridView.count(
                    childAspectRatio: 0.8,
                    crossAxisCount: 2,
                    children: List.generate(state.docs.length, (index) {
                      adoptionPost p = state.docs[index];
                      return PetWidget(pet: p, nextPage: orgAdoptionPostDetail(pet: p));

                    }),
                  ),
                ),
              );
            } else if (state is DataErrorState){
              return Center(
                child: Text(state.message),
              );
            }else{return Center(child: Text("something went wrong"));}
          }
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateAdoptionScreen()),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: PrimaryButton,
      ),
    );
  }
}