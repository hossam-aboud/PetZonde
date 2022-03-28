import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:petzone/repositories/user_repository.dart';
import 'package:time_range/time_range.dart';



class SetSchedule extends StatefulWidget {
  final getuser;
  const SetSchedule({Key? key, this.getuser}) : super(key: key);

  @override
  _SetScheduleState createState() => _SetScheduleState();
}
 bool Sunday = false;
bool Monday = false;
bool Tuesday = false;
bool Wednesday = false;
bool Thursday = false;
bool Friday = false;
bool Saturday = false;
class _SetScheduleState extends State<SetSchedule> {

  static const dark = Color(0xFF333A47);

  final _defaultTimeRange = TimeRangeResult(
    TimeOfDay(hour: 8, minute: 00),
    TimeOfDay(hour: 8, minute: 30),
  );
  TimeRangeResult?  _timeRangeSun ;
TimeRangeResult? _timeRangeMon;
TimeRangeResult? _timeRangeTue;
TimeRangeResult? _timeRangeWen;
TimeRangeResult? _timeRangeThu;
TimeRangeResult? _timeRangeFri;
TimeRangeResult? _timeRangeSat;
  @override
  void initState() {
    super.initState();
    _timeRangeSun = _defaultTimeRange;
    _timeRangeMon = _defaultTimeRange;
    _timeRangeTue = _defaultTimeRange;
    _timeRangeWen = _defaultTimeRange;
    _timeRangeThu = _defaultTimeRange;
    _timeRangeFri = _defaultTimeRange;
    _timeRangeSat = _defaultTimeRange;  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Weekly Schedule', style: TextStyle(
              fontSize: 25,
              color: Colors.grey),),
          iconTheme: const IconThemeData(color: Colors.black26),

          backgroundColor: Colors.white24,
          bottomOpacity: 0.0,
          elevation: 0.0,
          automaticallyImplyLeading: true,
          toolbarHeight: 60,
        ),

      body:
      SingleChildScrollView(
child: Padding(
  padding: const EdgeInsets.only(top:20, bottom: 20 , left: 10, right: 20),
  child:
  Center(
    child:
  Column(
    children: <Widget>[Container(
  child:  (Sunday||Monday||Thursday||Tuesday||Wednesday||Friday||Saturday)? null :
    Text(  'Click on the Checkbox Day that you Want to have Your Weekly Meetings on and Set the Times : ',
        style: TextStyle(
          fontSize: 14,
          color: Colors.red,
          fontWeight: FontWeight.w300,
        ),
      )),
      SizedBox(height: 20),

      Row(
  children: <Widget>[


  new Transform.scale(
  scale: 1.3,
      child: new Checkbox(

          value: Sunday,
          splashRadius: 13,

          activeColor: const Color(0xFF8CD3CB),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          onChanged: (bool? value) {

          setState(() {
            Sunday = value!;
          });
          },

      )),
        const Text(
      'Sunday',
      style: TextStyle(fontSize: 20.0),
    ),

  ]),
      SizedBox(height: 10),
      avSun(Sunday ),
      SizedBox(height: 10),


      Row(
          children: <Widget>[


            new Transform.scale(
                scale: 1.3,
                child: new Checkbox(

                  value: Monday,
                  splashRadius: 13,

                  activeColor: const Color(0xFF8CD3CB),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  onChanged: (bool? value) {

                    setState(() {
                      Monday = value!;
                    });
                  },

                )),
            const Text(
              'Monday',
              style: TextStyle(fontSize: 20.0),
            ),

          ]),
      SizedBox(height: 10),
      avMon(Monday),
      SizedBox(height: 10),

      Row(
          children: <Widget>[


            new Transform.scale(
                scale: 1.3,
                child: new Checkbox(

                  value: Tuesday,
                  splashRadius: 13,

                  activeColor: const Color(0xFF8CD3CB),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  onChanged: (bool? value) {

                    setState(() {
                      Tuesday = value!;
                    });
                  },

                )),
            const Text(
              'Tuesday',
              style: TextStyle(fontSize: 20.0),
            ),

          ]),
      SizedBox(height: 10),
      avTue(Tuesday),
      SizedBox(height: 10),

      Row(
          children: <Widget>[


            new Transform.scale(
                scale: 1.3,
                child: new Checkbox(

                  value: Wednesday,
                  splashRadius: 13,

                  activeColor: const Color(0xFF8CD3CB),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  onChanged: (bool? value) {

                    setState(() {
                      Wednesday = value!;
                    });
                  },

                )),
            const Text(
              'Wednesday',
              style: TextStyle(fontSize: 20.0),
            ),

          ]),
      SizedBox(height: 10),
      avWen(Wednesday),
      SizedBox(height: 10),


// bool Friday = false;
// bool Saturday = false;
      Row(
          children: <Widget>[


            new Transform.scale(
                scale: 1.3,
                child: new Checkbox(

                  value: Thursday,
                  splashRadius: 13,

                  activeColor: const Color(0xFF8CD3CB),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  onChanged: (bool? value) {

                    setState(() {
                      Thursday = value!;
                    });
                  },

                )),
            const Text(
              'Thursday',
              style: TextStyle(fontSize: 20.0),
            ),

          ]),
      SizedBox(height: 10),
      avThu(Thursday),
      SizedBox(height: 10),

      Row(
          children: <Widget>[


            new Transform.scale(
                scale: 1.3,
                child: new Checkbox(

                  value: Friday,
                  splashRadius: 13,

                  activeColor: const Color(0xFF8CD3CB),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  onChanged: (bool? value) {

                    setState(() {
                      Friday = value!;
                    });
                  },

                )),
            const Text(
              'Friday',
              style: TextStyle(fontSize: 20.0),
            ),

          ]),
      SizedBox(height: 10),
      avFri(Friday),
      SizedBox(height: 10),


      Row(
          children: <Widget>[


            new Transform.scale(
                scale: 1.3,
                child: new Checkbox(

                  value: Saturday,
                  splashRadius: 13,

                  activeColor: const Color(0xFF8CD3CB),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  onChanged: (bool? value) {

                    setState(() {
                      Saturday = value!;
                    });
                  },

                )),
            const Text(
              'Saturday',
              style: TextStyle(fontSize: 20.0),
            ),

          ]),
      SizedBox(height: 10),
      avSat(Saturday),

      SizedBox(height: 10),

      Center(

        child: ElevatedButton(
          onPressed:(){
            // if(((Sunday&&_timeRangeSun!=null)||
            //     (Monday&&_timeRangeMon!=null)||
            //     (Thursday&&_timeRangeThu!=null)||
            //         (Tuesday&&_timeRangeTue!=null)||
            //             (Wednesday&&_timeRangeWen!=null)||
            //                 (Friday&&_timeRangeFri!=null)||
            //                     (Saturday&&_timeRangeSat!=null)
            //
            // )){
             addDay();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content:
                Text("Your Weekly Schedule has been Saved successfully "),
                backgroundColor: Colors.green,
              ),
            );
            // }

          },
          child: Padding(
              padding: EdgeInsets.only(left: 35.0 , right:35.0 , top: 10 , bottom: 10),
              child: Text('Save', style: TextStyle( fontSize: 20 ))),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF8CD3CB)),
          ) ,
        ),


      ),
      SizedBox(height: 60),


    ],
  ),
),
      )
    ));
  }

Widget tRangeSun() {
    return Column(
      children: <Widget>[
            TimeRange(
              fromTitle: const Text(
                'FROM',
                style: TextStyle(
                  fontSize: 12,
                  color: dark,
                  fontWeight: FontWeight.w600,
                ),
              ),
              toTitle: const Text(
                'TO',
                style: TextStyle(
                  fontSize: 12,
                  color: dark,
                  fontWeight: FontWeight.w600,
                ),
              ),
              titlePadding: 50,
              textStyle: const TextStyle(
                fontWeight: FontWeight.normal,
                color: dark,
              ),
              activeTextStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              borderColor: dark,
              activeBorderColor: dark,
              backgroundColor: Colors.transparent,
              activeBackgroundColor: dark,
              firstTime: const TimeOfDay(hour: 08, minute: 00),
              lastTime: const TimeOfDay(hour: 22, minute: 00),
              initialRange: _timeRangeSun,
              timeStep: 10,
              timeBlock: 30,
              onRangeCompleted: (range) => setState(() => _timeRangeSun = range),
    ),
        SizedBox(height: 10),

            if (_timeRangeSun != null)
              Padding(
                padding: const EdgeInsets.only(top: 12.0, right: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Selected Range: ${_timeRangeSun!.start.format(context)} - ${_timeRangeSun!.end.format(context)}',
                      style: const TextStyle(fontSize: 12, color: Color(0xff026c45)),
                    ),
                  ],

                ),
              ),

        SizedBox(height: 10),

        Divider(
        color: Colors.black
        ),

      ]);
  }
  void addDay(){
    if(Sunday){
      addSchedule(getuser().toString(),"Sunday",7,_timeRangeSun!.start.format(context),_timeRangeSun!.end.format(context));
    }else{
      EmptySchedule(getuser().toString(),"Sunday");
    }
    if(Monday){
      addSchedule(getuser().toString(),"Monday",1,_timeRangeMon!.start.format(context),_timeRangeMon!.end.format(context));
    }else{
      EmptySchedule(getuser().toString(),"Monday");
    }
    if(Tuesday){
      addSchedule(getuser().toString(),"Tuesday",2,_timeRangeTue!.start.format(context),_timeRangeTue!.end.format(context));
    }else{
      EmptySchedule(getuser().toString(),"Tuesday");
    }
    if(Wednesday){
      addSchedule(getuser().toString(),"Wednesday",3,_timeRangeWen!.start.format(context),_timeRangeWen!.end.format(context));
    }else{
      EmptySchedule(getuser().toString(),"Wednesday");
    }
    if(Thursday){
      addSchedule(getuser().toString(),"Thursday",4,_timeRangeThu!.start.format(context),_timeRangeThu!.end.format(context));
    }else{
      EmptySchedule(getuser().toString(),"Thursday");
    }
    if(Friday){
      addSchedule(getuser().toString(),"Friday",5,_timeRangeFri!.start.format(context),_timeRangeFri!.end.format(context));
    }else{
      EmptySchedule(getuser().toString(),"Friday");
    }
    if(Saturday){
      addSchedule(getuser().toString(),"Saturday",6,_timeRangeSat!.start.format(context),_timeRangeSat!.end.format(context));
    }else{
      EmptySchedule(getuser().toString(),"Saturday");
    }
  }

  Widget avSun(bool day ){
if(day) {
  return tRangeSun();
} else {
  return  Text("",style: TextStyle(fontSize: 0));
}

}
  Widget tRangeMon() {
    return Column(
        children: <Widget>[
          TimeRange(
            fromTitle: const Text(
              'FROM',
              style: TextStyle(
                fontSize: 12,
                color: dark,
                fontWeight: FontWeight.w600,
              ),
            ),
            toTitle: const Text(
              'TO',
              style: TextStyle(
                fontSize: 12,
                color: dark,
                fontWeight: FontWeight.w600,
              ),
            ),
            titlePadding: 50,
            textStyle: const TextStyle(
              fontWeight: FontWeight.normal,
              color: dark,
            ),
            activeTextStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            borderColor: dark,
            activeBorderColor: dark,
            backgroundColor: Colors.transparent,
            activeBackgroundColor: dark,
            firstTime: const TimeOfDay(hour: 8, minute: 00),
            lastTime: const TimeOfDay(hour: 22, minute: 00),
            initialRange: _timeRangeMon,
            timeStep: 10,
            timeBlock: 30,
            onRangeCompleted: (range) => setState(() => _timeRangeMon = range),
          ),
          SizedBox(height: 10),

          if (_timeRangeMon != null)
            Padding(
              padding: const EdgeInsets.only(top: 12.0, right: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Selected Range: ${_timeRangeMon!.start.format(context)} - ${_timeRangeMon!.end.format(context)}',
                    style: const TextStyle(fontSize: 12, color: Color(0xff026c45)),
                  ),

                ],
              ),
            ),
          SizedBox(height: 10),

          Divider(
              color: Colors.black
          ),
        ]);
  }
  Widget avMon(bool day ){
    if(day) {
      return tRangeMon();
    } else {
      return  Text("",style: TextStyle(fontSize: 0));
    }

  }
  Widget tRangeTue() {
    return Column(
        children: <Widget>[
          TimeRange(
            fromTitle: const Text(
              'FROM',
              style: TextStyle(
                fontSize: 12,
                color: dark,
                fontWeight: FontWeight.w600,
              ),
            ),
            toTitle: const Text(
              'TO',
              style: TextStyle(
                fontSize: 12,
                color: dark,
                fontWeight: FontWeight.w600,
              ),
            ),
            titlePadding: 50,
            textStyle: const TextStyle(
              fontWeight: FontWeight.normal,
              color: dark,
            ),
            activeTextStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            borderColor: dark,
            activeBorderColor: dark,
            backgroundColor: Colors.transparent,
            activeBackgroundColor: dark,
            firstTime: const TimeOfDay(hour: 8, minute: 00),
            lastTime: const TimeOfDay(hour: 22, minute: 00),
            initialRange: _timeRangeTue,
            timeStep: 10,
            timeBlock: 30,
            onRangeCompleted: (range) => setState(() => _timeRangeTue = range),
          ),
          SizedBox(height: 10),

          if (_timeRangeTue != null)
            Padding(
              padding: const EdgeInsets.only(top: 12.0, right: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Selected Range: ${_timeRangeTue!.start.format(context)} - ${_timeRangeTue!.end.format(context)}',
                    style: const TextStyle(fontSize: 12, color: Color(0xff026c45)),
                  ),

                ],
              ),
            ),
          SizedBox(height: 10),

          Divider(
              color: Colors.black
          ),
        ]);
  }
  Widget avTue(bool day ){
    if(day) {
      return tRangeTue();
    } else {
      return  Text("",style: TextStyle(fontSize: 0));
    }

  }
  Widget tRangeWen() {
    return Column(
        children: <Widget>[

          TimeRange(
            fromTitle: const Text(
              'FROM',
              style: TextStyle(
                fontSize: 12,
                color: dark,
                fontWeight: FontWeight.w600,
              ),
            ),
            toTitle: const Text(
              'TO',
              style: TextStyle(
                fontSize: 12,
                color: dark,
                fontWeight: FontWeight.w600,
              ),
            ),
            titlePadding: 50,
            textStyle: const TextStyle(
              fontWeight: FontWeight.normal,
              color: dark,
            ),
            activeTextStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            borderColor: dark,
            activeBorderColor: dark,
            backgroundColor: Colors.transparent,
            activeBackgroundColor: dark,
            firstTime: const TimeOfDay(hour: 8, minute: 00),
            lastTime: const TimeOfDay(hour: 22, minute: 00),
            initialRange: _timeRangeWen,
            timeStep: 10,
            timeBlock: 30,
            onRangeCompleted: (range) => setState(() => _timeRangeWen = range),
          ),
          SizedBox(height: 10),

          if (_timeRangeWen != null)
            Padding(
              padding: const EdgeInsets.only(top: 12.0, right: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Selected Range: ${_timeRangeWen!.start.format(context)} - ${_timeRangeWen!.end.format(context)}',
                    style: const TextStyle(fontSize: 12, color: Color(0xff026c45)),
                  ),

                ],
              ),
            ),
          SizedBox(height: 10),
          Divider(
              color: Colors.black
          ),
        ]);
  }
  Widget avWen(bool day ){
    if(day) {
      return tRangeWen();
    } else {
      return  Text("",style: TextStyle(fontSize: 0));
    }

  }
  Widget tRangeThu() {
    return Column(
        children: <Widget>[
          TimeRange(
            fromTitle: const Text(
              'FROM',
              style: TextStyle(
                fontSize: 12,
                color: dark,
                fontWeight: FontWeight.w600,
              ),
            ),
            toTitle: const Text(
              'TO',
              style: TextStyle(
                fontSize: 12,
                color: dark,
                fontWeight: FontWeight.w600,
              ),
            ),
            titlePadding: 50,
            textStyle: const TextStyle(
              fontWeight: FontWeight.normal,
              color: dark,
            ),
            activeTextStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            borderColor: dark,
            activeBorderColor: dark,
            backgroundColor: Colors.transparent,
            activeBackgroundColor: dark,
            firstTime: const TimeOfDay(hour: 8, minute: 00),
            lastTime: const TimeOfDay(hour: 22, minute: 00),
            initialRange: _timeRangeThu,
            timeStep: 10,
            timeBlock: 30,
            onRangeCompleted: (range) => setState(() => _timeRangeThu = range),
          ),
          SizedBox(height: 10),

          if (_timeRangeThu != null)
            Padding(
              padding: const EdgeInsets.only(top: 12.0, right: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Selected Range: ${_timeRangeThu!.start.format(context)} - ${_timeRangeThu!.end.format(context)}',
                    style: const TextStyle(fontSize: 12, color: Color(0xff026c45)),
                  ),

                ],
              ),
            ),
          SizedBox(height: 10),
          Divider(
              color: Colors.black
          ),
        ]);
  }
  Widget avThu(bool day ){
    if(day) {
      return tRangeThu();
    } else {
      return  Text("",style: TextStyle(fontSize: 0));
    }

  }
  Widget tRangeFri() {
    return Column(
        children: <Widget>[
          TimeRange(
            fromTitle: const Text(
              'FROM',
              style: TextStyle(
                fontSize: 12,
                color: dark,
                fontWeight: FontWeight.w600,
              ),
            ),
            toTitle: const Text(
              'TO',
              style: TextStyle(
                fontSize: 12,
                color: dark,
                fontWeight: FontWeight.w600,
              ),
            ),
            titlePadding: 50,
            textStyle: const TextStyle(
              fontWeight: FontWeight.normal,
              color: dark,
            ),
            activeTextStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            borderColor: dark,
            activeBorderColor: dark,
            backgroundColor: Colors.transparent,
            activeBackgroundColor: dark,
            firstTime: const TimeOfDay(hour: 8, minute: 00),
            lastTime: const TimeOfDay(hour: 22, minute: 00),
            initialRange: _timeRangeFri,
            timeStep: 10,
            timeBlock: 30,
            onRangeCompleted: (range) => setState(() => _timeRangeFri = range),
          ),
          SizedBox(height: 10),

          if (_timeRangeFri != null)
            Padding(
              padding: const EdgeInsets.only(top: 12.0, right: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Selected Range: ${_timeRangeFri!.start.format(context)} - ${_timeRangeFri!.end.format(context)}',
                    style: const TextStyle(fontSize: 12, color: Color(0xff026c45)),
                  ),

                ],
              ),
            ),
          SizedBox(height: 10),
          Divider(
              color: Colors.black
          ),
        ]);
  }
  Widget avFri(bool day ){
    if(day) {
      return tRangeFri();
    } else {
      return  Text("",style: TextStyle(fontSize: 0));
    }

  }
  Widget tRangeSat() {
    return Column(
        children: <Widget>[
          TimeRange(
            fromTitle: const Text(
              'FROM',
              style: TextStyle(
                fontSize: 12,
                color: dark,
                fontWeight: FontWeight.w600,
              ),
            ),
            toTitle: const Text(
              'TO',
              style: TextStyle(
                fontSize: 12,
                color: dark,
                fontWeight: FontWeight.w600,
              ),
            ),
            titlePadding: 50,
            textStyle: const TextStyle(
              fontWeight: FontWeight.normal,
              color: dark,
            ),
            activeTextStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            borderColor: dark,
            activeBorderColor: dark,
            backgroundColor: Colors.transparent,
            activeBackgroundColor: dark,
            firstTime: const TimeOfDay(hour: 8, minute: 00),
            lastTime: const TimeOfDay(hour: 22, minute: 00),
            initialRange: _timeRangeSat,
            timeStep: 10,
            timeBlock: 30,
            onRangeCompleted: (range) => setState(() => _timeRangeSat = range),
          ),
          SizedBox(height: 10),

          if (_timeRangeSat != null)
            Padding(
              padding: const EdgeInsets.only(top: 12.0, right: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Selected Range: ${_timeRangeSat!.start.format(context)} - ${_timeRangeSat!.end.format(context)}',
                    style: const TextStyle(fontSize: 12, color: Color(0xff026c45)),
                  ),

                ],
              ),
            ),
          SizedBox(height: 10),
          Divider(
              color: Colors.black
          ),
        ]);
  }
  Widget avSat(bool day ){
    if(day) {
      return tRangeSat();
    } else {
      return  Text("",style: TextStyle(fontSize: 0));
    }

  }

  addSchedule(String id,String day,int weekId, String start, String end) async{

    await  FirebaseFirestore
        .instance
        .collection('veterinarian')
        .doc('cKP2en2osew0HbvhUQUL')
        .collection('schedule')
        .doc(day)
        .set({
      'weekId': weekId,
      'start': start,
      'end':end,

    });

  }
  EmptySchedule(String id,String weekId) async{

    await  FirebaseFirestore
        .instance
        .collection('veterinarian')
        .doc('cKP2en2osew0HbvhUQUL')
        .collection('schedule')
        .doc(weekId)
        .delete();

  }

}
