import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:identity_preserving_dapp/screen/widgets/dialogs.dart';
import 'package:identity_preserving_dapp/screen/widgets/snack_bar.dart';
import 'package:identity_preserving_dapp/service/celo_id.dart';
import 'package:web3dart/web3dart.dart';

enum Status { init, loading, done }

final identityProvider = ChangeNotifierProvider((ref) => IdentityController());

class IdentityController extends ChangeNotifier {
  CeloPreservingIdentity celo = CeloPreservingIdentity();
  Status createStatus = Status.init;
  Status viewStatus = Status.init;
  List<String> addresses = [];

  Future<dynamic> saveIdentity(context, String address, String number) async {
    try {
      createStatus =
          createStatus != Status.loading ? Status.loading : Status.done;
      notifyListeners();
      if (createStatus == Status.done) return;
      String? response = await celo.addPhoneNumberAddress(number, address);
      if (response != null) {
        createStatus = Status.done;
        notifyListeners();
        alertDialogs(context, 'Save Identity',
            'Celo Identity successfuly saved.', () => Navigator.pop(context));
      } else {
        createStatus = Status.done;
        CustomSnackbar.responseSnackbar(
            context, Colors.redAccent, 'unable to create identity');
      }
      notifyListeners();
    } catch (e) {
      createStatus = Status.done;
      notifyListeners();
      CustomSnackbar.responseSnackbar(context, Colors.redAccent, e.toString());
      debugPrint(e.toString());
    }
  }

  Future<dynamic> fetchIdAccounts(String number, dynamic context) async {
    try {
      viewStatus = viewStatus != Status.loading ? Status.loading : Status.done;
      if (viewStatus == Status.done) return;
      notifyListeners();
      List response = await celo.lookupAccounts(number);
      if (response.isNotEmpty) {
        List<String> accounts = [];
        for (var address in response) {
          accounts.add(address.toString());
        }
        addresses = accounts;
        viewStatus = Status.done;
        notifyListeners();
        CustomSnackbar.responseSnackbar(
            context, Colors.green, 'Accounts successfully fetched');
      } else {
        viewStatus = Status.done;
        CustomSnackbar.responseSnackbar(
            context, Colors.redAccent, 'account not found with this identity');
      }
      notifyListeners();
    } catch (e) {
      print(e);
      viewStatus = Status.done;
      notifyListeners();
      CustomSnackbar.responseSnackbar(context, Colors.redAccent, e.toString());
    }
  }
}
