import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trilix/data/firebase/get_data.dart';
import 'package:trilix/data/firebase/get_order_data.dart';
import 'package:trilix/pages/bookings/mobile.dart';
import 'package:trilix/utils/colors.dart';
import 'package:trilix/utils/dimensions.dart';
import 'package:trilix/utils/widgets/big_text.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class OrderHistoryDetial extends StatefulWidget {
  String placeName;
  String startdate;
  String enddate;
  String peopleCount;
  String total;
  String deputureName;
  String returnName;
  String imageURL;
  String hotelCost;
  String depurtureCost;
  String returnCost;
  String hotel;
  OrderHistoryDetial({
    super.key,
    required this.placeName,
    required this.startdate,
    required this.enddate,
    required this.peopleCount,
    required this.total,
    required this.imageURL,
    required this.hotelCost,
    required this.deputureName,
    required this.returnName,
    required this.depurtureCost,
    required this.returnCost,
    required this.hotel,
  });

  @override
  State<OrderHistoryDetial> createState() => _OrderHistoryDetialState();
}

final _auth = FirebaseAuth.instance;
Map<String, dynamic> user_data = {};
Map<String, dynamic> order_data = {};
bool isLoading = true;

class _OrderHistoryDetialState extends State<OrderHistoryDetial> {
  @override
  Widget build(BuildContext context) {
    Future<void> getUserData() async {
      Map<String, dynamic> data = await DatabaseService().getUser();
      if (!mounted) {
        return;
      }
      setState(() {
        user_data = data;
      });
    }

    Future<void> getOrder() async {
      CollectionReference orders =
          await FirebaseFirestore.instance.collection('orders');
      final snapshot = await orders.doc(_auth.currentUser?.uid).get();
      if (snapshot.exists) {
        if (!mounted) {
          return;
        }
        setState(() {
          order_data = snapshot.data() as Map<String, dynamic>;
          isLoading = false;
        });
      } else {
        if (!mounted) {
          return;
        }
        setState(() {
          isLoading = false;
        });
      }
    }

    getUserData();
    getOrder();
    return isLoading
        ? Scaffold(
            body: Center(
                child: CircularProgressIndicator(
              color: AppColors.bottomBarActiveColor,
            )),
          )
        : Scaffold(
            bottomNavigationBar: Container(
              margin: EdgeInsets.symmetric(
                  vertical: Dimentions.height17,
                  horizontal: Dimentions.height20),
              height: Dimentions.height50,
              width: Dimentions.height120,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(Dimentions.height20)),
                      primary: AppColors.bottomBarActiveColor),
                  onPressed: _createPDF,
                  child: BigText(
                    text: "Get Payment Invoice",
                    color: Colors.white,
                  )),
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            left: Dimentions.height10,
                            right: Dimentions.height10,
                            top: Dimentions.height10),
                        height: Dimentions.height300,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.8),
                                blurRadius: 20.0,
                                spreadRadius: 1,
                                offset: Offset(0, 20),
                              )
                            ],
                            borderRadius:
                                BorderRadius.circular(Dimentions.height20),
                            image: DecorationImage(
                                image: AssetImage(widget.imageURL),
                                fit: BoxFit.cover)),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: Dimentions.height30,
                            left: Dimentions.height30,
                            right: Dimentions.height30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                width: Dimentions.height50,
                                height: Dimentions.height50,
                                child: Center(
                                    child:
                                        Icon(FluentIcons.arrow_left_16_filled)),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        Dimentions.height30),
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: Dimentions.height20,
                  ),
                  Container(
                    height: Dimentions.height350 + Dimentions.height50,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Container(
                          margin: EdgeInsets.only(
                              left: Dimentions.height20,
                              right: Dimentions.height20),
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
                                        borderRadius: BorderRadius.circular(
                                            Dimentions.height15),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                        borderRadius: BorderRadius.circular(
                                            Dimentions.height15),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      BigText(
                                        text: 'Passengers',
                                        color: Colors.grey,
                                        size: Dimentions.height18,
                                      ),
                                      BigText(
                                        text:
                                            '${widget.peopleCount.toString()} Adults',
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
                                        borderRadius: BorderRadius.circular(
                                            Dimentions.height15),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      BigText(
                                        text: 'Depurture',
                                        color: Colors.grey,
                                        size: Dimentions.height18,
                                      ),
                                      BigText(
                                        text: widget.deputureName.toString(),
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
                                        borderRadius: BorderRadius.circular(
                                            Dimentions.height15),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      BigText(
                                        text: 'Return',
                                        color: Colors.grey,
                                        size: Dimentions.height18,
                                      ),
                                      BigText(
                                        text: widget.returnName,
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
                                            border:
                                                Border.all(color: Colors.grey),
                                            borderRadius: BorderRadius.circular(
                                                Dimentions.height15),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          BigText(
                                            text: 'Hotel & Resort',
                                            color: Colors.grey,
                                            size: Dimentions.height18,
                                          ),
                                          BigText(
                                            text: widget.hotel,
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
                                        borderRadius: BorderRadius.circular(
                                            Dimentions.height15),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      BigText(
                                        text: 'Date',
                                        color: Colors.grey,
                                        size: Dimentions.height18,
                                      ),
                                      BigText(
                                        text:
                                            "${DateFormat.MMMd().format(DateTime.parse(widget.startdate))} - ${DateFormat.MMMd().format(DateTime.parse(widget.enddate))}",
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  BigText(
                                    text: "Depurture Cost",
                                    color: Colors.grey,
                                  ),
                                  BigText(
                                    text:
                                        '₹ ${widget.depurtureCost.toString()}',
                                    color: Colors.black,
                                  )
                                ],
                              ),
                              SizedBox(
                                height: Dimentions.height20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  BigText(
                                    text: "Return Cost",
                                    color: Colors.grey,
                                  ),
                                  BigText(
                                    text: '₹ ${widget.returnCost.toString()}',
                                    color: Colors.black,
                                  )
                                ],
                              ),
                              SizedBox(
                                height: Dimentions.height20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  BigText(
                                    text: "Hotel Cost",
                                    color: Colors.grey,
                                  ),
                                  BigText(
                                    text: '₹ ${widget.hotelCost.toString()}',
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  BigText(
                                    text: "Grand Total",
                                    color: Colors.black,
                                  ),
                                  BigText(
                                    text: '₹ ${widget.total.toString()}',
                                    color: Colors.black,
                                  )
                                ],
                              ),
                            ],
                          )),
                    ),
                  ),
                ],
              ),
            ),
          );
    ;
  }

  Future<void> _createPDF() async {
    PdfDocument document = PdfDocument();
    PdfPage page = document.pages.add();
    PdfGraphics graphics = page.graphics;

    PdfImage image = PdfBitmap.fromBase64String(
        'iVBORw0KGgoAAAANSUhEUgAAB4wAAAMgCAYAAADYzZ+1AAAACXBIWXMAAC4jAAAuIwF4pT92AAAG72lUWHRYTUw6Y29tLmFkb2JlLnhtcAAAAAAAPD94cGFja2V0IGJlZ2luPSLvu78iIGlkPSJXNU0wTXBDZWhpSHpyZVN6TlRjemtjOWQiPz4gPHg6eG1wbWV0YSB4bWxuczp4PSJhZG9iZTpuczptZXRhLyIgeDp4bXB0az0iQWRvYmUgWE1QIENvcmUgOS4wLWMwMDEgNzkuMTRlY2I0MiwgMjAyMi8xMi8wMi0xOToxMjo0NCAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1sbnM6c3RFdnQ9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZUV2ZW50IyIgeG1sbnM6cGhvdG9zaG9wPSJodHRwOi8vbnMuYWRvYmUuY29tL3Bob3Rvc2hvcC8xLjAvIiB4bWxuczpkYz0iaHR0cDovL3B1cmwub3JnL2RjL2VsZW1lbnRzLzEuMS8iIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIDI0LjIgKFdpbmRvd3MpIiB4bXA6Q3JlYXRlRGF0ZT0iMjAyMy0wNS0xN1QyMzoxOTo0NiswNTozMCIgeG1wOk1ldGFkYXRhRGF0ZT0iMjAyMy0wNS0xN1QyMzoxOTo0NiswNTozMCIgeG1wOk1vZGlmeURhdGU9IjIwMjMtMDUtMTdUMjM6MTk6NDYrMDU6MzAiIHhtcE1NOkluc3RhbmNlSUQ9InhtcC5paWQ6OTFhZjI4YmQtMTBkNS0wNjQxLWIzMGItNDc4ZDAzYzRjYmQwIiB4bXBNTTpEb2N1bWVudElEPSJhZG9iZTpkb2NpZDpwaG90b3Nob3A6YmVjZjA5YzMtNmRhNS0yNDRiLWIxZGYtMmViMmZjNWYyYTg0IiB4bXBNTTpPcmlnaW5hbERvY3VtZW50SUQ9InhtcC5kaWQ6MGQxOGE5ZTYtOGQxYy04MzQxLThlYmUtOTA4ZDE1ZmRlMjM2IiBwaG90b3Nob3A6Q29sb3JNb2RlPSIzIiBkYzpmb3JtYXQ9ImltYWdlL3BuZyI+IDx4bXBNTTpIaXN0b3J5PiA8cmRmOlNlcT4gPHJkZjpsaSBzdEV2dDphY3Rpb249ImNyZWF0ZWQiIHN0RXZ0Omluc3RhbmNlSUQ9InhtcC5paWQ6MGQxOGE5ZTYtOGQxYy04MzQxLThlYmUtOTA4ZDE1ZmRlMjM2IiBzdEV2dDp3aGVuPSIyMDIzLTA1LTE3VDIzOjE5OjQ2KzA1OjMwIiBzdEV2dDpzb2Z0d2FyZUFnZW50PSJBZG9iZSBQaG90b3Nob3AgMjQuMiAoV2luZG93cykiLz4gPHJkZjpsaSBzdEV2dDphY3Rpb249InNhdmVkIiBzdEV2dDppbnN0YW5jZUlEPSJ4bXAuaWlkOjkxYWYyOGJkLTEwZDUtMDY0MS1iMzBiLTQ3OGQwM2M0Y2JkMCIgc3RFdnQ6d2hlbj0iMjAyMy0wNS0xN1QyMzoxOTo0NiswNTozMCIgc3RFdnQ6c29mdHdhcmVBZ2VudD0iQWRvYmUgUGhvdG9zaG9wIDI0LjIgKFdpbmRvd3MpIiBzdEV2dDpjaGFuZ2VkPSIvIi8+IDwvcmRmOlNlcT4gPC94bXBNTTpIaXN0b3J5PiA8cGhvdG9zaG9wOlRleHRMYXllcnM+IDxyZGY6QmFnPiA8cmRmOmxpIHBob3Rvc2hvcDpMYXllck5hbWU9IlRSSUxJWCIgcGhvdG9zaG9wOkxheWVyVGV4dD0iVFJJTElYIi8+IDwvcmRmOkJhZz4gPC9waG90b3Nob3A6VGV4dExheWVycz4gPHBob3Rvc2hvcDpEb2N1bWVudEFuY2VzdG9ycz4gPHJkZjpCYWc+IDxyZGY6bGk+YWRvYmU6ZG9jaWQ6cGhvdG9zaG9wOjU4OTI2NjY0LTMzZjAtOTg0MC05ZDU5LTA5MGZhMjk5OGE5NDwvcmRmOmxpPiA8L3JkZjpCYWc+IDwvcGhvdG9zaG9wOkRvY3VtZW50QW5jZXN0b3JzPiA8L3JkZjpEZXNjcmlwdGlvbj4gPC9yZGY6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');
    page.graphics.drawImage(image, Rect.fromLTWH(140, 0, 210, 80));

    PdfBrush solidBrush = PdfSolidBrush(PdfColor(126, 151, 173));
    Rect bounds = Rect.fromLTWH(0, 160, graphics.clientSize.width, 30);

    //Draws a rectangle to place the heading in that region
    graphics.drawRectangle(brush: solidBrush, bounds: bounds);

//Creates a font for adding the heading in the page
    PdfFont subHeadingFont = PdfStandardFont(PdfFontFamily.timesRoman, 14);

    PdfTextElement element =
        PdfTextElement(text: 'INVOICE', font: subHeadingFont);
    element.brush = PdfBrushes.white;

//Draws the heading on the page
    PdfLayoutResult result = element.draw(
        page: page, bounds: Rect.fromLTWH(10, bounds.top + 8, 0, 0))!;

//Use 'intl' package for date format.
    String currentDate = 'DATE ' + DateFormat.yMMMd().format(DateTime.now());

//Measures the width of the text to place it in the correct location
    Size textSize = subHeadingFont.measureString(currentDate);
    Offset textPosition = Offset(
        graphics.clientSize.width - textSize.width - 10, result.bounds.top);

//Draws the date by using drawString method
    graphics.drawString(currentDate, subHeadingFont,
        brush: element.brush,
        bounds: Offset(graphics.clientSize.width - textSize.width - 10,
                result.bounds.top) &
            Size(textSize.width + 2, 20));

    element = PdfTextElement(
        text: 'BILL TO ',
        font: PdfStandardFont(PdfFontFamily.timesRoman, 10,
            style: PdfFontStyle.bold));
    element.brush = PdfSolidBrush(PdfColor(126, 155, 203));
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(10, result.bounds.bottom + 25, 0, 0))!;

    PdfFont timesRoman = PdfStandardFont(PdfFontFamily.timesRoman, 10);

    element = PdfTextElement(
        text: user_data['firstName'].toString() +
            " " +
            user_data['lastName'].toString(),
        font: timesRoman);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(10, result.bounds.bottom + 10, 0, 0))!;

    element = PdfTextElement(text: user_data['email'], font: timesRoman);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page,
        bounds: Rect.fromLTWH(10, result.bounds.bottom + 10, 0, 0))!;
//Draws a line at the bottom of the address
    graphics.drawLine(
        PdfPen(PdfColor(126, 151, 173), width: 0.7),
        Offset(0, result.bounds.bottom + 3),
        Offset(graphics.clientSize.width, result.bounds.bottom + 3));
    //Passenger Details
    PdfGrid grid = PdfGrid();

//Add the columns to the grid
    grid.columns.add(count: 5);

//Add header to the grid
    grid.headers.add(1);

    PdfGridRow header = grid.headers[0];
    header.cells[0].value = 'Service Name';
    header.cells[1].value = 'Passengers';
    header.cells[2].value = 'Start Date';
    header.cells[3].value = 'End Date';
    header.cells[4].value = 'Price';

    //Creates the header style
    PdfGridCellStyle headerStyle = PdfGridCellStyle();
    headerStyle.borders.all = PdfPen(PdfColor(126, 151, 173));
    headerStyle.backgroundBrush = PdfSolidBrush(PdfColor(126, 151, 173));
    headerStyle.textBrush = PdfBrushes.white;
    headerStyle.font = PdfStandardFont(PdfFontFamily.timesRoman, 14,
        style: PdfFontStyle.regular);

    //Adds cell customizations
    for (int i = 0; i < header.cells.count; i++) {
      if (i == 0 || i == 1) {
        header.cells[i].stringFormat = PdfStringFormat(
            alignment: PdfTextAlignment.left,
            lineAlignment: PdfVerticalAlignment.middle);
      } else {
        header.cells[i].stringFormat = PdfStringFormat(
            alignment: PdfTextAlignment.right,
            lineAlignment: PdfVerticalAlignment.middle);
      }
      header.cells[i].style = headerStyle;
    }

    //Add rows to grid
    PdfGridRow row = grid.rows.add();
    row.cells[0].value = widget.deputureName;
    row.cells[1].value = widget.peopleCount;
    row.cells[2].value =
        '${DateFormat('yMd').format(DateTime.parse(widget.startdate))}';
    row.cells[3].value =
        '${DateFormat('yMd').format(DateTime.parse(widget.startdate))}';
    ;
    row.cells[4].value = "Rs. ${widget.depurtureCost}";

    row = grid.rows.add();
    row.cells[0].value = widget.hotel;
    row.cells[1].value = widget.peopleCount;
    row.cells[2].value =
        '${DateFormat('yMd').format(DateTime.parse(widget.startdate))}';
    row.cells[3].value =
        '${DateFormat('yMd').format(DateTime.parse(widget.enddate))}';
    row.cells[4].value = "Rs. ${widget.hotelCost}";

    row = grid.rows.add();
    row.cells[0].value = widget.returnName;
    row.cells[1].value = widget.peopleCount;
    row.cells[2].value =
        '${DateFormat('yMd').format(DateTime.parse(widget.enddate))}';
    ;
    row.cells[3].value =
        '${DateFormat('yMd').format(DateTime.parse(widget.enddate))}';
    row.cells[4].value = "Rs. ${widget.returnCost}";

    grid.style.cellPadding = PdfPaddings(left: 2, right: 2, top: 2, bottom: 2);

//Creates the grid cell styles
    PdfGridCellStyle cellStyle = PdfGridCellStyle();
    cellStyle.borders.all = PdfPens.white;
    cellStyle.borders.bottom = PdfPen(PdfColor(217, 217, 217), width: 0.70);
    cellStyle.font = PdfStandardFont(PdfFontFamily.timesRoman, 12);
    cellStyle.textBrush = PdfSolidBrush(PdfColor(131, 130, 136));
//Adds cell customizations
    for (int i = 0; i < grid.rows.count; i++) {
      PdfGridRow row = grid.rows[i];
      for (int j = 0; j < row.cells.count; j++) {
        row.cells[j].style = cellStyle;
        if (j == 0 || j == 1) {
          row.cells[j].stringFormat = PdfStringFormat(
              alignment: PdfTextAlignment.left,
              lineAlignment: PdfVerticalAlignment.middle);
        } else {
          row.cells[j].stringFormat = PdfStringFormat(
              alignment: PdfTextAlignment.right,
              lineAlignment: PdfVerticalAlignment.middle);
        }
      }
    }

//Creates layout format settings to allow the table pagination
    PdfLayoutFormat layoutFormat =
        PdfLayoutFormat(layoutType: PdfLayoutType.paginate);

//Draws the grid to the PDF page
    PdfLayoutResult gridResult = grid.draw(
        page: page,
        bounds: Rect.fromLTWH(0, result.bounds.bottom + 20,
            graphics.clientSize.width, graphics.clientSize.height - 100),
        format: layoutFormat)!;

    gridResult.page.graphics.drawString(
        'Grand Total :                             Rs. ${widget.total}',
        subHeadingFont,
        brush: PdfSolidBrush(PdfColor(126, 155, 203)),
        bounds: Rect.fromLTWH(275, gridResult.bounds.bottom + 30, 0, 0));

    gridResult.page.graphics.drawString(
        'Thank you for your business !', subHeadingFont,
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(340, gridResult.bounds.bottom + 60, 0, 0));

    List<int> bytes = await document.save();
    saveAndLaunchFile(bytes, 'Invoice.pdf');
    document.dispose();
  }
}
