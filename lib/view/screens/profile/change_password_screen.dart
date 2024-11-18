

import 'package:edupot/core/constants/colors.dart';
import 'package:edupot/core/constants/constants.dart';
import 'package:edupot/view/widgets/custom_appbar.dart';
import 'package:edupot/view/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../enquiry_form/enquiry_form.dart';


class ChangePassWordScreen extends StatelessWidget {
  ChangePassWordScreen({super.key});
 final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColorlightgrey,
      appBar:  CustomAppBar(title: 'Change Password'),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            kHeight40,
         CustomTextField(label: 'Old Password', icon: Icons.lock, onSaved: (Value){}),
            kHeight10,
          
               CustomTextField(label: 'New Password', icon: Icons.lock_clock_outlined, onSaved: (Value){}),
            kHeight10,   CustomTextField(label: 'ReEnter Password', icon: Icons.gpp_good, onSaved: (Value){}),
            kHeight10,
            PrimaryButton( onPressed: (){}, text: 'Submit',)
          ],
        ),
      ),
    );
  }
}