// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_testing/models/category.dart';
import 'package:flutter_testing/models/user.dart';
import 'package:flutter_testing/screens/transactions.dart';
import 'package:flutter_testing/utils/styles.dart';
import 'package:flutter_testing/utils/add_space.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    var userModel = context.watch<UserModel>();

    String sign;

    if (userModel.selectedAccount.balance.isNegative) {
      sign = "-\$";
    } else {
      sign = "\$";
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        DashboardCard(sign: sign, userModel: userModel),

        addVerticalSpace(30),

        SizedBox(
          width: 800,
          child: Text('Recent transactions', style: headerStyle,)
        ),

        addVerticalSpace(10),

        TransactionsListView(heightFactor: 0.4)
      ],
    );
  }
}

class DashboardCard extends StatelessWidget {
  const DashboardCard({
    super.key,
    required this.sign,
    required this.userModel,
  });

  final String sign;
  final UserModel userModel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 800,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Account balance'),
                    Text.rich(
                      TextSpan(
                        children: [
                          WidgetSpan(
                              child: Text("$sign ", style: signStyle),
                          ),
                          TextSpan(
                            text: NumberFormat("#,##0.00", "en_US").format(userModel.selectedAccount.balance.abs()), 
                            style: titleStyle
                          )
                        ]
                      )
                    ),
                  ],
                ),
              ),
              Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.bottom,
                columnWidths: const <int, TableColumnWidth>{
                  0: IntrinsicColumnWidth(),
                  1: IntrinsicColumnWidth(), // ? Expensive algorithm?
                },
                children: <TableRow>[
                  TableRow(
                    children: <Widget>[
                      RichText(
                        textAlign: TextAlign.end,
                        text: const TextSpan(
                          children: [
                            TextSpan(text: 'Income '),
                            WidgetSpan(child: Icon(Icons.arrow_downward, color: Colors.green))
                          ]
                      )),
    
                      Text(formatAsCurrency(userModel.selectedAccount.sumOf(CategoryType.income))),
                    ]
                  ),
    
                  TableRow(
                    children: <Widget>[
                      RichText(text: const TextSpan(
                        children: [
                          TextSpan(text: 'Expenses '),
                          WidgetSpan(child: Icon(Icons.arrow_upward, color: Colors.red))
                        ]
                      )),
    
                      Text(formatAsCurrency(userModel.selectedAccount.sumOf(CategoryType.expense))),
                    ]
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String formatAsCurrency(double d) => NumberFormat.simpleCurrency(locale: "en_US").format(d);