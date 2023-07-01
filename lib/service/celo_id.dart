import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

var apiUrl = dotenv.env['CELO_RPC_URL'];
final client = Web3Client(apiUrl ?? "", Client());

class CeloPreservingIdentity {
  EthPrivateKey get credentials {
    var credentials =
        EthPrivateKey.fromHex(dotenv.env['CELO_PRIVATE_KEY'] ?? "");
    // var address = credentials.address;
    return credentials;
  }

  /// Get deployed Accounts contract
  Future<DeployedContract> get deployedAccountContract async {
    const String abiDirectory = 'lib/service/contract.abi.json';
    String contractABI = await rootBundle.loadString(abiDirectory);

    final DeployedContract contract = DeployedContract(
      ContractAbi.fromJson(contractABI, 'Accounts'),
      EthereumAddress.fromHex(dotenv.env['CONTRACT_ADDRESS'] ?? ""),
    );

    return contract;
  }

  Future addPhoneNumberAddress(String phoneNumber, String address) async {
    // final client = Web3Client(apiUrl ?? "", Client());

    final contract = await deployedAccountContract;

    // Hash the phone number
    var phoneNumberHash =
        keccak256(Uint8List.fromList(phoneNumber.codeUnits)).toString();

    print("phone number ===>> $phoneNumberHash");

    // Get the addAddress function from the contract
    final addAddressFunction = contract.function('addAddress');

    // Call the addAddress function
    final response = await client.sendTransaction(
        credentials,
        Transaction.callContract(
          contract: contract,
          function: addAddressFunction,
          parameters: [phoneNumberHash, EthereumAddress.fromHex(address)],
        ),
        chainId: 44787);

    final dynamic receipt = await awaitResponse(response);
    return receipt;
  }

  Future<List<dynamic>> lookupAccounts(String phoneNumber) async {
    // Hash the phone number
    var phoneNumberHash =
        keccak256(Uint8List.fromList(phoneNumber.codeUnits)).toString();

    // Get the Accounts contract
    var accountsContract = await deployedAccountContract;

    // Get the lookupAccounts function
    var lookupAccountsFunction = accountsContract.function('lookupAccounts');

    // Call the function
    var result = await client.call(
      contract: accountsContract,
      function: lookupAccountsFunction,
      params: [phoneNumberHash],
    );

    // Parse the result
    print("result ===>> ${result[0]}");
    List addresses = result[0];

    return addresses;
  }

  Future<dynamic> awaitResponse(dynamic response) async {
    int count = 0;
    while (true) {
      final TransactionReceipt? receipt =
          await client.getTransactionReceipt(response);
      if (receipt != null) {
        print('receipt ===>> $receipt');
        return receipt.logs[0].data;
      }
      // Wait for a while before polling again
      await Future<dynamic>.delayed(const Duration(seconds: 1));
      if (count == 6) {
        return null;
      } else {
        count++;
      }
    }
  }
}
