import 'package:flutter/material.dart';
import 'package:getogether/utils/constants.dart';
import 'package:getogether/widgets/custom_app_bar.dart';

class GroupsPage extends StatefulWidget {
  @override
  _GroupsPageState createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.primaryColor,
      appBar: CustomAppBar(),
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: <Widget>[
          _buildHeader(),
        ],
      ),
    );
  }

  SliverPadding _buildHeader() {
    return SliverPadding(padding: const EdgeInsets.all(20.0),
    sliver: SliverToBoxAdapter(
      child: Text(
        'Your Groups',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 25.0,
          fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}