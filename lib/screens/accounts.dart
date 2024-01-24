import 'package:flutter/material.dart';
import 'package:flutter_testing/models/account.dart';
import 'package:flutter_testing/models/transaction.dart';
import 'package:flutter_testing/models/user.dart';
import 'package:provider/provider.dart';

class AccountsPage extends StatelessWidget {
  const AccountsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var userModel = context.watch<UserModel>();
    var accounts = userModel.accounts;

    var accountNameController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
    
          const AccountsDropdown(),
    
          TextField(
            controller: accountNameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Account name',
            ),
            onSubmitted: (String value) {
              userModel.addAccount(Account(value, <Transaction> []));

              if (accounts.length == 1) {
                userModel.selectAccount(0);
                debugPrint("Selected account: ${userModel.selectedAccount.name}");
              }

              accountNameController.clear();
            },
          ),
          
          Expanded(
            child: ListView.builder(
              itemCount: accounts.length,
              prototypeItem: const Text('Test'),
              itemBuilder: ((context, index) {
                return ListTile(
                  title: Text(accounts[index].name.toString())
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}


class AccountsDropdown extends StatefulWidget {
  const AccountsDropdown({super.key});

  @override
  State<AccountsDropdown> createState() => _AccountsDropdownState();
}

class _AccountsDropdownState extends State<AccountsDropdown> {
  String dropdownValue = "";
  
  @override
  Widget build(BuildContext context) {
    var userModel = context.watch<UserModel>();
    var accounts = userModel.accounts;

    var accountNames = accounts.map<String>((account) => account.name).toList();

    if (accounts.length == 1) {
      dropdownValue = accounts[0].name;
    }

    return DropdownButton<String>(
      value: dropdownValue.isEmpty ? null : dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      onChanged: (String? value) {
        setState(() {
          dropdownValue = value!;
          userModel.selectAccount(accountNames.indexOf(value));
          debugPrint("Selected account: ${userModel.selectedAccount.name}");
        });
      },
      items: accountNames.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(value),
          ),
        );
      }).toList(),
    );
  }
}