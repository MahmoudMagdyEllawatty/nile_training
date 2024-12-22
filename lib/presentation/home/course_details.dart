
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:nile_training/core/app_export.dart';
import 'package:nile_training/widgets/custom_elevated_button.dart';

import '../../core/utils/Constants.dart';
import '../../models/Category.dart';
import '../../models/Course.dart';
import '../../theme/theme_helper.dart';

final bool _kAutoConsume = Platform.isIOS || true;



class CourseDetailsPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return CourseDetailsState();
  }

}


class CourseDetailsState extends State<CourseDetailsPage>{

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  List<ProductDetails> products = [];
  bool _isAvailable = true;
  bool _purchased = false;
  late StreamSubscription<List<PurchaseDetails>> _subscription;


  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    _initializeInAppPurchase();
  }

  void _initializeInAppPurchase() async{
    final available = await _inAppPurchase.isAvailable();
    setState(() {
      _isAvailable = available;
    });
    if(available){
      _getProducts();
      _listenToPurchaseUpdates();
    }
  }

  void _getProducts() async {
    const Set<String> _KIds = { "MC0001" } ;
    ProductDetailsResponse response = await _inAppPurchase.queryProductDetails(_KIds);
    if(response.notFoundIDs.isNotEmpty){

    }else{
      setState(() {
        products = response.productDetails;
      });

    }
  }

  void _listenToPurchaseUpdates(){
    _subscription = _inAppPurchase.purchaseStream.listen((purchases){
      _handlePurchaseUpdates(purchases);
    });
  }

  void _handlePurchaseUpdates(List<PurchaseDetails> purchases){
    for(var purchase in purchases){
      if(purchase.status == PurchaseStatus.pending){
        _showPendingDialog();
      }else if(purchase.status == PurchaseStatus.purchased){
        _verifyPurchase(purchase);
      }else if(purchase.status == PurchaseStatus.error){
        _showErrorDialog(purchase.error);
      }
    }
  }

  void _verifyPurchase(PurchaseDetails purchase) async {
    if(purchase.productID == ''){
      setState(() {
        _purchased = true;
      });
    }
    await _inAppPurchase.completePurchase(purchase);
  }

  void _showPendingDialog(){
    showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: Text("Purchase Pending"),
        content: CircularProgressIndicator(),
        actions: [
          TextButton(onPressed: (){
            Navigator.of(context).pop();
          }, child: Text("OK"))
        ],
      );
    });
  }

  void _showErrorDialog(IAPError? error){
    showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: Text("Purchase Failed"),
        content: Text(error?.message ?? "An Unknown error occurred."),
        actions: [
          TextButton(
              onPressed: (){
                Navigator.of(context).pop();
              },
              child: Text("OK"))
        ],
      );
    });
  }

  void _buyProduct(ProductDetails product) async {
    final purchaseParam = PurchaseParam(productDetails: product);
    _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.white
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(Constants.category.name,style: theme.textTheme.titleLarge!.copyWith(height: 1.60),),
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.all(10.0),
            color: Color(0xE00909),
            child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.h)),
                    side: BorderSide(
                      // border color
                        color: Colors.transparent,
                        // border thickness
                        width: 1)),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(child: Container(
                      padding: EdgeInsets.all(5.h),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.h),
                        child: CustomImageView(
                          imagePath: ImageConstant.imgDefaultCourse,
                          height: 250.h,
                          width: double.maxFinite,
                          alignment: Alignment.center,
                        ),
                      ),
                    ),),
                    Center(child: Text(Constants.course.name,style: theme.textTheme.bodyMedium!.copyWith(height: 1.60),)),
                    Table(
                      border: TableBorder.all(color: Colors.white),
                      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                      children: [
                        TableRow(
                          decoration: BoxDecoration(
                            color: Colors.white
                          ),
                          children: [
                            TableCell(
                                verticalAlignment: TableCellVerticalAlignment.middle,
                                child: Padding(
                                  padding: EdgeInsets.all(8.h),
                                  child: Text("Trainer Name",style: theme.textTheme.bodyLarge!.copyWith(height: 1.60),),
                                )
                            ),
                            TableCell(
                                verticalAlignment: TableCellVerticalAlignment.middle,
                                child: Padding(
                                  padding: EdgeInsets.all(8.h),
                                  child: Text(Constants.course.teacherName,style: theme.textTheme.bodyLarge!.copyWith(height: 1.60),),
                                )
                            )
                          ]
                        ),
                        TableRow(
                            decoration: BoxDecoration(
                                color: Color(0xFFD7D7D7)
                            ),
                            children: [
                              TableCell(
                                  verticalAlignment: TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: EdgeInsets.all(8.h),
                                    child: Text("Available From",style: theme.textTheme.bodyLarge!.copyWith(height: 1.60),),
                                  )
                              ),
                              TableCell(
                                  verticalAlignment: TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: EdgeInsets.all(8.h),
                                    child: Text(Constants.course.startDate,style: theme.textTheme.bodyLarge!.copyWith(height: 1.60),),
                                  )
                              )
                            ]
                        ),
                        TableRow(
                            decoration: BoxDecoration(
                                color: Colors.white
                            ),
                            children: [
                              TableCell(
                                  verticalAlignment: TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: EdgeInsets.all(8.h),
                                    child: Text("Available To",style: theme.textTheme.bodyLarge!.copyWith(height: 1.60),),
                                  )
                              ),
                              TableCell(
                                  verticalAlignment: TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: EdgeInsets.all(8.h),
                                    child: Text(Constants.course.endDate,style: theme.textTheme.bodyLarge!.copyWith(height: 1.60),),
                                  )
                              )
                            ]
                        ),
                        TableRow(
                            decoration: BoxDecoration(
                                color: Colors.white
                            ),
                            children: [
                              TableCell(
                                  verticalAlignment: TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: EdgeInsets.all(8.h),
                                    child: Text("Price",style: theme.textTheme.bodyLarge!.copyWith(height: 1.60),),
                                  )
                              ),
                              TableCell(
                                  verticalAlignment: TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: EdgeInsets.all(8.h),
                                    child: Text(Constants.course.cashPrice,style: theme.textTheme.bodyLarge!.copyWith(height: 1.60),),
                                  )
                              )
                            ]
                        ),
                        TableRow(
                            decoration: BoxDecoration(
                                color: Color(0xFFD7D7D7)
                            ),
                            children: [
                              TableCell(
                                  verticalAlignment: TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: EdgeInsets.all(8.h),
                                    child: Text("Notes",style: theme.textTheme.bodyLarge!.copyWith(height: 1.60),),
                                  )
                              ),
                              TableCell(
                                  verticalAlignment: TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: EdgeInsets.all(8.h),
                                    child: Text(Constants.course.notes,style: theme.textTheme.bodyLarge!.copyWith(height: 1.60),),
                                  )
                              )
                            ]
                        ),
                      ],

                    ),
                    Visibility(
                      visible: _purchased,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomElevatedButton(
                            text: "Open Videos",
                            onPressed: (){
                                if(Constants.user.id == "0"){
                                  Navigator.pushNamed(
                                      context, AppRoutes.loginScreen);
                                }else {
                                  Navigator.pushNamed(
                                      context, AppRoutes.courseVideosScreen);
                                }
                            },
                        ),
                      ),
                    ),
                    Visibility(
                      visible: !_purchased,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomElevatedButton(
                          text: "Pay",
                          onPressed: (){
                            if(Constants.user.id == "0"){
                              Navigator.pushNamed(
                                  context, AppRoutes.loginScreen);
                            }else {
                                _buyProduct(products[0]);
                            }
                          },
                        ),
                      ),
                    )
                  ],
                )
            )

        ),
      ),
    );
  }

}