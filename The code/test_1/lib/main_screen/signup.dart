import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_1/components/custombuttonauth.dart';
import 'package:test_1/components/customlogoauth.dart';
import 'package:test_1/components/textformfield.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                "images/Login_Page_Background.png"), // Replace with your image path
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: ListView(children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(height: 50),
              const CustomLogoAuth(),
              Container(height: 20),
              Text(
                'التسجيل',
                style: GoogleFonts.tajawal(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(height: 20),
              Text(
                'اسم المستخدم',
                style: GoogleFonts.tajawal(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(height: 10),
              CustomTextForm(
                hinttext: "ادخل اسم المستخدم",
                mycontroller: username,
              ),
              Container(height: 20),
              Text(
                "البريد الالكتروني",
                style: GoogleFonts.tajawal(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(height: 10),
              CustomTextForm(
                  hinttext: "ادخل بريدك الالكتروني", mycontroller: email),
              Container(height: 20),
              Text(
                "كلمة السر",
                style: GoogleFonts.tajawal(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(height: 10),
              CustomTextForm(
                  hinttext: "ادخل كلمة السر", mycontroller: password),
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 20),
                alignment: Alignment.topRight,
              ),
            ],
          ),
          CustomButtonAuth(
              title: "تسجيل",
              onPressed: () async {
                try {
                  final credential = await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                    email: email.text,
                    password: password.text,
                  );
                  final snackBar = SnackBar(
                    /// need to set following properties for best effect of awesome_snackbar_content
                    elevation: 0,
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.transparent,
                    content: AwesomeSnackbarContent(
                      title: 'تم التسجيل بنجاح',
                      message: '',
                      contentType: ContentType.success,
                    ),
                  );

                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(snackBar);
                  Navigator.of(context).pushReplacementNamed("login");
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'weak-password') {
                    print('The password provided is too weak.');
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.error,
                      animType: AnimType.rightSlide,
                      title: 'خطأ',
                      desc: 'كلمة السر ضعيفة جدًا',
                    ).show();
                  } else if (e.code == 'email-already-in-use') {
                    print('The account already exists for that email.');
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.error,
                      animType: AnimType.rightSlide,
                      title: 'خطأ',
                      desc: 'يوجد حساب بالفعل لهذا البريد الإلكتروني',
                    ).show();
                  }
                } catch (e) {
                  print(e);
                }
              }),

          Container(height: 20),
          // Text("Don't Have An Account ? Resister" , textAlign: TextAlign.center,)
          InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Center(
              child: Text.rich(TextSpan(children: [
                TextSpan(
                  text: "عندك حساب بالفعل؟ ",
                  style: GoogleFonts.tajawal(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: "سجل الدخول",
                  style: GoogleFonts.tajawal(
                    color: Colors.blue,
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ])),
            ),
          )
        ]),
      ),
    );
  }
}
