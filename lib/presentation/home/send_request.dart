

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:http/http.dart'as http;
import 'package:nile_training/core/app_export.dart';
import 'package:path/path.dart' as p;
import '../../core/utils/Constants.dart';
import '../../models/PaymentType.dart';
import '../../theme/theme_helper.dart';
import '../../widgets/custom_elevated_button.dart';

class SendRequestPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SendRequestState();
  }
  
}

class _SendRequestState extends State<SendRequestPage>{

  String paymentMethod = 'cash'; // default
  File? receiptImage;
  TextEditingController amountController = TextEditingController();
  PaymentType? selectedPaymentType;
  final ImagePicker _picker = ImagePicker();
  List<PaymentType> paymentTypes = [];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadCategories();
  }
  Future<String> loadCategories() async{
    final response = await http.get(
      Uri.parse(Constants.BASE_URL+"payment_types"),
      headers: {
        "Content-type" : "application/json",
        "Accept":"application/json"
      },
    );
    if(response.statusCode == 200){
      setState(() {

        dynamic parsed = json.decode(response.body);
        final categoriesData = parsed['categories'];

        for(int i = 0;i< parsed['products_count'];i++){
          final catObj = categoriesData[i];
          PaymentType  category = PaymentType(catObj['id'].toString(), catObj['type']);
          paymentTypes.add(category);
        }

      });
      return "تم تسجيل الدخول بنجاح";
    }else{
      return "";
    }
  }



  Future<void> pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        receiptImage = File(pickedFile.path);
      });
    }
  }

  void submitRequest() async{
    if (receiptImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please, Select Payment Image')),
      );
      return;
    }
    if (amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please, Enter Paid Amount')),
      );
      return;
    }

    if (selectedPaymentType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please, Select Payment Type')),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(child: CircularProgressIndicator()),
    );
    final uri = Uri.parse(Constants.BASE_URL+"send_request");
    final request = http.MultipartRequest('POST', uri);
    request.fields["trainee_id"] = Constants.user.id.toString();
    request.fields["course_id"] = Constants.course.id.toString();
    request.fields["paid_by"] = selectedPaymentType!.id.toString();
    request.fields["amount"] = amountController.text;
    request.fields["payment_type"] = paymentMethod;
    final imageStream = http.MultipartFile.fromBytes(
        'attachment',
        await receiptImage!.readAsBytes(),
        filename: p.basename(receiptImage!.path),
    );

    request.files.add(imageStream);
    final response = await request.send();

    if (response.statusCode == 200) {
      Navigator.pop(context); // لإغلاق الـ dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Request Sent Successfully')),
      );
      Navigator.pushReplacementNamed(
          context, AppRoutes.homeScreen);

    } else {
      print("فشل الإرسال: ${response.statusCode}");
      Navigator.pop(context); // لإغلاق الـ dialog

    }
  }


  @override
  Widget build(BuildContext context) {
    final course = Constants.course;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.white
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text("Send Request",style: theme.textTheme.titleLarge!.copyWith(height: 1.60),),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                        color: Color(0xFFD7D7D7)
                    ),
                    children: [
                      TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Padding(
                            padding: EdgeInsets.all(8.h),
                            child: Text("Cash Price",style: theme.textTheme.bodyLarge!.copyWith(height: 1.60),),
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
                            child: Text("Installment Price",style: theme.textTheme.bodyLarge!.copyWith(height: 1.60),),
                          )
                      ),
                      TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Padding(
                            padding: EdgeInsets.all(8.h),
                            child: Text(Constants.course.installmentsPrice,style: theme.textTheme.bodyLarge!.copyWith(height: 1.60),),
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
            SizedBox(height: 16),

            Text("Select Payment Type:"),
            ListTile(
              title: const Text("Cash"),
              leading: Radio(
                value: 'cash',
                groupValue: paymentMethod,
                onChanged: (value) {
                  setState(() {
                    paymentMethod = value!;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text("Installment"),
              leading: Radio(
                value: 'installment',
                groupValue: paymentMethod,
                onChanged: (value) {
                  setState(() {
                    paymentMethod = value!;
                  });
                },
              ),
            ),

            SizedBox(height: 16),
            Text("Attach Payment Photo:"),
            SizedBox(height: 8),
            if (receiptImage != null)
              Image.file(receiptImage!, height: 150),
            CustomElevatedButton(
              text: "Select Image",
              leftIcon: Icon(Icons.upload_file),
              onPressed: pickImage,
            ),
            SizedBox(height: 16),
            Text("Payment Type:"),
            DropdownButtonFormField<PaymentType>(
              value: selectedPaymentType,
              items: paymentTypes.map((pt) {
                return DropdownMenuItem<PaymentType>(
                  value: pt,
                  child: Text(pt.type),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedPaymentType = value;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12),
              ),
            ),

            SizedBox(height: 16),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Paid Amount",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24),
            Center(
              child: CustomElevatedButton(
                onPressed: submitRequest,
                text: "Send Request",
              ),
            ),
          ],
        ),
      ),
    );
  }
}