import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petzone/bloc/handover_request/handover_request_bloc.dart';
import '../../constants.dart';
import '../../model/Pet.dart';
import '../../service/notification_service.dart';
import '../../widgets/custom_button.dart';
import 'handover_confirm.dart';

class SendHandoverRequest extends StatefulWidget {
  final String orgID;

  const SendHandoverRequest({Key? key, required this.orgID}) : super(key: key);

  @override
  _SendHandoverRequest createState() => _SendHandoverRequest();
}

class _SendHandoverRequest extends State<SendHandoverRequest> {
  final FCMNotificationService _fcmNotificationService =
      FCMNotificationService();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _reason = TextEditingController();
  final TextEditingController _description = TextEditingController();
  double sysWidth = 0.0;
  double sysHeight = 0.0;
  Pet? selectedPet;
  String? petID;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    sysWidth = size.width;
    sysHeight = size.height;
    return Scaffold(
        backgroundColor: Colors.white,
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
        body: SingleChildScrollView(
          child: BlocProvider(
            create: (context) => HandoverRequestBloc()..add(LoadPets()),
            child: BlocConsumer<HandoverRequestBloc, HandoverRequestState>(
              listener: (BuildContext context, state) {
                if (state is HandoverRequestSuccess) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RequestHandoverConfirm()));
                }
                if (state is HandoverRequestFail) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(state.error)));
                  Navigator.pop(context);
                }
                if (state is HandoverRequestEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('You don\'t have any added pets')));
                  Navigator.pop(context);
                }
              },
              builder: (BuildContext context, Object? state) {
                if (state is HandoverRequestInitial)
                  return Center(
                    child: CircularProgressIndicator(),
                  );

                if (state is HandoverRequestLoaded)
                  return Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
                        child: Column(
                          children: [
                            DropdownButtonHideUnderline(
                              child: DropdownButtonFormField<Pet>(
                                isExpanded: true,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                style: const TextStyle(
                                    color: Color(0xff000000), fontSize: 15),
                                validator: (value) {
                                  if (value == null)
                                    return "Please select your pet.";
                                  return null;
                                },
                                focusColor: Colors.white,
                                value: selectedPet,
                                iconEnabledColor: Colors.black,
                                items: state.petList.map((pet) {
                                  return DropdownMenuItem<Pet>(
                                    value: pet,
                                    child: Text(pet.petName),
                                  );
                                }).toList(),
                                onChanged: (Pet? value) {
                                  setState(() {
                                    selectedPet = value!;
                                    petID = value.petID;
                                  });
                                },
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                decoration: const InputDecoration(
                                  fillColor: Color(0xFFE5E5E5),
                                  labelText: 'Pet',
                                  filled: true,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color(0xFFF6F6F6), width: 0.0),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25.0)),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              maxLines: 5,
                              controller: _reason,
                              decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        new BorderRadius.circular(15.0),
                                    borderSide: BorderSide(
                                        color: Color(0xFFE5E5E5), width: 2.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        new BorderRadius.circular(15.0),
                                    borderSide: BorderSide(
                                        color: Color(0xFFE5E5E5), width: 2.0),
                                  ),
                                  hintText:
                                      'Why do you want to surrender your pet?',
                                  fillColor: Color(0xFFE5E5E5),
                                  filled: true),
                              keyboardType: TextInputType.multiline,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value!.trim().isEmpty) {
                                  return ("Reason cannot be Empty");
                                }
                                if (value.trim().length < 10)
                                  return ("Reason must be at least 10 characters");
                                if (value.trim().length > 100)
                                  return ("Reason must be at most 100 characters");
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              maxLines: 5,
                              controller: _description,
                              decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        new BorderRadius.circular(15.0),
                                    borderSide: BorderSide(
                                        color: Color(0xFFE5E5E5), width: 2.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        new BorderRadius.circular(15.0),
                                    borderSide: BorderSide(
                                        color: Color(0xFFE5E5E5), width: 2.0),
                                  ),
                                  hintText: 'Pet Description',
                                  fillColor: Color(0xFFE5E5E5),
                                  filled: true),
                              keyboardType: TextInputType.multiline,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value!.trim().isEmpty) {
                                  return ("Description cannot be Empty");
                                }
                                if (value.trim().length < 10)
                                  return ("Description must be at least 10 characters");
                                if (value.trim().length > 100)
                                  return ("Description must be at most 100 characters");
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            ButtonBar(
                              alignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomButton(
                                    text: 'Send Request',
                                    textSize: 20,
                                    textColor: Colors.white,
                                    color: PrimaryButton,
                                    size: Size(size.width * 0.45, 55),
                                    pressed: () async {
                                      if (_formKey.currentState!.validate())
                                        BlocProvider.of<HandoverRequestBloc>(
                                                context)
                                            .add(SubmitHandoverRequest(
                                                widget.orgID,
                                                petID!,
                                                _reason.text,
                                                _description.text));
                                      List<dynamic> tokens =
                                          await _fcmNotificationService
                                              .getUserToken(widget.orgID);
                                      try {
                                        tokens.forEach((element) {
                                          print("array: " + element.toString());
                                          _fcmNotificationService
                                              .sendNotificationToUser(
                                            fcmToken: element.toString(),
                                            title: "New handover request",
                                            body:
                                                "Pet: " + selectedPet!.petName,
                                          );
                                        });
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text('Notification sent.'),
                                          ),
                                        );
                                      } catch (e) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content:
                                                Text('Error, ${e.toString()}.'),
                                          ),
                                        );
                                      }
                                    }),
                                CustomButton(
                                    text: 'Cancel',
                                    textSize: 20,
                                    textColor: PrimaryButton,
                                    borderColor: PrimaryButton,
                                    color: PrimaryLightButton,
                                    size: Size(size.width * 0.3, 55),
                                    pressed: () {
                                      Navigator.pop(context);
                                    })
                              ],
                            )
                          ],
                        ),
                      ));
                else
                  return Container();
              },
            ),
          ),
        ));
  }
}
