import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:identity_preserving_dapp/controller/identity_controller.dart';
import 'package:identity_preserving_dapp/screen/widgets/celo_button.dart';
import 'package:identity_preserving_dapp/screen/widgets/celo_pop.dart';
import 'package:identity_preserving_dapp/screen/widgets/snack_bar.dart';

class SaveUserIdentity extends ConsumerStatefulWidget {
  const SaveUserIdentity({super.key});

  @override
  ConsumerState<SaveUserIdentity> createState() => _SaveUserIdentityState();
}

class _SaveUserIdentityState extends ConsumerState<SaveUserIdentity> {
  TextEditingController walletController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
              left: size.width * 0.04, right: size.width * 0.04, top: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: <Widget>[
                  Image.asset('assets/images/logo.png', height: 80, width: 120),
                  const SizedBox(width: 10),
                  const Text(
                    'IDENTITY ',
                    maxLines: 2,
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        color: Colors.black54),
                  )
                ],
              ),
              const SizedBox(height: 20),
              Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'Enter your details to save a identity on this app.',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
                    ),
                    const SizedBox(height: 30),
                    CustomTextField(
                      text: 'Wallet Address',
                      controller: walletController,
                      hint: 'enter your wallet address',
                    ),
                    const SizedBox(height: 15),
                    CustomTextField(
                      text: 'Phone number',
                      controller: numberController,
                      hint: 'enter your Mobile number',
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              CustomButtonWidget(
                text: ref.watch(identityProvider).createStatus == Status.loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Save Account',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                onPressed: () async {
                  if (walletController.text.trim().isEmpty ||
                      numberController.text.trim().isEmpty) {
                    CustomSnackbar.responseSnackbar(context, Colors.redAccent,
                        'Fill the required fields..');
                    return;
                  }
                  await ref.read(identityProvider).saveIdentity(
                      context,
                      walletController.text.trim(),
                      numberController.text.trim());
                },
              ),
            ],
          ),
        ),
      )),
    );
  }
}
