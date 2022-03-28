import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petzone/Screens/homepage/home_page.dart';
import '../../bloc/reminder/reminder_bloc.dart';
import '../../constants.dart';
import '../../model/Pet.dart';
import '../../widgets/custom_button.dart';
import 'package:intl/intl.dart';


class AddReminderScreen extends StatefulWidget {
  @override
  _AddReminderScreen createState() => _AddReminderScreen();
}

class _AddReminderScreen extends State<AddReminderScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _title = TextEditingController();
  final TextEditingController _description = TextEditingController();
  double sysWidth = 0.0;
  double sysHeight = 0.0;
  List<String> repeat = ['Never', 'Every Day', 'Every Week'];
  Pet? selectedPet;
  TimeOfDay? selectedTime;
  DateTime? selectedDate;
  String? selectedRepeat;
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
            "Add Reminder",
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
        body: BlocProvider(
  create: (context) => ReminderBloc()..add(LoadPets()),
  child: BlocConsumer<ReminderBloc, ReminderState>(
  listener: (context, state) {
    if (state is ReminderSuccess) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(
          backgroundColor: Colors.green,
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 20),
              Text('Reminder Added')
            ],
          )

      ));
    Navigator.push(
    context,
    MaterialPageRoute(
    builder: (context) => const homePage()));
    }
    if (state is ReminderFail) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
        SnackBar(
            backgroundColor: Colors.red,
            content: Text(state.error)));
    }
    if (state is ReminderSubmitting) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
      backgroundColor: Colors.orangeAccent,
        content: Row(
          children: [
            Icon(Icons.loop_rounded, color: Colors.white),
            SizedBox(width: 20),
            Text('Adding Reminder...')
          ],
        )

    ));
    }
    },
    builder: (context, state) {
    if(state is ReminderInitial || state is ReminderSubmitting)
      return Center(child: CircularProgressIndicator());

    if(state is ReminderPetLoad) {
      return SingleChildScrollView(
        child: Form(
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
                          color: Color(0xff000000),

                          fontSize: 15
                      ),
                      validator: (value) {
                        if (value == null) return "Please select your pet";
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
                      }) .toList(),
                      onChanged: (Pet? value) {
                        setState(() {
                          selectedPet = value!;
                          petID = value.petID;
                        });
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(
                          fillColor: Color(0xFFE5E5E5),
                          labelText: 'Pet',
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color:Color(0xFFF6F6F6), width: 0.0),
                            borderRadius:  BorderRadius.all(Radius.circular(25.0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color:Color(0xFFF6F6F6), width: 0.0),
                            borderRadius:  BorderRadius.all(Radius.circular(25.0)),
                          )
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    maxLines: 1,
                    controller: _title,
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(15.0),
                          borderSide: BorderSide(color: Color(0xFFE5E5E5), width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(15.0),
                          borderSide: BorderSide(color: Color(0xFFE5E5E5), width: 2.0),
                        ),
                        labelText: 'Title',
                        fillColor: Color(0xFFE5E5E5),
                        filled: true),
                    keyboardType: TextInputType.multiline,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        return ("Title cannot be Empty");
                      }
                      if(value.trim().length < 5)
                        return ("Title must be at least 5 characters");
                      if(value.trim().length > 20)
                        return ("Title must be at most 20 characters");
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    maxLines: 3,
                    controller: _description,
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(15.0),
                          borderSide: BorderSide(color: Color(0xFFE5E5E5), width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(15.0),
                          borderSide: BorderSide(color: Color(0xFFE5E5E5), width: 2.0),
                        ),
                        labelText: 'Description',
                        fillColor: Color(0xFFE5E5E5),
                        filled: true),
                    keyboardType: TextInputType.multiline,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        return ("Description cannot be Empty");
                      }
                      if(value.trim().length < 5)
                        return ("Description must be at least 5 characters");
                      if(value.trim().length > 50)
                        return ("Description must be at most 50 characters");
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                      onTap: () => _selectDate(context),
                      child:  DropdownButtonHideUnderline(
                        child: DropdownButtonFormField<String>(
                          isExpanded: true,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          style: const TextStyle(
                              color: Color(0xff000000),

                              fontSize: 15
                          ),
                          validator: (value) {
                            if (selectedDate == null) return "Please select date";
                            return null;
                          },
                          focusColor: Colors.white,
                          value: selectedDate.toString(),
                          items: [],
                          onChanged: null,
                          iconEnabledColor: Colors.black,
                          iconDisabledColor: Colors.black,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                              fillColor: Color(0xFFE5E5E5),
                              labelText: 'Date',
                              floatingLabelBehavior: selectedDate == null ? FloatingLabelBehavior.never : FloatingLabelBehavior.always,
                              hintText: selectedDate == null ? 'Date' : DateFormat('MMMM d, y').format(selectedDate!),
                              hintStyle: const TextStyle(
                                  color: Color(0xff000000), fontSize: 15),
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color:Color(0xFFF6F6F6), width: 0.0),
                                borderRadius:  BorderRadius.all(Radius.circular(25.0)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color:Color(0xFFF6F6F6), width: 0.0),
                                borderRadius:  BorderRadius.all(Radius.circular(25.0)),
                              )
                          ),
                        ),
                      )),
                  const SizedBox(height: 20),
                  GestureDetector(
                      onTap: () => _selectTime(context),
                      child:  DropdownButtonHideUnderline(
                        child: DropdownButtonFormField<String>(
                          isExpanded: true,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          style: const TextStyle(
                              color: Color(0xff000000),

                              fontSize: 15
                          ),
                          validator: (value) {
                            DateTime today = DateTime.now();
                            if (selectedTime == null) return "Please select time";
                            if(selectedDate!.isBefore(today) || selectedDate!.isAtSameMomentAs(today))
                              return "Selected time has already passed.";
                            return null;
                          },
                          focusColor: Colors.white,
                          value: selectedTime.toString(),
                          items: [],
                          onChanged: (value){},
                          iconEnabledColor: Colors.black,
                          iconDisabledColor: Colors.black,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration:  InputDecoration(
                              fillColor: Color(0xFFE5E5E5),
                              labelText: 'Time',
                              floatingLabelBehavior: selectedTime == null ? FloatingLabelBehavior.never : FloatingLabelBehavior.always,
                              hintText: selectedTime == null ? 'Time' : MaterialLocalizations.of(context).formatTimeOfDay(selectedTime!),
                              hintStyle: const TextStyle(
                                  color: Color(0xff000000), fontSize: 15),
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color:Color(0xFFF6F6F6), width: 0.0),
                                borderRadius:  BorderRadius.all(Radius.circular(25.0)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color:Color(0xFFF6F6F6), width: 0.0),
                                borderRadius:  BorderRadius.all(Radius.circular(25.0)),
                              )
                          ),
                        ),
                      )),
                  const SizedBox(height: 20),
                  DropdownButtonHideUnderline(
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      style: const TextStyle(
                          color: Color(0xff000000),

                          fontSize: 15
                      ),
                      validator: (value) {
                        if (value == null) return "Please select repetition";
                        return null;
                      },
                      focusColor: Colors.white,
                      value: selectedRepeat,
                      items: repeat.map((option) {
                        return DropdownMenuItem<String>(
                          value: option,
                          child: Text(option),
                        );
                      }).toList(),
                      onChanged: (value){
                        setState(() {
                          selectedRepeat = value;
                        });
                      },
                      iconEnabledColor: Colors.black,
                      iconDisabledColor: Colors.black,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(
                          fillColor: Color(0xFFE5E5E5),
                          labelText: 'Repeat',
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color:Color(0xFFF6F6F6), width: 0.0),
                            borderRadius:  BorderRadius.all(Radius.circular(25.0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color:Color(0xFFF6F6F6), width: 0.0),
                            borderRadius:  BorderRadius.all(Radius.circular(25.0)),
                          )
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  ButtonBar(
                    alignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomButton(
                          text: 'Add +',
                          textSize: 20,
                          textColor: Colors.white,
                          color: PrimaryButton,
                          size: Size(size.width*0.25,55),
                          pressed: () {
                            if(selectedDate != null && selectedTime != null)
                              setState(() {
                                selectedDate = DateTime(selectedDate!.year, selectedDate!.month,  selectedDate!.day,selectedTime!.hour,  selectedTime!.minute);
                              });

                            if(_formKey.currentState!.validate()){
                              BlocProvider.of<ReminderBloc>(context).add(AddReminder(
                                  selectedPet!.petID,
                                  _title.text,
                                  _description.text,
                                  selectedDate!,
                                  selectedRepeat!,
                              ));
                            }
                          }

                      ),
                      CustomButton(
                          text: 'Cancel',
                          textSize: 20,
                          textColor: PrimaryButton,
                          borderColor: PrimaryButton,
                          color: PrimaryLightButton,
                          size: Size(size.width*0.3,55),
                          pressed: () {
                            Navigator.pop(context);

                          }

                      )
                    ],


                  )


                ],
              ),
            ))

    );
    }

    return Container();

  },
),
));
  }


  _selectTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if(timeOfDay != null && timeOfDay != selectedTime)
    {
      setState(() {
        selectedTime = timeOfDay;
      });
    }
  }

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate ?? DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));


    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }




}
