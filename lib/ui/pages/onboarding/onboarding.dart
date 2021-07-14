import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labalaba/colors.dart';
import 'package:labalaba/states_management/onboarding/onboarding_cubit.dart';
import 'package:labalaba/states_management/onboarding/onboarding_state.dart';
import 'package:labalaba/states_management/onboarding/profile_image_cubit.dart';
import 'package:labalaba/ui/pages/onboarding/onboarding_router.dart';
import 'package:labalaba/ui/widgets/onboarding/logo.dart';
import 'package:labalaba/ui/widgets/onboarding/profile_upload.dart';
import 'package:labalaba/ui/widgets/shared/custom_text_field.dart';

class Onboarding extends StatefulWidget {
  final IOnboardingRouter router;
  const Onboarding(this.router);

  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  String _username = '';
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
                onchanged: (val) {
                  _username = val;
                },
                inputAction: TextInputAction.done,
              ),
            ),
            SizedBox(height: 30.0),
            Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              child: ElevatedButton(
                onPressed: () async {
                  final error = _checkInputs();
                  if (error.isNotEmpty) {
                    final snackBar = SnackBar(
                      content: Text(
                        error,
                        style: TextStyle(
                            fontSize: 14.0, fontWeight: FontWeight.bold),
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    return;
                  }

                  await _connectSession();
                },
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
            Spacer(),
            BlocConsumer<OnboardingCubit, OnboardingState>(
              builder: (context, state) => state is Loading
                  ? Center(child: CircularProgressIndicator())
                  : Container(),
              listener: (_, state) {
                if (state is OnboardingSuccess)
                  widget.router.onSessionSuccess(context, state.user);
              },
            ),
            Spacer(flex: 1)
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

  _connectSession() async {
    final profileImage = context.read<ProfileImageCubit>().state;
    await context.read<OnboardingCubit>().connect(_username, profileImage);
  }

  String _checkInputs() {
    var error = '';
    if (_username.isEmpty) error = 'Enter display name';
    if (context.read<ProfileImageCubit>().state == null)
      error = error + '\n' + 'Upload profile image';

    return error;
  }
}
