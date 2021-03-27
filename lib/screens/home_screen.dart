import 'dart:math';

import 'package:budget_ui/data/data.dart';
import 'package:budget_ui/helpers/color_helper.dart';
import 'package:budget_ui/models/category_model.dart';
import 'package:budget_ui/screens/category_screen.dart';
import 'package:budget_ui/widgets/bar_char.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  _buildCategory(Category category, double totalAmountSpend) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => CategoryScreen(
                category: category,
              ))),
      child: Container(
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        height: 100.0,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0, 2),
                blurRadius: 6,
              )
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  category.name,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                Text(
                  '\$${(category.maxAmount - totalAmountSpend).toStringAsFixed(2)} / \$${category.maxAmount.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                final double maxBarWidth = constraints.maxWidth;
                final double percent = (category.maxAmount - totalAmountSpend) /
                    category.maxAmount;
                double barWidth = percent * maxBarWidth;

                if (barWidth < 0) {
                  barWidth = 0;
                }

                return Stack(
                  children: <Widget>[
                    Container(
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    Container(
                      height: 20,
                      width: barWidth,
                      decoration: BoxDecoration(
                        color: getColor(context, percent),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ],
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Future<void> _refreshRand(BuildContext context) async {
    await generatenewRand();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => _refreshRand(context),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 100,
              forceElevated: true,
              floating: true,
              //pinned: true,
              leading: IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {},
                iconSize: 25,
              ),
              flexibleSpace: FlexibleSpaceBar(
                title: Text('Simple Budget'),
                centerTitle: true,
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {},
                  iconSize: 25,
                )
              ],
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index == 0) {
                    return Container(
                      margin: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            offset: Offset(0, 2),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: BarChart(weeklySpending),
                    );
                  } else {
                    final Category category = categories[index - 1];
                    double totalAmountSpend = 0;
                    category.expenses.forEach((expense) {
                      totalAmountSpend += expense.cost;
                    });
                    return _buildCategory(category, totalAmountSpend);
                  }
                },
                childCount: 1 + categories.length,
              ),
            )
          ],
        ),
      ),
    );
  }
}
