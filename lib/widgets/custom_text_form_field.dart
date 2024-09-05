

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nile_training/core/app_export.dart';

class CustomTextFormField extends StatelessWidget{

  CustomTextFormField({
    Key? key,
    this.alignment,
    this.width,
    this.boxDecoration,
    this.scrollPadding,
    this.controller,
    this.focusNode,
    this.autoFocus = false,
    this.textStyle,
    this.obscureText = false,
    this.readonly = false,
    this.onTap,
    this.textInputAction = TextInputAction.next,
    this.textInputType = TextInputType.text,
    this.maxLines,
    this.hintText,
    this.hintStyle,
    this.prefix,
    this.prfixConstrains,
    this.suffix,
    this.succcexConstrains,
    this.contentPadding,
    this.borderDecoration,
    this.fillColor,
    this.filled = false,
    this.validator,
    this.obscuringCharacter
}): super(
    key: key
  );

  final Alignment? alignment;
  final double? width;
  final BoxDecoration? boxDecoration;
  final TextEditingController? scrollPadding;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool? autoFocus;
  final TextStyle? textStyle;
  final bool? obscureText;
  final bool? readonly;
  final VoidCallback? onTap;
  final TextInputAction? textInputAction;
  final TextInputType? textInputType;
  final int? maxLines;
  final String? hintText;
  final TextStyle? hintStyle;
  final Widget? prefix;
  final Widget? suffix;
  final BoxConstraints? prfixConstrains;
  final BoxConstraints? succcexConstrains;
  final EdgeInsets? contentPadding;
  final InputBorder? borderDecoration;
  final Color? fillColor;
  final bool? filled;
  final FormFieldValidator<String>? validator;
  final String? obscuringCharacter;





  @override
  Widget build(BuildContext context) {
    // TODO: implement build
     return  (
         obscuringCharacter != null ? passwordFormFieldWidget(context) : textFormFieldWidget(context)
     );

  }


  Widget textFormFieldWidget (BuildContext context) => Container(
    width: width ?? double.maxFinite,
    decoration: boxDecoration,
       child: TextFormField(
         scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
         controller: controller,
         focusNode: focusNode,
         onTapOutside: (event){
           if(focusNode != null){
             focusNode?.unfocus();
           }else{
             FocusManager.instance.primaryFocus?.unfocus();
           }
         },
         autofocus: autoFocus!,
         style: textStyle,
         obscureText: obscureText!,
         readOnly: readonly!,
         onTap: (){
           onTap?.call();
         },
         textInputAction: textInputAction,
         keyboardType: textInputType,
         maxLines: maxLines ?? 1,
         decoration: decoration,
         validator: validator,

       ),
  );

  Widget passwordFormFieldWidget (BuildContext context) => Container(
    width: width ?? double.maxFinite,
    decoration: boxDecoration,
    child: TextFormField(
      scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      controller: controller,
      focusNode: focusNode,
      onTapOutside: (event){
        if(focusNode != null){
          focusNode?.unfocus();
        }else{
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      autofocus: autoFocus!,
      style: textStyle,
      obscureText: obscureText!,
      obscuringCharacter: obscuringCharacter ?? '',
      readOnly: readonly!,
      onTap: (){
        onTap?.call();
      },
      textInputAction: textInputAction,
      keyboardType: textInputType,
      maxLines: maxLines ?? 1,
      decoration: decoration,
      validator: validator,

    ),
  );


  InputDecoration get decoration => InputDecoration(
    hintText: hintText?? "",
    hintStyle: hintStyle,
    prefixIcon: prefix,
    prefixIconConstraints: prfixConstrains,
    suffixIcon: suffix,
    suffixIconConstraints: succcexConstrains,
    isDense: true,
    contentPadding: contentPadding ?? EdgeInsets.all(10.h),
    fillColor: fillColor,
    filled: filled,
    border: borderDecoration?? OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.h),
      borderSide: BorderSide(
        color: appTheme.whiteA700,
        width: 1
      )

    ),
    enabledBorder: borderDecoration?? OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.h),
        borderSide: BorderSide(
            color: appTheme.whiteA700,
            width: 1
        )

    ),
    focusedBorder: borderDecoration??
        OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.h)
    ).copyWith(
      borderSide: BorderSide(
        color: theme.colorScheme.primary,
        width: 1
      )
    ),


  );

}