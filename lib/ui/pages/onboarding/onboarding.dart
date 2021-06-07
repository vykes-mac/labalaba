import 'package:flutter/material.dart';
import 'package:labalaba/colors.dart';
import 'package:labalaba/ui/widgets/onboarding/logo.dart';
import 'package:labalaba/ui/widgets/onboarding/profile_upload.dart';
import 'package:labalaba/ui/widgets/shared/custom_text_field.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({Key key}) : super(key: key);

  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            _logo(context),
            Spacer(),
            ProfileUpload(),
            Spacer(flex: 1),
            Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              child: CustomTextField(
                hint: 'wah yuh name?',
                height: 45.0,
                onchanged: (val) {},
                inputAction: TextInputAction.done,
              ),
            ),
            SizedBox(height: 30.0),
            Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              child: ElevatedButton(
                onPressed: () {},
                child: Container(
                  height: 45.0,
                  alignment: Alignment.center,
                  child: Text(
                    'Mek wi chat!',
                    style: Theme.of(context).textTheme.button.copyWith(
                          fontSize: 18.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: kPrimary,
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(45.0),
                  ),
                ),
              ),
            ),
            Spacer(flex: 2)
          ]),
        ),
      ),
    );
  }

  _logo(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Laba',
          style: Theme.of(context)
              .textTheme
              .headline4
              .copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(width: 8.0),
        Logo(),
        SizedBox(width: 8.0),
        Text(
          'Laba',
          style: Theme.of(context)
              .textTheme
              .headline4
              .copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
