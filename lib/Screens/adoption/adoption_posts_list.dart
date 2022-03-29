import 'dart:developer';
import 'dart:ui';

import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petzone/bloc/data_bloc/data_bloc.dart';
import 'package:petzone/constants.dart';
import 'package:petzone/model/adoption_post.dart';
import 'package:petzone/widgets/pet_widget.dart';

import 'adoption_post_detail.dart';

class adoptionList extends StatefulWidget {
  @override
  createState() => _adoptionList();
}

class _adoptionList extends State<adoptionList> {
  late DataBloc _dataBloc;
  String? valueName, valueCity;
  var allPosts = <adoptionPost>[];

  @override
  initState() {
    super.initState();
    _dataBloc = BlocProvider.of<DataBloc>(context);
    _dataBloc.add(PetloverAdoptionPostEventLoad());
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
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.teal[800],
          ),
        ),
      ),
      body: BlocBuilder<DataBloc, DataState>(builder: (context, state) {
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
            child: Text(
              'No adoption posts',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          );
        } else if (state is DataStateLoadSuccess) {
          if (allPosts.isEmpty) {
            allPosts = state.docs;
          }
          var city = state.docs.map((e) => e.city).toSet().toList();
          var name = state.docs.map((e) => e.name).toSet().toList();
          if (valueCity != null && valueName == null ) {
            allPosts = state.docs
                .where((element) => element.city == valueCity)
                .toList();
          }else if (valueName != null && valueCity == null){
            allPosts = state.docs
                .where((element) => element.name == valueCity)
                .toList();

          }else if (valueName != null && valueCity != null){
            allPosts = state.docs
                .where((element) => (element.city == valueCity) && (element.name == valueName))
                .toList();
          }
          return Padding(
            padding: const EdgeInsets.fromLTRB(9, 7.0, 9, 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 9.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        SizedBox(width: 10),
                        Expanded(
                          child: DropdownButton<String>(
                            value: valueCity,
                            items: city
                                .map(
                                  (e) => DropdownMenuItem(
                                    child: Text(e),
                                    value: e,
                                  ),
                                )
                                .toList(),
                            hint: Text(
                              "Select City",
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                            onChanged: (value) {
                              valueCity = value.toString();

                              setState(() {});
                            },
                          ),
                        ),
                        SizedBox(
                          width: 30.0,
                        ),
                        Expanded(
                          child: DropdownButton<String>(
                            value: valueName,
                            items: name
                                .map(
                                  (e) => DropdownMenuItem(
                                    child: Text(e),
                                    value: e,
                                  ),
                                )
                                .toSet()
                                .toList(),
                            hint: Text(
                              "Select Name",
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                valueName = value.toString();
                              });
                            },
                          ),
                        ),
                      ]),
                ),
                Expanded(
                  child: GridView.count(
                    childAspectRatio: 0.8,
                    crossAxisCount: 2,
                    children: List.generate(allPosts.length, (index) {
                      adoptionPost? p;
                      p = allPosts[index];

                      return PetWidget(
                          pet: p, nextPage: adoptionPostDetail(pet: p));
                    }),
                  ),
                ),
              ],
            ),
          );
        } else if (state is DataErrorState) {
          return Center(
            child: Text(state.message),
          );
        } else {
          return Center(child: Text("something went wrong"));
        }
      }),
    );
  }

  openFilterDialog(List<adoptionPost> posts) async {
    var selectedCityList = [];
    await FilterListDialog.display<String>(
      context,
      headlineText: 'Select City',
      listData: posts.map((e) => e.city).toSet().toList(),
      choiceChipLabel: (posts) => posts,
      validateSelectedItem: (list, val) => list!.contains(val),
      onItemSearch: (posts, query) {
        return posts.toLowerCase().contains(query.toLowerCase());
      },
      onApplyButtonClick: (list) {
        selectedCityList = list ?? [];
      },
    );
    return selectedCityList;
  }
}
