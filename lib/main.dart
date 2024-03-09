
import 'dart:async';

import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'ExampleAlarmRingScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Alarm.init(showDebugLogs: true);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String dateText = "MMMM dd yyyy";
  String timeText = "hh:mm aa";
  TimePickerEntryMode selectedTimeMode = TimePickerEntryMode.values[0];
  DatePickerEntryMode selectDateMode = DatePickerEntryMode.calendarOnly;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  int selectedAudio = 0;
  static StreamSubscription<AlarmSettings>? subscription;

  navigateToRingScreen(alarmSettings){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ExampleAlarmRingScreen(alarmSettings: alarmSettings),
      ),
    );
  }

  setAlarm(int alarmId,DateTime getDateTime,String selectAudio) async{
    AlarmSettings alarmSettings = AlarmSettings(
      id: alarmId,
      dateTime: getDateTime,
      assetAudioPath: selectAudio,
      androidFullScreenIntent: true,
      loopAudio: false,
      vibrate: false,
      fadeDuration: 3.0,
      notificationTitle: 'Alarm Time : ${getDateTime}',
      notificationBody: 'Alarm Audio ${selectedAudio.toString().replaceAll("assets/ringtone/", "")}',
      enableNotificationOnKill: false,
    );
    await Alarm.set(alarmSettings: alarmSettings);

  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(context: context, initialDate: DateTime.now(),initialEntryMode: selectDateMode,firstDate: DateTime.now().subtract(Duration(days: 0)) ,initialDatePickerMode: DatePickerMode.day,lastDate: DateTime(2101));
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        print(DateFormat("MMMM dd yyyy").format(selectedDate));
        dateText = DateFormat("MMMM dd yyyy").format(selectedDate);
        print(DateFormat("yyyy-MM-dd").format(selectedDate));
        print(DateFormat("yyyy-MM-dd").format(DateTime.now()));
      });
    }
  }


  Future<void> _selectTime(BuildContext context) async {
    print(DateFormat("MMMM dd yyyy").format(DateTime.now()));
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      initialEntryMode: selectedTimeMode,
      useRootNavigator: false,
      onEntryModeChanged: (value){
        print(value);
        setState((){
          if(value==TimePickerEntryMode.input){
            Navigator.pop(context);
            _selectTime(context);
          }
        });
      },
    );

    if (picked != null) {
      setState(() {
        if(dateText == DateFormat("MMMM dd yyyy").format(DateTime.now())){
          selectedTime = picked;
          print(selectedTime.format(context));
          print(TimeOfDay.now().format(context));
          if(selectedTime.hour*60+selectedTime.minute>=TimeOfDay.now().hour*60 +TimeOfDay.now().minute){
            print(selectedTime.hour.toString()+":"+selectedTime.minute.toString());
            selectedTime = picked;
            print(selectedTime.format(context));
            timeText = selectedTime.format(context);
            String getHour = "";
            String getMinute = "";
            if(picked.hour<10){
              getHour = "0"+picked.hour.toString();
            }
            else{
              getHour = picked.hour.toString();
            }
            if(picked.minute<10){
              getMinute = "0"+picked.minute.toString();
            }
            else{
              getMinute = picked.minute.toString();
            }
          }
          else{
            print("not same");
            timeText = "hh:mm aa";
            String getHour = "";
            String getMinute = "";
            if(picked.hour<10){
              getHour = "0"+picked.hour.toString();
            }
            else{
              getHour = picked.hour.toString();
            }
            if(picked.minute<10){
              getMinute = "0"+picked.minute.toString();
            }
            else{
              getMinute = picked.minute.toString();
            }
          }
        }
        else{
          selectedTime = picked;
          print(selectedTime.format(context));
          timeText = selectedTime.format(context);
          String getHour = "";
          String getMinute = "";
          if(picked.hour<10){
            getHour = "0"+picked.hour.toString();
          }
          else{
            getHour = picked.hour.toString();
          }
          if(picked.minute<10){
            getMinute = "0"+picked.minute.toString();
          }
          else{
            getMinute = picked.minute.toString();
          }
        }
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    subscription ??= Alarm.ringStream.stream.listen(
          (alarmSettings) => navigateToRingScreen(alarmSettings),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 50,
            ),
            Container(
              width: 300,
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text("Schedule Time"),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Stack(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 15,
                                height: 15,
                                child: Icon(Icons.calendar_month),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text("$dateText"),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: (){
                              _selectDate(context);
                            },
                            child: Text("click"),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    child: Stack(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 15,
                                height: 15,
                                child: Icon(Icons.timer_sharp),
                              ),
                              SizedBox(
                                width:20,
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text("$timeText"),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: (){
                              _selectTime(context);
                            },
                            child: Text("click"),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Radio(
                          value: 0,
                          groupValue: selectedAudio,
                          onChanged: (int? value) {
                            setState(() {
                              selectedAudio = value!;
                            });
                          },



                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          child: Text("Alarm 1"),
                        ),
                      ],
                    ),

                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Radio(
                          value: 1,
                          groupValue: selectedAudio,
                          onChanged: (int? value) {
                            setState(() {
                              selectedAudio = value!;
                            });
                          },



                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          child: Text("Alarm 2"),
                        ),
                      ],
                    ),

                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Radio(
                          value: 2,
                          groupValue: selectedAudio,
                          onChanged: (int? value) {
                            setState(() {
                              selectedAudio = value!;
                            });
                          },



                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          child: Text("Alarm 3"),
                        ),
                      ],
                    ),

                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Radio(
                          value: 3,
                          groupValue: selectedAudio,
                          onChanged: (int? value) {
                            setState(() {
                              selectedAudio = value!;
                            });
                          },
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          child: Text("Alarm 4"),
                        ),
                      ],
                    ),

                  ),
                ],
              ),
            ),
            SizedBox(height: 30,),
            ElevatedButton(
              onPressed: (){
                if(dateText == "MMMM dd yyyy" || timeText == "hh:mm aa"){
                  const snackBar = SnackBar(
                    content: Text('Please select date & time'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
                else{
                  print("alarm");
                  print(selectedDate);
                  print(selectedTime);
                  DateTime alarmDate = DateTime(selectedDate.year,selectedDate.month,selectedDate.day,selectedTime.hour,selectedTime.minute);
                  print("alarm date : ${alarmDate}");
                  setAlarm(selectedAudio==0?1:selectedAudio==1?2:selectedAudio==2?3:4,alarmDate,selectedAudio==0?"assets/ringtone/audio1.mp3":selectedAudio==1?"assets/ringtone/audio2.mp3":selectedAudio==2?"assets/ringtone/audio3.mp3":"assets/ringtone/audio4.mp3");
                  const snackBar = SnackBar(
                    content: Text('Alarm added successfully'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blue)),
              child: Text("Set Alarm",style: TextStyle(color: Colors.white),),
            ),
          ],
        ),
      ),
    );
  }
}
