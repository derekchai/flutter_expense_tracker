// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_testing/models/category.dart';
import 'package:flutter_testing/models/transaction.dart';
import 'package:flutter_testing/models/user.dart';
import 'package:flutter_testing/screens/accounts.dart';
import 'package:flutter_testing/screens/dashboard.dart';
import 'package:flutter_testing/shared/styles.dart';
import 'package:flutter_testing/utils/add_space.dart';
import 'package:flutter_testing/utils/json_icon.dart';
import 'package:flutter_testing/utils/read_write.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text_field/auto_size_text_field.dart';

UserModel u = UserModel();

void main() async {

  u = await load();

  runApp(ChangeNotifierProvider(
    create: (context) => u,
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
    // var userModel = context.watch<UserModel>();
    // var selectedAccount = userModel.selectedAccount;

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
          appBar: AppBar(
            title: const Text("Expense Tracker"),
            actions: [
              IconButton(onPressed: () {save(u);} , icon: Icon(Icons.save)),
              AccountsDropdown(),
            ],
          ),
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
              _newTransactionDialog(context);
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

        TransactionCategory noCategory = TransactionCategory("Select category", Icons.menu.toString(), CategoryType.noCategory);

        TransactionCategory? selectedCategory = noCategory;

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
        
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          // ? Date button.
                          ElevatedButton(
                            onPressed: () {
                              _showDatePicker(setState);
                            }, 
                            child: Text(DateFormat('dd MMMM yyyy').format(dateTime!)),
                          ),

                          // ? Category button.
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                selectedCategory = await showDialog(
                                  context: context, 
                                  builder: (context) => ChooseCategoryDialog(userModel: userModel)
                                );
                            
                                if (selectedCategory == null) {
                                  debugPrint("No category was selected.");
                                  return;
                                }
                            
                                debugPrint("Selected category: ${selectedCategory!.name.toString()}");
                            
                                setState(() {});
                              }, 
                              label: Text(selectedCategory!.name),
                              icon: Icon((selectedCategory == noCategory) ? Icons.menu : iconMap[selectedCategory!.iconData], 
                                color: selectedCategory!.categoryType.color)
                            ),
                          ),
                        ],
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
                  if (amountController.text.isEmpty || selectedCategory == noCategory) {
                    Navigator.of(context).pop();
                    transactionNameController.clear();
                    amountController.clear();
                    return;
                  }
                  userModel.addTransaction( selectedAccount, 
                    Transaction(
                      transactionNameController.text, 
                      (selectedCategory!.categoryType == CategoryType.income) 
                        ? double.parse(amountController.text) 
                        : double.parse(amountController.text) * -1, 
                      selectedCategory!
                    )
                  );

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
}

class ChooseCategoryDialog extends StatelessWidget {
  const ChooseCategoryDialog({
    super.key,
    required this.userModel,
  });

  final UserModel userModel;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: const [
          Expanded(child: Text("Select category")),
          IconButton(onPressed: doNothing, icon: Icon(Icons.edit)),
          IconButton(onPressed: doNothing, icon: Icon(Icons.add)),
        ],
      ),
      content: SizedBox(
        width: 500, 
        height: 400, 
        child: GridView.builder(
          itemCount: userModel.categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
          itemBuilder: (context, index) {
            return Card(
              child: InkWell(
                onTap: () { Navigator.of(context).pop(userModel.categories[index]); },
                customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      iconMap[userModel.categories[index].iconData],
                      color: userModel.categories[index].categoryType.color,
                    ),
                    Text(userModel.categories[index].name),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class TransactionReturnedData {
  String description;
  double amount;
  TransactionCategory category;

  TransactionReturnedData(this.description, this.amount, this.category);
}





void doNothing() { }