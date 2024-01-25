// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_testing/models/category.dart';
import 'package:flutter_testing/models/user.dart';
import 'package:flutter_testing/screens/dashboard.dart';
import 'package:flutter_testing/utils/add_space.dart';
import 'package:flutter_testing/utils/json_icon.dart';
import 'package:flutter_testing/utils/styles.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: 800,
          child: Text("Manage transactions", style: headerStyle),
        ),

        addVerticalSpace(10),

        TransactionsListView(heightFactor: 1)
      ],
    );
  }
}

class TransactionsListView extends StatefulWidget {
  final double heightFactor;

  const TransactionsListView({
    super.key,
    required this.heightFactor
  });

  @override
  State<TransactionsListView> createState() => _TransactionsListViewState();
}

class _TransactionsListViewState extends State<TransactionsListView> {
  @override
  Widget build(BuildContext context) {
    var userModel = context.watch<UserModel>();
    var selectedAccount = userModel.selectedAccount;
    
    return Expanded(
      child: SizedBox(
        width: 800,
        child: FractionallySizedBox(
          heightFactor: widget.heightFactor,
          alignment: Alignment.topCenter,
          child: ListView.builder(
            itemCount: selectedAccount.transactions.isEmpty ? 0 : selectedAccount.transactions.length,
            itemExtent: 80,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                child: Center(
                  child: ListTile(
                    leading: Icon(
                      iconMap[selectedAccount.transactions[index].category.iconData],
                      color: selectedAccount.transactions[index].category.categoryType.color
                    ),
                    title: Expanded(
                      child: Text(selectedAccount.transactions[index].description.toString())
                    ),
                    subtitle: Text(DateFormat('dd MMMM yyyy').format(selectedAccount.transactions[index].date)),
                    trailing: SizedBox(
                      width: 200,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(formatAsCurrency(selectedAccount.transactions[index].amount), style: subtitleStyleSz18),
                          ), 
                          IconButton(
                            onPressed: () { setState(() {
                              userModel.removeTransaction(selectedAccount, index);
                            });}, 
                            icon: Icon(Icons.close),
                            
                            hoverColor: Colors.red.withOpacity(0.3),
                            highlightColor: Colors.red,
                          ),
                        ],
                      ),
                    ),
                  )
                )
              );
            },
          ),
        )
      )
    );
  }
}