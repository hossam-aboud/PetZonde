import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petzone/repositories/admin_repository.dart';
import '../../constants.dart';
import '../../model/UserRegister.dart';
import '../../bloc/registerList/register_request_bloc.dart';
import 'admin_register_profile.dart';

class RegisterRequestList extends StatelessWidget {
  AdminRepository adminRepository = AdminRepository();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => RegisterRequestBloc(adminRepository: adminRepository)
          ..add(UpdateListEvent('All')),
        child: Scaffold(
          appBar: AppBar(
            brightness: Brightness.light,
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: Text(
              "User Configuration",
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
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  child: BlocBuilder<RegisterRequestBloc, RegisterRequestState>(
                builder: (context, state) {
                  if (state is LoadingState)
                    return Center(
                        child: CircularProgressIndicator(color: PrimaryButton));
                  else if (state is LoadedState) {
                    List<Future<User?>> list = state.requestList;
                    return Column(children: <Widget>[
                      SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(mainAxisSize: MainAxisSize.min, children: <
                              Widget>[
                            SizedBox(width: 10),
                            ElevatedButton(
                              style: ButtonStyle(
                                  elevation: MaterialStateProperty.all(0),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    side: BorderSide(
                                      width: 1,
                                      color: LightColor,
                                    ),
                                    borderRadius: BorderRadius.circular(18.0),
                                  )),
                                  backgroundColor: state.tag == 'All'
                                      ? MaterialStateProperty.all(LightColor)
                                      : MaterialStateProperty.all(
                                          Colors.white)),
                              onPressed: () {
                                BlocProvider.of<RegisterRequestBloc>(context)
                                    .add(UpdateListEvent('All'));
                              },
                              child: Text("All",
                                  style: TextStyle(color: Colors.black87)),
                            ),
                            SizedBox(width: 10),
                            ElevatedButton(
                              style: ButtonStyle(
                                  elevation: MaterialStateProperty.all(0),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    side: BorderSide(
                                      width: 1,
                                      color: LightColor,
                                    ),
                                    borderRadius: BorderRadius.circular(18.0),
                                  )),
                                  backgroundColor: state.tag == 'Vet'
                                      ? MaterialStateProperty.all(LightColor)
                                      : MaterialStateProperty.all(
                                          Colors.white)),
                              onPressed: () {
                                context
                                    .read<RegisterRequestBloc>()
                                    .add(UpdateListEvent('Vet'));
                              },
                              child: Text("Veterinarians",
                                  style: TextStyle(color: Colors.black87)),
                            ),
                            SizedBox(width: 10),
                            ElevatedButton(
                              style: ButtonStyle(
                                  elevation: MaterialStateProperty.all(0),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    side: BorderSide(
                                      width: 1,
                                      color: LightColor,
                                    ),
                                    borderRadius: BorderRadius.circular(18.0),
                                  )),
                                  backgroundColor: state.tag == 'Org'
                                      ? MaterialStateProperty.all(LightColor)
                                      : MaterialStateProperty.all(
                                          Colors.white)),
                              onPressed: () {
                                BlocProvider.of<RegisterRequestBloc>(context)
                                    .add(UpdateListEvent('Org'));
                              },
                              child: Text("Adoption Organizations",
                                  style: TextStyle(color: Colors.black87)),
                            ),
                            SizedBox(width: 10),
                            ElevatedButton(
                              style: ButtonStyle(
                                  elevation: MaterialStateProperty.all(0),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    side: BorderSide(
                                      width: 1,
                                      color: LightColor,
                                    ),
                                    borderRadius: BorderRadius.circular(18.0),
                                  )),
                                  backgroundColor: state.tag == 'Pet'
                                      ? MaterialStateProperty.all(LightColor)
                                      : MaterialStateProperty.all(
                                          Colors.white)),
                              onPressed: () {
                                BlocProvider.of<RegisterRequestBloc>(context)
                                    .add(UpdateListEvent('Pet'));
                              },
                              child: Text("Pet Lover",
                                  style: TextStyle(color: Colors.black87)),
                            ),
                          ])),
                      if (list.isEmpty)
                        Center(
                            heightFactor: 8,
                            child: Text('There\'s No New Requests',
                                style: TextStyle(
                                    color: TextColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500)))
                      else
                        Expanded(
                          child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              padding: EdgeInsets.only(top: 10.0, bottom: 15.0),
                              physics: ClampingScrollPhysics(),
                              itemCount: list.length,
                              itemBuilder: (context, index) {
                                return FutureBuilder<User?>(
                                    future: list[index],
                                    builder: (context,
                                        AsyncSnapshot<User?> userSnapshot) {
                                      if (userSnapshot.hasData)
                                        return GestureDetector(
                                          onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  RegisterRequestView(
                                                      user: userSnapshot.data!),
                                            ),
                                          ),
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                top: 5.0,
                                                bottom: 5.0,
                                                right: 10.0,
                                                left: 6),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20.0,
                                                vertical: 10.0),
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black26,
                                                  blurRadius: 4,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20.0)),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Row(
                                                  children: <Widget>[
                                                    CircleAvatar(
                                                      radius: 35.0,
                                                      backgroundColor:
                                                          Colors.grey,
                                                      foregroundImage: userSnapshot
                                                                  .data!
                                                                  .photo ==
                                                              null
                                                          ? AssetImage(
                                                              "assets/defaultpfp.png")
                                                          : Image.network(
                                                                  userSnapshot
                                                                      .data!
                                                                      .photo!)
                                                              .image,
                                                    ),
                                                    SizedBox(width: 10.0),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                          userSnapshot
                                                              .data!.name,
                                                          style: TextStyle(
                                                            color: TextColor,
                                                            fontSize: 19.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        SizedBox(height: 5.0),
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.45,
                                                          child: Text(
                                                            (userSnapshot.data!
                                                                        .runtimeType ==
                                                                    Vet)
                                                                ? 'Veterinarian'
                                                                : userSnapshot
                                                                            .data!
                                                                            .runtimeType ==
                                                                        Org
                                                                    ? 'Adoption Organization'
                                                                    : 'Pet Lover',
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .blueGrey,
                                                              fontSize: 15.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  children: <Widget>[
                                                    Icon(Icons
                                                        .arrow_forward_ios_outlined),
                                                    SizedBox(height: 5.0),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      return Container(
                                        width: 0.0,
                                        height: 0.0,
                                      );
                                    });
                              }),
                        )
                    ]);
                  } else
                    return Center(
                        child: Text('Something Went Wrong.',
                            style: TextStyle(
                                color: SubTextColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w500)));
                },
              )),
            ],
          ),
        ));
  }
}
