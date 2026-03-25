// Poppins Thin – 100
//
// Poppins ExtraLight – 200
//
// Poppins Light – 300
//
// Poppins Regular – 400
//
// Poppins Medium – 500
//
// Poppins SemiBold – 600
//
// Poppins Bold – 700
//
// Poppins ExtraBold – 800
//
// Poppins Black – 900


import 'package:car_rental_customerPanel/Resources/AppTextSizes.dart';
import 'package:car_rental_customerPanel/Resources/Color.dart';
import 'package:flutter/material.dart';


class TTextTheme {
    /// universal texts
  static TextStyle loginButtonText(BuildContext context){
    return _textStyle(fontSize:AppTextSizes.size(context, 16, 16, 16),fontWeight: FontWeight.w500,color: Colors.white);
  }
  static TextStyle btnTwo(BuildContext context){
    return _textStyle(fontSize:AppTextSizes.size(context, 11, 12, 12),fontWeight: FontWeight.w400,color: AppColors.secondTextColor);
  }
  static TextStyle titleThree(BuildContext context){
    return _textStyle(fontSize:AppTextSizes.size(context, 12, 12, 12),fontWeight: FontWeight.w400,color: AppColors.tertiaryTextColor,
    );
  }

  static TextStyle loginInsideTextField(BuildContext context){
    return _textStyle(fontSize:AppTextSizes.size(context, 12, 14, 16),fontWeight: FontWeight.w400,color: AppColors.textColor,
    );
  }

  static TextStyle dropdowninsideText(BuildContext context){
    return _textStyle(fontSize:AppTextSizes.size(context, 12, 12, 12),fontWeight: FontWeight.w500,color: AppColors.blackColor);
  }

  static TextStyle pSeven(BuildContext context){
    return _textStyle(fontSize:AppTextSizes.size(context, 13, 15, 16),fontWeight: FontWeight.w400,color: AppColors.tertiaryTextColor,
    );
  }
      /// Headings
  static TextStyle h1Style(BuildContext context){
    return _textStyle(fontSize:AppTextSizes.size(context, 22, 24, 24),fontWeight: FontWeight.w700,color: AppColors.textColor);
  }

  static TextStyle h1StylePrimary(BuildContext context){
    return _textStyle(fontSize:AppTextSizes.size(context, 22, 24, 24),fontWeight: FontWeight.w700,color: AppColors.primaryColor);
  }

  static TextStyle h2Style(BuildContext context){
    return _textStyle(fontSize:AppTextSizes.size(context, 20, 20, 20),fontWeight: FontWeight.w600,color: AppColors.textColor);
  }

  static TextStyle h3Style(BuildContext context){
    return _textStyle(fontSize:AppTextSizes.size(context, 32, 40, 40),fontWeight: FontWeight.w600,color: AppColors.textColor);
  }

  static TextStyle h2PrimaryStyle(BuildContext context){
    return _textStyle(fontSize:AppTextSizes.size(context, 20, 20, 20),fontWeight: FontWeight.w600,color: AppColors.primaryColor);
  }

  static TextStyle h2MediumStyle(BuildContext context){
    return _textStyle(fontSize:AppTextSizes.size(context, 20, 20, 20),fontWeight: FontWeight.w500,color: AppColors.textColor);
  }

  static TextStyle logoStyle(BuildContext context){
    return _textStyle(fontSize:AppTextSizes.size(context, 22, 24, 24),fontWeight: FontWeight.w500,color: AppColors.textColor);
  }
       /// Body Paragraphs
  static TextStyle bodyRegular10(BuildContext context){
    return _textStyle(fontSize:AppTextSizes.size(context, 16, 17.5, 17.5),fontWeight: FontWeight.w400,color: AppColors.tertiaryTextColor);
  }

  static TextStyle bodySecondRegular10(BuildContext context){
    return _textStyle(fontSize:AppTextSizes.size(context, 10, 10, 10),fontWeight: FontWeight.w400,color: AppColors.tertiaryTextColor);
  }

  static TextStyle bodyRegular12(BuildContext context){
    return _textStyle(fontSize:AppTextSizes.size(context, 12, 12, 12),fontWeight: FontWeight.w400,color: AppColors.tertiaryTextColor);
  }

  static TextStyle bodyRegular12black(BuildContext context){
    return _textStyle(fontSize:AppTextSizes.size(context, 12, 12, 12),fontWeight: FontWeight.w400,color: AppColors.blackColor);
  }

  static TextStyle bodyRegular12Primary(BuildContext context){
    return _textStyle(fontSize:AppTextSizes.size(context, 12, 12, 12),fontWeight: FontWeight.w400,color: AppColors.primaryColor);
  }

  static TextStyle bodyRegular14(BuildContext context){
    return _textStyle(fontSize:AppTextSizes.size(context, 14, 14, 14),fontWeight: FontWeight.w400,color: AppColors.secondTextColor);
  }

  static TextStyle bodyRegular14tertiary(BuildContext context){
    return _textStyle(fontSize:AppTextSizes.size(context, 14, 14, 14),fontWeight: FontWeight.w400,color: AppColors.tertiaryTextColor);
  }

  static TextStyle bodyRegular16(BuildContext context){
    return _textStyle(fontSize:AppTextSizes.size(context, 16, 16, 16),fontWeight: FontWeight.w400,color: AppColors.tertiaryTextColor);
  }

  static TextStyle bodyRegular16secondary(BuildContext context){
    return _textStyle(fontSize:AppTextSizes.size(context, 16, 16, 16),fontWeight: FontWeight.w400,color: AppColors.secondTextColor);
  }

  static TextStyle bodyRegular16Primary(BuildContext context){
    return _textStyle(fontSize:AppTextSizes.size(context, 16, 16, 16),fontWeight: FontWeight.w400,color: AppColors.primaryColor);
  }

  static TextStyle bodyRegular16black(BuildContext context){
    return _textStyle(fontSize:AppTextSizes.size(context, 16, 16, 16),fontWeight: FontWeight.w400,color: AppColors.blackColor);
  }

  static TextStyle bodySemiBold12(BuildContext context){
    return _textStyle(fontSize:AppTextSizes.size(context, 12, 12, 12),fontWeight: FontWeight.w600,color: AppColors.textColor);
  }

  static TextStyle bodySemiBold14(BuildContext context){
    return _textStyle(fontSize:AppTextSizes.size(context, 14, 14, 14),fontWeight: FontWeight.w600,color: AppColors.tertiaryTextColor);
  }

  static TextStyle bodySemiBold14White(BuildContext context){
    return _textStyle(fontSize:AppTextSizes.size(context, 14, 14, 14),fontWeight: FontWeight.w600,color: AppColors.whiteColor);
  }

  static TextStyle bodySemiBold14black(BuildContext context){
    return _textStyle(fontSize:AppTextSizes.size(context, 14, 14, 14),fontWeight: FontWeight.w600,color: AppColors.blackColor);
  }

  static TextStyle bodySemiBold16(BuildContext context){
    return _textStyle(fontSize:AppTextSizes.size(context, 16, 16, 16),fontWeight: FontWeight.w600,color: AppColors.primaryColor);
  }

  static TextStyle medium12(BuildContext context){
    return _textStyle(fontSize:AppTextSizes.size(context, 12, 12, 12),fontWeight: FontWeight.w500,color: AppColors.textColor);
  }

  static TextStyle medium12White(BuildContext context){
    return _textStyle(fontSize:AppTextSizes.size(context, 12, 12, 12),fontWeight: FontWeight.w500,color: AppColors.whiteColor);
  }

  static TextStyle medium14(BuildContext context){
    return _textStyle(fontSize:AppTextSizes.size(context, 14, 14, 14),fontWeight: FontWeight.w500,color: AppColors.secondTextColor);
  }

  static TextStyle medium14tableHeading(BuildContext context){
    return _textStyle(fontSize:AppTextSizes.size(context, 14, 14, 14),fontWeight: FontWeight.w500,color: AppColors.tableHeading);
  }

  static TextStyle medium14White(BuildContext context){
    return _textStyle(fontSize:AppTextSizes.size(context, 14, 14, 14),fontWeight: FontWeight.w500,color: AppColors.whiteColor);
  }

  static TextStyle medium14black(BuildContext context){
    return _textStyle(fontSize:AppTextSizes.size(context, 14, 14, 14),fontWeight: FontWeight.w500,color: AppColors.textColor);
  }

  static TextStyle medium14tertiaryColor(BuildContext context){
    return _textStyle(fontSize:AppTextSizes.size(context, 14, 14, 14),fontWeight: FontWeight.w500,color: AppColors.tertiaryTextColor);
  }

          /// table

  static TextStyle tableRegular14(BuildContext context){
    return _textStyle(fontSize:AppTextSizes.size(context, 14, 14, 14),fontWeight: FontWeight.w400,color: AppColors.tertiaryTextColor);
  }


  static TextStyle tableRegular14black(BuildContext context){
    return _textStyle(fontSize:AppTextSizes.size(context, 14, 14, 14),fontWeight: FontWeight.w400,color: AppColors.blackColor);
  }

  static TextStyle tableRegular14Primary(BuildContext context){
    return _textStyle(fontSize:AppTextSizes.size(context, 14, 14, 14),fontWeight: FontWeight.w400,color: AppColors.primaryColor);
  }

  static TextStyle tableMedium14(BuildContext context){
    return _textStyle(fontSize:AppTextSizes.size(context, 14, 14, 14),fontWeight: FontWeight.w500,color: AppColors.tableHeading);
  }

  static TextStyle tableSemiBold14(BuildContext context){
    return _textStyle(fontSize:AppTextSizes.size(context, 14, 14, 14),fontWeight: FontWeight.w600,color: AppColors.whiteColor);
  }





  /// Main Functions
  static TextStyle _textStyle (
      {
        double fontSize = 12,
        required FontWeight fontWeight ,
        Color ? color,
      })  {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }
}