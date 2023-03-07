import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String cCode = "852";
  String pNum = "";
  bool match = false;
  TextEditingController _vCodeController = new TextEditingController();
  Timer? _timer;
  int _countdownTime = 0;
  int countClick = 0;
  TextEditingController _pwdController = new TextEditingController();
  bool pwdShow = false;
  bool _pwdAutoFocus = true;
  bool _pwd2AutoFocus = true;
  TextEditingController _pwdController2 = new TextEditingController();
  bool pwdShow2 = false;
  String? returnuserid = "";

  void initState() {
    super.initState();
  }

  void startCountdownTimer() {
    const oneSec = const Duration(seconds: 1);

    var callback = (timer) => {
          setState(() {
            if (_countdownTime < 1) {
              _timer!.cancel();
            } else {
              _countdownTime = _countdownTime - 1;
            }
          })
        };
    _timer = Timer.periodic(oneSec, callback);
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer!.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Stack(
        overflow: Overflow.visible,
        children: [
          Scaffold(
            appBar: AppBar(
              elevation: 0,
              brightness: Brightness.light,
              backgroundColor: Colors.white,
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    size: 20,
                    color: Colors.black,
                  )),
            ),
            resizeToAvoidBottomInset: false,
            body: SafeArea(
              child: SingleChildScrollView(
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.7,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const SizedBox(height: 50),
                            IntlPhoneField(
                              decoration: const InputDecoration(
                                labelText: 'Phone Number',
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(),
                                ),
                              ),
                              onChanged: (phone) {
                                if (phone.number.length ==
                                    countries
                                        .firstWhere((element) =>
                                            element.code ==
                                            phone.countryISOCode)
                                        .maxLength) {
                                  pNum = phone.number.toString();
                                  match = true;
                                  setState(() {});
                                } else {
                                  match = false;
                                  setState(() {});
                                }
                              },
                              onCountryChanged: (country) {
                                cCode = country.dialCode;
                                setState(() {});
                              },
                            ),

                            // Verification code
                            Flex(
                              direction: Axis.horizontal,
                              children: <Widget>[
                                Expanded(
                                  flex: 2,
                                  child: TextFormField(
                                    controller: _vCodeController,
                                    decoration: const InputDecoration(
                                        hintText: "verificationCode"),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 25),
                                    child: ConstrainedBox(
                                      constraints: const BoxConstraints.expand(
                                          height: 40.0),
                                      child: RaisedButton(
                                        color:
                                            match == true && _countdownTime == 0
                                                ? Colors.blue
                                                : Colors.grey[350],
                                        onPressed: () async {},
                                        textColor: Colors.white,
                                        child: Text(countClick == 0
                                            ? "getVerificationCode"
                                            : _countdownTime > 0
                                                ? '${_countdownTime}s'
                                                : "register"),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 10),

                            TextFormField(
                              controller: _pwdController,
                              autofocus: !_pwdAutoFocus,
                              decoration: InputDecoration(
                                hintText: "password",
                                suffixIcon: IconButton(
                                  icon: Icon(pwdShow
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                  onPressed: () {
                                    setState(() {
                                      pwdShow = !pwdShow;
                                    });
                                  },
                                ),
                              ),
                              obscureText: !pwdShow,
                            ),

                            SizedBox(height: 10),

                            TextFormField(
                              controller: _pwdController2,
                              autofocus: !_pwd2AutoFocus,
                              decoration: InputDecoration(
                                hintText: "password",
                                suffixIcon: IconButton(
                                  icon: Icon(pwdShow2
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                  onPressed: () {
                                    setState(() {
                                      pwdShow2 = !pwdShow2;
                                    });
                                  },
                                ),
                              ),
                              obscureText: !pwdShow2,
                            ),

                            // Continue button
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: ConstrainedBox(
                                constraints:
                                    BoxConstraints.expand(height: 40.0),
                                child: RaisedButton(
                                  color: _vCodeController.text == "" ||
                                          pNum == "" ||
                                          match == false
                                      ? Colors.grey
                                      : Colors.blue,
                                  onPressed: () async {
                                    RegExp regex = RegExp(
                                        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,16}$');
                                    if (_pwdController.text == "" ||
                                        _pwdController2.text == "" ||
                                        _vCodeController.text == "") {
                                      showCupertinoDialog(
                                        context: context,
                                        barrierDismissible: true,
                                        builder: (context) {
                                          return CupertinoAlertDialog(
                                            title: Text(
                                              "pleaseEnterEachColumn",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          );
                                        },
                                      );
                                    } else if (!regex
                                        .hasMatch(_pwdController.text)) {
                                      showCupertinoDialog(
                                        context: context,
                                        barrierDismissible: true,
                                        builder: (context) {
                                          return CupertinoAlertDialog(
                                            title: Text(
                                              "pleaseEnterSixDigitPassword",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            content: Text(
                                              "shouldContainRequirements",
                                              textAlign: TextAlign.center,
                                            ),
                                          );
                                        },
                                      );
                                    } else if (!regex
                                        .hasMatch(_pwdController2.text)) {
                                      showCupertinoDialog(
                                        context: context,
                                        barrierDismissible: true,
                                        builder: (context) {
                                          return CupertinoAlertDialog(
                                            title: Text(
                                              "pleaseEnterSixDigitPassword",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            content: Text(
                                              "shouldContainRequirements",
                                              textAlign: TextAlign.center,
                                            ),
                                          );
                                        },
                                      );
                                    } else if (_pwdController.text !=
                                        _pwdController2.text) {
                                      showCupertinoDialog(
                                        context: context,
                                        barrierDismissible: true,
                                        builder: (context) {
                                          return CupertinoAlertDialog(
                                            title: Text(
                                              "Please Enter Same Password",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          );
                                        },
                                      );
                                    } else {}
                                  },
                                  textColor: Colors.white,
                                  child: const Text("Reset Password"),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
