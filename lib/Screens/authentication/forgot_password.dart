import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:weargalaxy/consts/weargalaxy_validator.dart';
import 'package:weargalaxy/services/assets_manager.dart';
import 'package:weargalaxy/widgets/subtitles_text.dart';
import 'package:weargalaxy/widgets/titles_text.dart';


class ForgotPasswordScreen extends StatefulWidget {
  static const routeName = '/ForgotPasswordScreen';
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late final TextEditingController _emailController;
  late final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _emailController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    if (mounted) {
      _emailController.dispose();
    }
    super.dispose();
  }

  Future<void> _forgetPassFCT() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      // Perform the forgot password action
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  const SizedBox(height: 10.0),
                  Image.asset(
                    AssetsManager.wgb,
                    height: 120,
                  ),
                  const SizedBox(height: 10.0),
                  const Align(
                    alignment: Alignment.center,
                    child: TitleTextWidget(
                      label: 'Forgot password',
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  const SubtitleTextWidget(
                    label:
                        'Please enter the email address you\'d like your password reset information sent to',
                    fontSize: 14,
                  ),
                  const SizedBox(height: 40.0),
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _emailController,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: 'youremail@email.com',
                              prefixIcon: Container(
                                padding: const EdgeInsets.all(12),
                                child: const Icon(IconlyLight.message),
                              ),
                              filled: true,
                            ),
                            validator: (value) {
                              return MyValidators.emailValidator(value);
                            },
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  SizedBox(
                    width: 370,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: const Icon(IconlyBold.send),
                      label: const Text(
                        "Request link",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      onPressed: () async {
                        _forgetPassFCT();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
