// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_testing/models/transaction.dart';
import 'package:flutter_testing/models/user.dart';
import 'package:flutter_testing/screens/accounts.dart';
import 'package:flutter_testing/screens/dashboard.dart';
import 'package:flutter_testing/shared/styles.dart';
import 'package:flutter_testing/utils/add_space.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text_field/auto_size_text_field.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => UserModel(),
    child: const MyApp()
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      darkTheme: ThemeData.dark(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int navigationRailIndex = 0;

  var transactionNameController = TextEditingController();
  var amountController = TextEditingController();

  DateTime? dateTime = DateTime.now();

  _showDatePicker(setState) async {
    await showDatePicker(
      context: context,
      initialDate: dateTime,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    ).then((value) {
      setState(() {
        if (value != null) {
          dateTime = value;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    late Widget page;
    var userModel = context.watch<UserModel>();
    var selectedAccount = userModel.selectedAccount;

    switch (navigationRailIndex) {
      case 0: 
        page = DashboardPage();
        break;
      case 1:
        page = AccountsPage();
        break;
    }

    return LayoutBuilder(
      builder: (context, constraints) { 

        return Scaffold(
          body: Row(
            children: [
              SafeArea(
                child: NavigationRail(
                  extended: constraints.maxWidth >= 900,
                  selectedIndex: navigationRailIndex,
                  destinations: const [
                    NavigationRailDestination(icon: Icon(Icons.dashboard), label: Text('Dashboard')),
                    NavigationRailDestination(icon: Icon(Icons.attach_money), label: Text('Transactions')),
                  ],
                  onDestinationSelected: (value) {setState(() {
                    navigationRailIndex = value;
                  });},
                ),
              ),

              Expanded(child: page)
            ],
          ),

          // ? Floating action button.
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final data = await _newTransactionDialog(context);

              debugPrint(data);

              if (data == null) return;
              
              setState(() {
                selectedAccount.transactions.add(Transaction(data.description, data.amount, Icon(Icons.attach_money)));
              });
            },
            tooltip: "Add new transaction",
            child: Icon(Icons.add),
          ),
        );
      }
    );
  }

  _newTransactionDialog(BuildContext context) async {

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        var userModel = context.watch<UserModel>();
        var selectedAccount = userModel.selectedAccount;

        return StatefulBuilder(

          builder: (context, setState) => AlertDialog(
            
              // ? Title.
              title: const Text("Add transaction"),
              content: 
                  SizedBox(
                    width: 500,
                    height: 200,
                    child: Column(
                      children: [
            
                        // ? Amount field.
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('\$ ', style: signStyle,),
                            AutoSizeTextField(
                              fullwidth: false,
                              keyboardType: TextInputType.numberWithOptions(signed: false, decimal: true),
                              style: titleStyle,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                hintText: "0"
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                              ],
                              controller: amountController,
                              autofocus: true,
                            ),
                          ],
                        ),
            
                        // ? Transaction description field.
                        TextField(
                          decoration: InputDecoration(
                            hintText: "Description"
                          ),
                          controller: transactionNameController,
                        ),
                      
                        addVerticalSpace(15),
          
                        // ? Date button.
                        ElevatedButton(
                          onPressed: () {
                            _showDatePicker(setState);
                          }, 
                          child: Text(DateFormat('dd MMMM yyyy').format(dateTime!)),
                        ),

                        // ? Category button.
                        ElevatedButton(
                          onPressed: () {
                            _chooseCategoryDialog(context);
                          }, 
                          child: Text("Select category")
                        ),
                      ],
                    ),
                  ),
              actions: [
            
                // ? Cancel button.
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    transactionNameController.clear();
                    amountController.clear();
                  }, 
                  child: Text("Cancel")
                ),
            
                // ? Add button.
                TextButton(
                  onPressed: () {
                    userModel.addTransaction(selectedAccount, Transaction(transactionNameController.text, double.parse(amountController.text), Icon(Icons.attach_money)));

                    Navigator.of(context).pop();
                    transactionNameController.clear();
                    amountController.clear();
                  }, 
                  child: Text("Add")
                )
              ]
            ),
        );
      }
    );
  }

  _chooseCategoryDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        var userModel = context.watch<UserModel>();

        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: Text("Select category"),
            content: SizedBox(
              width: 500, 
              height: 400, 
              child: GridView.builder(
                itemCount: userModel.categories.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
                itemBuilder: (context, index) {
                  return Card(
                    child: InkWell(
                      onTap: () {doNothing();},
                      customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          userModel.categories[index].icon,
                          Text(userModel.categories[index].name),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          )
        );
      }
    );
  }


}

class TransactionReturnedData {
  String description;
  double amount;

  TransactionReturnedData(this.description, this.amount);
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


void doNothing() { }