import 'package:card_swiper/card_swiper.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:trilix/data/firebase/save_order_data.dart';
import 'package:trilix/data/hotel_data.dart';
import 'package:trilix/data/plane_data.dart';
import 'package:trilix/data/train_data.dart';
import 'package:trilix/pages/bookings/hotel_widget.dart';
import 'package:trilix/pages/bookings/plane_return_widget.dart';
import 'package:trilix/pages/bookings/plane_widget.dart';
import 'package:trilix/pages/bookings/train_class_widget.dart';
import 'package:trilix/pages/bookings/train_return_widget.dart';
import 'package:trilix/pages/bookings/train_widget.dart';
import 'package:trilix/pages/home/home_sceen.dart';
import 'package:trilix/payment/payment.dart';
import 'package:trilix/utils/colors.dart';
import 'package:trilix/utils/dimensions.dart';
import 'package:trilix/utils/error_show.dart';
import 'package:intl/intl.dart';
import 'package:trilix/utils/widgets/big_text.dart';
import 'package:trilix/utils/widgets/small_text.dart';

class BookingInfo extends StatefulWidget {
  String placeName;
  String location;
  String imageURL;
  BookingInfo(
      {key,
      required this.placeName,
      required this.location,
      required this.imageURL});

  @override
  State<BookingInfo> createState() => _BookingInfoState();
}

final _razorpay = Razorpay();

Map<String, int> placeMap = {
  'Delhi': 0,
  'Rajasthan': 1,
  'Mumbai': 2,
  'Chennai': 3,
  'Guwahati': 4,
  'Patna': 5,
};

enum BookingInfoHandler {
  SHOW_DROPDOWN_FORM_PAGE,
  SHOW_USER_DETAILS_FORM_PAGE,
  SHOW_DATEPICK_FORM_PAGE,
  SHOW_DEPURTURE_TRANSPORT_TRAIN_FORM_PAGE,
  SHOW_RETURN_TRANSPORT_TRAIN_FORM_PAGE,
  SHOW_DEPURTURE_TRANSPORT_PLANE_FORM_PAGE,
  SHOW_RETURN_TRANSPORT_PLANE_FORM_PAGE,
  SHOW_HOTEL_FORM_PAGE,
  SHOW_TOTAL_COST_FORM_PAGE,
}

enum TransportInfoHandler {
  SHOW_PLANE_FORM_PAGE,
  SHOW_TRAIN_FORM_PAGE,
}

String startdate = DateTime.now().add(Duration(days: 2)).toString();
String enddate = DateTime.now().add(Duration(days: 4)).toString();

List<String> _nameControllers = [];
List<String> _ageControllers = [];
List<String> _genderControllers = [];

String? peoplecountController;
String? transportPreferenseController;
bool isKeyboard = false;
final List<String> peopleCount = [
  '1',
  '2',
  '3',
  '4',
  '5',
  '6',
  '7',
  '8',
  '9',
  '10',
];

final List<String> transport = [
  'I want to both travel and return by plane',
  'I want to travel by train and return by plane',
  'I want to travel by plane and return by train',
  'I want to both travel and return by train',
];
bool isLoading = false;

bool trainDepurture = false;
bool trainReturn = false;
bool planeDepurture = false;
bool planeReturn = false;
bool isPay = false;

String? depurtureTrainController;
String? depurtureTrainClassController;
String? returnTrainController;
String? returnTrainClassController;
String? depurturePlaneController;
String? returnPlaneController;
Map? hotelMap;

final List<String> genderItems = [
  'Male',
  'Female',
];

var currentState = BookingInfoHandler.SHOW_DROPDOWN_FORM_PAGE;
var depurturetotal = 0;
var returntotal = 0;
var hoteltotal = 0;
void changeDepurtureTrainStatus(String trainName, String className) {
  depurtureTrainController = trainName;
  depurtureTrainClassController = className;
}

void changeHotelStatus(Map hotel_Map) {
  hotelMap = hotel_Map;
}

void changeReturnTrainStatus(String trainName, String className) {
  returnTrainController = trainName;
  returnTrainClassController = className;
}

void changeDepurturePlaneStatus(String planeName) {
  depurturePlaneController = planeName;
}

void changeReturnPlaneStatus(String planeName) {
  returnPlaneController = planeName;
}

class _BookingInfoState extends State<BookingInfo> {
  Future<void> _onSelectionChanged(
      DateRangePickerSelectionChangedArgs args) async {
    setState(() {
      startdate = args.value.startDate.toString();

      enddate =
          args.value.endDate.toString(); //?? args.value.startDate.toString();
    });
  }

  getDropdownWidget(context) {
    return Container(
      margin: EdgeInsets.only(
          left: Dimentions.height20, right: Dimentions.height20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.center,
            child: Column(children: [
              Text(
                "How many people are traveling?",
                style: TextStyle(
                  fontSize: Dimentions.height20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: Dimentions.height45,
              ),
              Container(
                height: Dimentions.height50,
                width: Dimentions.height350,
                child: DropdownButtonFormField2(
                  decoration: InputDecoration(
                    //Add isDense true and zero Padding.
                    //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  isExpanded: true,
                  hint: Text(
                    peoplecountController == null
                        ? 'Select Number of People Traveling'
                        : peoplecountController.toString(),
                    style: TextStyle(fontSize: 14),
                  ),
                  items: peopleCount
                      .map((item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ))
                      .toList(),
                  validator: (value) {
                    if (value == null) {
                      return 'Select Number of People Traveling';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    peoplecountController = value.toString();
                  },
                  onSaved: (value) {
                    peoplecountController = value.toString();
                  },
                  buttonStyleData: const ButtonStyleData(
                    height: 60,
                    padding: EdgeInsets.only(left: 20, right: 10),
                  ),
                  iconStyleData: const IconStyleData(
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black,
                    ),
                    iconSize: 30,
                  ),
                  dropdownStyleData: DropdownStyleData(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: Dimentions.height50,
              ),
              Text(
                "What is your transport preference?",
                style: TextStyle(
                  fontSize: Dimentions.height20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: Dimentions.height30,
              ),
              Container(
                height: Dimentions.height50,
                width: Dimentions.height350,
                child: DropdownButtonFormField2(
                  decoration: InputDecoration(
                    //Add isDense true and zero Padding.
                    //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: AppColors.bottomBarActiveColor),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  isExpanded: true,
                  hint: Text(
                    transportPreferenseController == null
                        ? 'Enter your preference'
                        : transportPreferenseController.toString(),
                    style: TextStyle(fontSize: 14),
                  ),
                  items: transport
                      .map((item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ))
                      .toList(),
                  validator: (value) {
                    if (value == null) {
                      return 'Select Your Transport Preferense';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    transportPreferenseController = value.toString();
                    if (transportPreferenseController ==
                        'I want to both travel and return by plane') {
                      setState(() {
                        planeDepurture = true;
                        planeReturn = true;
                        trainDepurture = false;
                        trainReturn = false;
                      });
                    } else if (transportPreferenseController ==
                        'I want to travel by train and return by plane') {
                      setState(() {
                        planeDepurture = false;
                        planeReturn = true;
                        trainDepurture = true;
                        trainReturn = false;
                      });
                    } else if (transportPreferenseController ==
                        'I want to travel by plane and return by train') {
                      setState(() {
                        planeDepurture = true;
                        planeReturn = false;
                        trainDepurture = false;
                        trainReturn = true;
                      });
                    } else if (transportPreferenseController ==
                        'I want to both travel and return by train') {
                      setState(() {
                        planeDepurture = false;
                        planeReturn = false;
                        trainDepurture = true;
                        trainReturn = true;
                      });
                    }
                  },
                  onSaved: (value) {
                    transportPreferenseController = value.toString();
                    if (transportPreferenseController ==
                        'I want to both travel and return by plane') {
                      setState(() {
                        planeDepurture = true;
                        planeReturn = true;
                        trainDepurture = false;
                        trainReturn = false;
                      });
                    } else if (transportPreferenseController ==
                        'I want to travel by train and return by plane') {
                      setState(() {
                        planeDepurture = false;
                        planeReturn = true;
                        trainDepurture = true;
                        trainReturn = false;
                      });
                    } else if (transportPreferenseController ==
                        'I want to travel by plane and return by train') {
                      setState(() {
                        planeDepurture = true;
                        planeReturn = false;
                        trainDepurture = false;
                        trainReturn = true;
                      });
                    } else if (transportPreferenseController ==
                        'I want to both travel and return by train') {
                      setState(() {
                        planeDepurture = false;
                        planeReturn = false;
                        trainDepurture = true;
                        trainReturn = true;
                      });
                    }
                  },
                  buttonStyleData: const ButtonStyleData(
                    height: 60,
                    padding: EdgeInsets.only(left: 20, right: 10),
                  ),
                  iconStyleData: const IconStyleData(
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black,
                    ),
                    iconSize: 30,
                  ),
                  dropdownStyleData: DropdownStyleData(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  List<TextEditingController> nameControllers = [];
  List<TextEditingController> ageControllers = [];
  List<String> genderControllers = [];
  getDetailsInfoWidget(context) {
    bool isgender = false;
    return Column(
      children: [
        Align(
          alignment: Alignment.center,
          child: Column(children: [
            Text(
              "Enter All Passenger Details",
              style: TextStyle(
                fontSize: Dimentions.height20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: Dimentions.height30),
              height: Dimentions.height300 - Dimentions.height30,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      blurRadius: 25.0, color: Colors.grey.withOpacity(0.3)),
                ],
              ),
              child: Swiper(
                itemCount: int.parse(peoplecountController.toString()),
                autoplay: false,
                loop: false,
                viewportFraction: 0.8,
                scale: 0.9,
                itemBuilder: (BuildContext context, int index) {
                  nameControllers.add(TextEditingController());
                  ageControllers.add(TextEditingController());
                  _nameControllers.add('text');
                  _ageControllers.add('text');
                  genderControllers.add("Gender");
                  return Container(
                      padding: EdgeInsets.all(Dimentions.height20),
                      decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(Dimentions.height15),
                          color: Colors.white),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BigText(text: 'Passenger ${index + 1}'),
                          SizedBox(
                            height: Dimentions.height20,
                          ),
                          TextFormField(
                            onTap: () {
                              setState(() {
                                isKeyboard = true;
                              });
                            },
                            controller: nameControllers[index],
                            cursorColor: AppColors.bottomBarActiveColor,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                labelText: "Full Name",
                                labelStyle: TextStyle(
                                    color: isKeyboard
                                        ? Colors.black
                                        : AppColors.bottomBarActiveColor),
                                focusColor: AppColors.bottomBarActiveColor,
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.black),
                                    borderRadius: BorderRadius.circular(
                                        Dimentions.height15)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1,
                                        color: AppColors.bottomBarActiveColor),
                                    borderRadius: BorderRadius.circular(
                                        Dimentions.height15))),
                          ),
                          SizedBox(
                            height: Dimentions.height30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: Dimentions.height100,
                                child: TextField(
                                  onTap: () {
                                    setState(() {
                                      isKeyboard = true;
                                    });
                                  },
                                  cursorColor: AppColors.bottomBarActiveColor,
                                  controller: ageControllers[index],
                                  keyboardType: TextInputType.numberWithOptions(
                                      decimal: false),
                                  decoration: InputDecoration(
                                      labelText: "Age",
                                      labelStyle: TextStyle(
                                          color: isKeyboard
                                              ? Colors.black
                                              : AppColors.bottomBarActiveColor),
                                      focusColor:
                                          AppColors.bottomBarActiveColor,
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1, color: Colors.black),
                                          borderRadius: BorderRadius.circular(
                                              Dimentions.height15)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1,
                                              color: AppColors
                                                  .bottomBarActiveColor),
                                          borderRadius: BorderRadius.circular(
                                              Dimentions.height15))),
                                ),
                              ),
                              Container(
                                width: Dimentions.height200,
                                child: DropdownButtonFormField2(
                                  decoration: InputDecoration(
                                    //Add isDense true and zero Padding.
                                    //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                    border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.red),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  isExpanded: true,
                                  hint: Text(
                                    genderControllers[index],
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  items: genderItems
                                      .map((item) => DropdownMenuItem<String>(
                                            value: item,
                                            child: Text(
                                              item,
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ))
                                      .toList(),
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Please select gender.';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    setState(() {
                                      genderControllers[index] =
                                          value.toString();
                                      _nameControllers[index] =
                                          nameControllers[index].text;
                                      _ageControllers[index] =
                                          ageControllers[index].text;
                                      isKeyboard = false;
                                    });
                                  },
                                  buttonStyleData: const ButtonStyleData(
                                    height: 60,
                                    padding:
                                        EdgeInsets.only(left: 20, right: 10),
                                  ),
                                  iconStyleData: const IconStyleData(
                                    icon: Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.black,
                                    ),
                                    iconSize: 30,
                                  ),
                                  dropdownStyleData: DropdownStyleData(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ));
                },
              ),
            ),
          ]),
        )
      ],
    );
  }

  getDatePickWidget(context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.center,
          child: Column(children: [
            Text(
              "When do you want to travel?",
              style: TextStyle(
                fontSize: Dimentions.height20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: Dimentions.height30,
            ),
            Container(
              margin: EdgeInsets.only(
                  left: Dimentions.height30, right: Dimentions.height30),
              padding: EdgeInsets.all(Dimentions.height10),
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 25.0,
                        color: Colors.black87.withOpacity(0.2)),
                  ],
                  borderRadius: BorderRadius.circular(Dimentions.height30),
                  color: Colors.white),
              child: SfDateRangePicker(
                onSelectionChanged: _onSelectionChanged,
                view: DateRangePickerView.month,
                selectionMode: DateRangePickerSelectionMode.range,
                maxDate: DateTime.now().add(Duration(days: 60)),
                enablePastDates: false,
                selectionColor: AppColors.bottomBarActiveColor,
                startRangeSelectionColor: AppColors.bottomBarActiveColor,
                endRangeSelectionColor: AppColors.bottomBarActiveColor,
                rangeSelectionColor:
                    AppColors.bottomBarActiveColor.withOpacity(0.2),
                todayHighlightColor: AppColors.bottomBarActiveColor,
                initialSelectedRange: PickerDateRange(
                    DateTime.now().add(Duration(days: 2)),
                    DateTime.now().add(Duration(days: 4))),
                monthCellStyle: DateRangePickerMonthCellStyle(
                    todayTextStyle:
                        TextStyle(color: AppColors.bottomBarActiveColor)),
              ),
            ),
          ]),
        )
      ],
    );
  }

  getDepurtureTransportInfoWidgetTrain(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        BigText(text: "Select Departure Train With Class"),
        SizedBox(
          height: Dimentions.height20,
        ),
        Container(
          height: Dimentions.height350 + Dimentions.height45,
          child: ListView.builder(
              itemCount:
                  TrainData.depurtureTrain[placeMap[widget.placeName]!].length,
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return TrainWidget(
                    trainName: TrainData.depurtureTrain[placeMap[widget.placeName]!]
                            [index]['trainName']
                        .toString(),
                    trainNumber: TrainData.depurtureTrain[placeMap[widget.placeName]!]
                            [index]['trainNumber']
                        .toString(),
                    startTime: TrainData.depurtureTrain[placeMap[widget.placeName]!]
                            [index]['startTime']
                        .toString(),
                    endTime: TrainData.depurtureTrain[placeMap[widget.placeName]!]
                            [index]['endTime']
                        .toString(),
                    duration: TrainData.depurtureTrain[placeMap[widget.placeName]!]
                            [index]['duration']
                        .toString(),
                    startStation:
                        TrainData.depurtureTrain[placeMap[widget.placeName]!][index]['startStation'].toString(),
                    endStation: TrainData.depurtureTrain[placeMap[widget.placeName]!][index]['endStation'].toString(),
                    sl: TrainData.depurtureTrain[placeMap[widget.placeName]!][index]['SL'].toString(),
                    a3: TrainData.depurtureTrain[placeMap[widget.placeName]!][index]['3A'].toString(),
                    a2: TrainData.depurtureTrain[placeMap[widget.placeName]!][index]['2A'].toString(),
                    a1: TrainData.depurtureTrain[placeMap[widget.placeName]!][index]['1A'].toString());
              }),
        )
      ],
    );
  }

  getReturnTransportInfoWidgetTrain(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        BigText(text: "Select Return Train With Class"),
        SizedBox(
          height: Dimentions.height20,
        ),
        Container(
          height: Dimentions.height350 + Dimentions.height45,
          child: ListView.builder(
              itemCount:
                  TrainData.returnTrain[placeMap[widget.placeName]!].length,
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return TrainReturnWidget(
                    trainName: TrainData.returnTrain[placeMap[widget.placeName]!]
                            [index]['trainName']
                        .toString(),
                    trainNumber: TrainData.returnTrain[placeMap[widget.placeName]!]
                            [index]['trainNumber']
                        .toString(),
                    startTime: TrainData.returnTrain[placeMap[widget.placeName]!]
                            [index]['startTime']
                        .toString(),
                    endTime: TrainData.returnTrain[placeMap[widget.placeName]!]
                            [index]['endTime']
                        .toString(),
                    duration: TrainData.returnTrain[placeMap[widget.placeName]!]
                            [index]['duration']
                        .toString(),
                    startStation:
                        TrainData.returnTrain[placeMap[widget.placeName]!][index]['startStation'].toString(),
                    endStation: TrainData.returnTrain[placeMap[widget.placeName]!][index]['endStation'].toString(),
                    sl: TrainData.returnTrain[placeMap[widget.placeName]!][index]['SL'].toString(),
                    a3: TrainData.returnTrain[placeMap[widget.placeName]!][index]['3A'].toString(),
                    a2: TrainData.returnTrain[placeMap[widget.placeName]!][index]['2A'].toString(),
                    a1: TrainData.returnTrain[placeMap[widget.placeName]!][index]['1A'].toString());
              }),
        )
      ],
    );
  }

  getDepurtureTransportInfoWidgetPlane(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        BigText(text: "Select Depurture Plane"),
        SizedBox(
          height: Dimentions.height20,
        ),
        Container(
          height: Dimentions.height350 + Dimentions.height45,
          child: ListView.builder(
              itemCount:
                  PlaneData.depurturePlane[placeMap[widget.placeName]!].length,
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return PlaneWidget(
                  planeName: PlaneData
                      .depurturePlane[placeMap[widget.placeName]!][index]
                          ['planeName']
                      .toString(),
                  planeNumber: PlaneData
                      .depurturePlane[placeMap[widget.placeName]!][index]
                          ['planeNumber']
                      .toString(),
                  startTime: PlaneData
                      .depurturePlane[placeMap[widget.placeName]!][index]
                          ['startTime']
                      .toString(),
                  endTime: PlaneData.depurturePlane[placeMap[widget.placeName]!]
                          [index]['endTime']
                      .toString(),
                  duration: PlaneData
                      .depurturePlane[placeMap[widget.placeName]!][index]
                          ['duration']
                      .toString(),
                  destination: widget.placeName.toString(),
                  cost: PlaneData.depurturePlane[placeMap[widget.placeName]!]
                          [index]['cost']
                      .toString(),
                );
              }),
        )
      ],
    );
  }

  getReturnTransportInfoWidgetPlane(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        BigText(text: "Select Return Plane"),
        SizedBox(
          height: Dimentions.height20,
        ),
        Container(
          height: Dimentions.height350 + Dimentions.height45,
          child: ListView.builder(
              itemCount:
                  PlaneData.returnPlane[placeMap[widget.placeName]!].length,
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return PlaneReturnWidget(
                  planeName: PlaneData.returnPlane[placeMap[widget.placeName]!]
                          [index]['planeName']
                      .toString(),
                  planeNumber: PlaneData
                      .returnPlane[placeMap[widget.placeName]!][index]
                          ['planeNumber']
                      .toString(),
                  startTime: PlaneData.returnPlane[placeMap[widget.placeName]!]
                          [index]['startTime']
                      .toString(),
                  endTime: PlaneData.returnPlane[placeMap[widget.placeName]!]
                          [index]['endTime']
                      .toString(),
                  duration: PlaneData.returnPlane[placeMap[widget.placeName]!]
                          [index]['duration']
                      .toString(),
                  destination: widget.placeName.toString(),
                  cost: PlaneData.returnPlane[placeMap[widget.placeName]!]
                          [index]['cost']
                      .toString(),
                );
              }),
        )
      ],
    );
  }

  getHotelInfoWidget(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        BigText(text: "Select Hotel Fot Your Stay"),
        SizedBox(
          height: Dimentions.height20,
        ),
        Container(
          height: Dimentions.height350 + Dimentions.height45,
          child: ListView.builder(
              itemCount: hotel.hotel_data[placeMap[widget.placeName]!].length,
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return HotelWidget(
                  distance: hotel.hotel_data[placeMap[widget.placeName]!][index]
                          ['distance']
                      .toString(),
                  hotelName: hotel.hotel_data[placeMap[widget.placeName]!]
                          [index]['hotelName']
                      .toString(),
                  hotelRating: hotel.hotel_data[placeMap[widget.placeName]!]
                          [index]['rating']
                      .toString(),
                  hotelAddress: hotel.hotel_data[placeMap[widget.placeName]!]
                          [index]['address']
                      .toString(),
                  cost: hotel.hotel_data[placeMap[widget.placeName]!][index]
                          ['cost']
                      .toString(),
                  place: widget.placeName.toString(),
                );
              }),
        )
      ],
    );
  }

  String? depurtureName;
  String? returnName;
  getTotalCostInfoWidget(context) {
    if (trainDepurture) {
      depurtureName =
          '${depurtureTrainController.toString()} ${depurtureTrainClassController}';
    } else if (planeDepurture) {
      depurtureName = '${depurturePlaneController.toString()}';
    }
    if (trainReturn) {
      returnName =
          '${returnTrainController.toString()} ${returnTrainClassController}';
    } else if (planeReturn) {
      returnName = '${returnPlaneController.toString()}';
    }
    return Container(
      height: Dimentions.height350 + Dimentions.height350 - Dimentions.height10,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
            margin: EdgeInsets.only(
                left: Dimentions.height20, right: Dimentions.height20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BigText(
                  text: 'Booking Details',
                  size: Dimentions.height25,
                ),
                SizedBox(
                  height: Dimentions.height20,
                ),
                Row(
                  children: [
                    Container(
                      height: Dimentions.height60,
                      width: Dimentions.height60,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius:
                              BorderRadius.circular(Dimentions.height15),
                          color: Colors.white),
                      child: Center(
                        child: Icon(
                          FluentIcons.tree_deciduous_20_filled,
                          color: Colors.grey,
                          size: Dimentions.height40,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: Dimentions.height20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BigText(
                          text: 'Destination',
                          color: Colors.grey,
                          size: Dimentions.height18,
                        ),
                        BigText(
                          text: widget.placeName,
                          size: Dimentions.height18,
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: Dimentions.height20,
                ),
                Row(
                  children: [
                    Container(
                      height: Dimentions.height60,
                      width: Dimentions.height60,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius:
                              BorderRadius.circular(Dimentions.height15),
                          color: Colors.white),
                      child: Center(
                        child: Icon(
                          FluentIcons.people_community_24_filled,
                          color: Colors.grey,
                          size: Dimentions.height40,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: Dimentions.height20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BigText(
                          text: 'Passengers',
                          color: Colors.grey,
                          size: Dimentions.height18,
                        ),
                        BigText(
                          text: '$peoplecountController Adults',
                          size: Dimentions.height18,
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: Dimentions.height20,
                ),
                Row(
                  children: [
                    Container(
                      height: Dimentions.height60,
                      width: Dimentions.height60,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius:
                              BorderRadius.circular(Dimentions.height15),
                          color: Colors.white),
                      child: Center(
                        child: Icon(
                          FluentIcons.vehicle_bus_24_filled,
                          color: Colors.grey,
                          size: Dimentions.height40,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: Dimentions.height20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BigText(
                          text: 'Depurture',
                          color: Colors.grey,
                          size: Dimentions.height18,
                        ),
                        BigText(
                          text: depurtureName!,
                          size: Dimentions.height18,
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: Dimentions.height20,
                ),
                Row(
                  children: [
                    Container(
                      height: Dimentions.height60,
                      width: Dimentions.height60,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius:
                              BorderRadius.circular(Dimentions.height15),
                          color: Colors.white),
                      child: Center(
                        child: Icon(
                          FluentIcons.vehicle_bus_24_filled,
                          color: Colors.grey,
                          size: Dimentions.height40,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: Dimentions.height20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BigText(
                          text: 'Return',
                          color: Colors.grey,
                          size: Dimentions.height18,
                        ),
                        BigText(
                          text: returnName!,
                          size: Dimentions.height18,
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: Dimentions.height20,
                ),
                Row(
                  children: [
                    Row(
                      children: [
                        Container(
                          height: Dimentions.height60,
                          width: Dimentions.height60,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius:
                                  BorderRadius.circular(Dimentions.height15),
                              color: Colors.white),
                          child: Center(
                            child: Icon(
                              FluentIcons.building_20_filled,
                              color: Colors.grey,
                              size: Dimentions.height40,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: Dimentions.height20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            BigText(
                              text: 'Hotel & Resort',
                              color: Colors.grey,
                              size: Dimentions.height18,
                            ),
                            BigText(
                              text: hotelMap?['hotelName'],
                              size: Dimentions.height18,
                            )
                          ],
                        )
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: Dimentions.height20,
                ),
                Row(
                  children: [
                    Container(
                      height: Dimentions.height60,
                      width: Dimentions.height60,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius:
                              BorderRadius.circular(Dimentions.height15),
                          color: Colors.white),
                      child: Center(
                        child: Icon(
                          FluentIcons.building_20_filled,
                          color: Colors.grey,
                          size: Dimentions.height40,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: Dimentions.height20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BigText(
                          text: 'Date',
                          color: Colors.grey,
                          size: Dimentions.height18,
                        ),
                        BigText(
                          text:
                              "${DateFormat.MMMd().format(DateTime.parse(startdate))} - ${DateFormat.MMMd().format(DateTime.parse(enddate))}",
                          size: Dimentions.height18,
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: Dimentions.height20,
                ),
                BigText(
                  text: 'Payment Summery',
                  size: Dimentions.height25,
                ),
                SizedBox(
                  height: Dimentions.height20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BigText(
                      text: "Depurtuer Cost",
                      color: Colors.grey,
                    ),
                    BigText(
                      text: '₹ ${depurturetotal.toString()}',
                      color: Colors.black,
                    )
                  ],
                ),
                SizedBox(
                  height: Dimentions.height20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BigText(
                      text: "Return Cost",
                      color: Colors.grey,
                    ),
                    BigText(
                      text: '₹ ${returntotal.toString()}',
                      color: Colors.black,
                    )
                  ],
                ),
                SizedBox(
                  height: Dimentions.height20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BigText(
                      text: "Hotel Cost",
                      color: Colors.grey,
                    ),
                    BigText(
                      text: '₹ ${hoteltotal.toString()}',
                      color: Colors.black,
                    )
                  ],
                ),
                SizedBox(
                  height: Dimentions.height20,
                ),
                Container(
                  height: Dimentions.height5 - 2,
                  decoration: BoxDecoration(color: Colors.grey),
                ),
                SizedBox(
                  height: Dimentions.height20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BigText(
                      text: "Grand Total",
                      color: Colors.black,
                    ),
                    BigText(
                      text:
                          '₹ ${(depurturetotal + returntotal + hoteltotal).toString()}',
                      color: Colors.black,
                    )
                  ],
                ),
              ],
            )),
      ),
    );
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print(
        'Payment Success: ${response.paymentId} ${response.orderId} ${response.signature}');

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: BigText(text: "Success"),
              content: SmallText(
                  text:
                      'Payment Success: ${response.paymentId} ${response.orderId} ${response.signature}'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                          (route) => false);
                    },
                    child: BigText(
                      text: 'OK',
                    ))
              ],
            ));
    _razorpay.clear();
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print('Payment Error: ${response.code} - ${response.message}');
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: BigText(text: "Error"),
              content: SmallText(
                  text:
                      'Payment Error: ${response.code} - ${response.message}'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: BigText(
                      text: 'OK',
                    ))
              ],
            ));
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('External Wallet: ${response.walletName}');

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: BigText(text: "Error"),
              content:
                  SmallText(text: 'External Wallet: ${response.walletName}'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: BigText(
                      text: 'OK',
                    ))
              ],
            ));
  }

  @override
  void initState() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    depurturetotal = 0;
    returntotal = 0;
    hoteltotal = 0;
    _nameControllers.clear();
    _ageControllers.clear();
    _genderControllers.clear();
    peoplecountController = '';
    transportPreferenseController = '';

    depurtureTrainController = '';
    depurtureTrainClassController = '';
    returnTrainController = '';
    returnTrainClassController = '';
    depurturePlaneController = '';
    returnPlaneController = '';

    trainDepurture = false;
    trainReturn = false;
    planeDepurture = false;
    planeReturn = false;
    isPay = false;
    currentState = BookingInfoHandler.SHOW_DROPDOWN_FORM_PAGE;
    depurturetotal = 0;
    returntotal = 0;
    hoteltotal = 0;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: isLoading
          ? Center(
              child: CircularProgressIndicator(
                  color: AppColors.bottomBarActiveColor),
            )
          : GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
                setState(() {
                  isKeyboard = false;
                });
              },
              child: Scaffold(
                body: Column(
                  children: [
                    isKeyboard || isPay
                        ? Container()
                        : Container(
                            height: Dimentions.height250,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(widget.imageURL),
                                    fit: BoxFit.cover)),
                          ),
                    SizedBox(
                      height: Dimentions.height30,
                    ),
                    currentState == BookingInfoHandler.SHOW_DROPDOWN_FORM_PAGE
                        ? getDropdownWidget(context)
                        : currentState ==
                                BookingInfoHandler.SHOW_USER_DETAILS_FORM_PAGE
                            ? getDetailsInfoWidget(context)
                            : currentState ==
                                    BookingInfoHandler.SHOW_DATEPICK_FORM_PAGE
                                ? getDatePickWidget(context)
                                : currentState ==
                                        BookingInfoHandler
                                            .SHOW_DEPURTURE_TRANSPORT_TRAIN_FORM_PAGE
                                    ? getDepurtureTransportInfoWidgetTrain(
                                        context)
                                    : currentState ==
                                            BookingInfoHandler
                                                .SHOW_RETURN_TRANSPORT_TRAIN_FORM_PAGE
                                        ? getReturnTransportInfoWidgetTrain(
                                            context)
                                        : currentState ==
                                                BookingInfoHandler
                                                    .SHOW_DEPURTURE_TRANSPORT_PLANE_FORM_PAGE
                                            ? getDepurtureTransportInfoWidgetPlane(
                                                context)
                                            : currentState ==
                                                    BookingInfoHandler
                                                        .SHOW_RETURN_TRANSPORT_PLANE_FORM_PAGE
                                                ? getReturnTransportInfoWidgetPlane(
                                                    context)
                                                : currentState ==
                                                        BookingInfoHandler
                                                            .SHOW_HOTEL_FORM_PAGE
                                                    ? getHotelInfoWidget(
                                                        context)
                                                    : getTotalCostInfoWidget(
                                                        context)
                  ],
                ),
                bottomNavigationBar: Container(
                  margin: EdgeInsets.only(
                      top: Dimentions.height15,
                      bottom: Dimentions.height30,
                      left: Dimentions.height40,
                      right: Dimentions.height40),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: Dimentions.height50,
                          width: Dimentions.height100,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          Dimentions.height20)),
                                  primary: Colors.red),
                              onPressed: () {
                                if (currentState ==
                                    BookingInfoHandler
                                        .SHOW_DROPDOWN_FORM_PAGE) {
                                  Navigator.pop(context);
                                } else if (currentState ==
                                    BookingInfoHandler
                                        .SHOW_USER_DETAILS_FORM_PAGE) {
                                  setState(() {
                                    currentState = BookingInfoHandler
                                        .SHOW_DROPDOWN_FORM_PAGE;
                                  });
                                } else if (currentState ==
                                    BookingInfoHandler
                                        .SHOW_DATEPICK_FORM_PAGE) {
                                  setState(() {
                                    currentState = BookingInfoHandler
                                        .SHOW_USER_DETAILS_FORM_PAGE;
                                  });
                                } else if (currentState ==
                                    BookingInfoHandler
                                        .SHOW_DEPURTURE_TRANSPORT_TRAIN_FORM_PAGE) {
                                  setState(() {
                                    currentState = BookingInfoHandler
                                        .SHOW_DATEPICK_FORM_PAGE;
                                  });
                                } else if (currentState ==
                                    BookingInfoHandler
                                        .SHOW_DEPURTURE_TRANSPORT_PLANE_FORM_PAGE) {
                                  setState(() {
                                    currentState = BookingInfoHandler
                                        .SHOW_DATEPICK_FORM_PAGE;
                                  });
                                } else if (currentState ==
                                    BookingInfoHandler
                                        .SHOW_RETURN_TRANSPORT_TRAIN_FORM_PAGE) {
                                  if (trainDepurture == true) {
                                    setState(() {
                                      currentState = BookingInfoHandler
                                          .SHOW_DEPURTURE_TRANSPORT_TRAIN_FORM_PAGE;
                                    });
                                  } else if (planeDepurture == true) {
                                    setState(() {
                                      currentState = BookingInfoHandler
                                          .SHOW_DEPURTURE_TRANSPORT_PLANE_FORM_PAGE;
                                    });
                                  }
                                } else if (currentState ==
                                    BookingInfoHandler
                                        .SHOW_RETURN_TRANSPORT_PLANE_FORM_PAGE) {
                                  if (trainDepurture == true) {
                                    setState(() {
                                      currentState = BookingInfoHandler
                                          .SHOW_DEPURTURE_TRANSPORT_TRAIN_FORM_PAGE;
                                    });
                                  } else if (planeDepurture == true) {
                                    setState(() {
                                      currentState = BookingInfoHandler
                                          .SHOW_DEPURTURE_TRANSPORT_PLANE_FORM_PAGE;
                                    });
                                  }
                                } else if (currentState ==
                                    BookingInfoHandler.SHOW_HOTEL_FORM_PAGE) {
                                  if (trainReturn == true) {
                                    setState(() {
                                      currentState = BookingInfoHandler
                                          .SHOW_RETURN_TRANSPORT_TRAIN_FORM_PAGE;
                                    });
                                  } else if (planeReturn == true) {
                                    setState(() {
                                      currentState = BookingInfoHandler
                                          .SHOW_RETURN_TRANSPORT_PLANE_FORM_PAGE;
                                    });
                                  }
                                } else if (currentState ==
                                    BookingInfoHandler
                                        .SHOW_TOTAL_COST_FORM_PAGE) {
                                  setState(() {
                                    currentState =
                                        BookingInfoHandler.SHOW_HOTEL_FORM_PAGE;
                                    isPay = false;
                                  });
                                }
                              },
                              child: BigText(
                                text: "back",
                                color: Colors.white,
                              )),
                        ),
                        isPay
                            ? SizedBox()
                            : Container(
                                height: Dimentions.height50,
                                child: Column(
                                  children: [
                                    BigText(
                                      text: "Total",
                                    ),
                                    BigText(
                                        text:
                                            '${depurturetotal + returntotal + hoteltotal}'),
                                  ],
                                ),
                              ),
                        isPay
                            ? Container(
                                height: Dimentions.height50,
                                width: Dimentions.height200,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                Dimentions.height20)),
                                        primary:
                                            AppColors.bottomBarActiveColor),
                                    onPressed: () {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      SaveOrderData(
                                              peopleCount: peoplecountController
                                                  .toString(),
                                              startdate: startdate,
                                              placeDetails: {
                                                'placeName': widget.placeName,
                                                'location': widget.location,
                                                'imageURL': widget.imageURL,
                                                'price': depurturetotal +
                                                    returntotal +
                                                    hoteltotal,
                                                'startDate': startdate,
                                                'endDate': enddate
                                              },
                                              enddate: enddate,
                                              peopleInfo: {
                                                'name': _nameControllers,
                                                'age': _ageControllers,
                                                'gender': genderControllers
                                              },
                                              depurtureName: depurtureName!,
                                              depurtureCost:
                                                  depurturetotal.toString(),
                                              returnName: returnName!,
                                              returnCost:
                                                  returntotal.toString(),
                                              hotel: hotelMap as Map)
                                          .saveOrderData();
                                      setState(() {
                                        isLoading = false;
                                      });

                                      var options = {
                                        'key': 'rzp_test_l8klnmbJhuFzRM',
                                        'amount': depurturetotal.toDouble() +
                                            returntotal.toDouble() +
                                            hoteltotal.toDouble(),
                                        'name': 'Trilix',
                                        'description':
                                            '${widget.placeName} Trip',
                                        'prefill': {
                                          'contact': '8888888888',
                                          'email': 'test@razorpay.com',
                                        }
                                      };
                                      _razorpay.open(options);
                                    },
                                    child: BigText(
                                      text: "Proceed To Pay ",
                                      color: Colors.white,
                                    )),
                              )
                            : Container(
                                height: Dimentions.height50,
                                width: Dimentions.height100,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                Dimentions.height20)),
                                        primary:
                                            AppColors.bottomBarActiveColor),
                                    onPressed: () {
                                      if (currentState ==
                                          BookingInfoHandler
                                              .SHOW_DROPDOWN_FORM_PAGE) {
                                        if (peoplecountController == null) {
                                          showSnackBar(context,
                                              "Choose How many people are travelling first");
                                        } else if (transportPreferenseController ==
                                            null) {
                                          showSnackBar(context,
                                              "Choose your prefered mode of travel first");
                                        } else {
                                          setState(() {
                                            currentState = BookingInfoHandler
                                                .SHOW_USER_DETAILS_FORM_PAGE;
                                          });
                                        }
                                      } else if (currentState ==
                                          BookingInfoHandler
                                              .SHOW_USER_DETAILS_FORM_PAGE) {
                                        setState(() {
                                          _nameControllers.length = int.parse(
                                              peoplecountController.toString());
                                          _ageControllers.length = int.parse(
                                              peoplecountController.toString());
                                          genderControllers.length = int.parse(
                                              peoplecountController.toString());
                                          currentState = BookingInfoHandler
                                              .SHOW_DATEPICK_FORM_PAGE;
                                        });
                                      } else if (currentState ==
                                          BookingInfoHandler
                                              .SHOW_DATEPICK_FORM_PAGE) {
                                        if (trainDepurture == true) {
                                          setState(() {
                                            currentState = BookingInfoHandler
                                                .SHOW_DEPURTURE_TRANSPORT_TRAIN_FORM_PAGE;
                                          });
                                        } else if (planeDepurture == true) {
                                          setState(() {
                                            currentState = BookingInfoHandler
                                                .SHOW_DEPURTURE_TRANSPORT_PLANE_FORM_PAGE;
                                          });
                                        }
                                      } else if (currentState ==
                                          BookingInfoHandler
                                              .SHOW_DEPURTURE_TRANSPORT_TRAIN_FORM_PAGE) {
                                        if (depurtureTrainController == null) {
                                          showSnackBar(
                                              context, 'Select a train first');
                                        } else {
                                          if (trainReturn == true) {
                                            setState(() {
                                              currentState = BookingInfoHandler
                                                  .SHOW_RETURN_TRANSPORT_TRAIN_FORM_PAGE;
                                            });
                                          } else if (planeReturn == true) {
                                            setState(() {
                                              currentState = BookingInfoHandler
                                                  .SHOW_RETURN_TRANSPORT_PLANE_FORM_PAGE;
                                            });
                                          }
                                        }
                                      } else if (currentState ==
                                          BookingInfoHandler
                                              .SHOW_DEPURTURE_TRANSPORT_PLANE_FORM_PAGE) {
                                        if (depurturePlaneController == null) {
                                          showSnackBar(
                                              context, 'Select a plane first');
                                        } else {
                                          if (trainReturn == true) {
                                            setState(() {
                                              currentState = BookingInfoHandler
                                                  .SHOW_RETURN_TRANSPORT_TRAIN_FORM_PAGE;
                                            });
                                          } else if (planeReturn == true) {
                                            setState(() {
                                              currentState = BookingInfoHandler
                                                  .SHOW_RETURN_TRANSPORT_PLANE_FORM_PAGE;
                                            });
                                          }
                                        }
                                      } else if (currentState ==
                                          BookingInfoHandler
                                              .SHOW_RETURN_TRANSPORT_PLANE_FORM_PAGE) {
                                        if (returnPlaneController == null) {
                                          showSnackBar(
                                              context, 'Select a plane first');
                                        } else {
                                          setState(() {
                                            currentState = BookingInfoHandler
                                                .SHOW_HOTEL_FORM_PAGE;
                                          });
                                        }
                                      } else if (currentState ==
                                          BookingInfoHandler
                                              .SHOW_RETURN_TRANSPORT_TRAIN_FORM_PAGE) {
                                        if (returnTrainController == null) {
                                          showSnackBar(
                                              context, 'Select a train first');
                                        } else {
                                          setState(() {
                                            currentState = BookingInfoHandler
                                                .SHOW_HOTEL_FORM_PAGE;
                                          });
                                        }
                                      } else if (currentState ==
                                          BookingInfoHandler
                                              .SHOW_HOTEL_FORM_PAGE) {
                                        if (hotelMap == null) {
                                          showSnackBar(
                                              context, 'Select a hotel first');
                                        } else {
                                          setState(() {
                                            currentState = BookingInfoHandler
                                                .SHOW_TOTAL_COST_FORM_PAGE;
                                            isPay = true;
                                          });
                                        }
                                      }
                                    },
                                    child: BigText(
                                      text: "Next",
                                      color: Colors.white,
                                    )),
                              )
                      ]),
                ),
              ),
            ),
    );
  }
}
