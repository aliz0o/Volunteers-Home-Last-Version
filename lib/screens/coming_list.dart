import 'package:flutter/material.dart';
import 'package:volunteering/constants.dart';
import 'package:volunteering/services/get_user_info.dart';

class ComingList extends StatefulWidget {
  final List volunteersList;
  final List attendanceList;
  ComingList({@required this.attendanceList, @required this.volunteersList});
  @override
  _ComingListState createState() => _ComingListState();
}

class _ComingListState extends State<ComingList> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Color.fromRGBO(16, 17, 18, 1),
          appBar: AppBar(
            title: Center(
              child: Text('Coming List',
                  style: kAppBarTextStyle.copyWith(fontSize: 21)),
            ),
            automaticallyImplyLeading: false,
            bottom: TabBar(
              labelPadding: EdgeInsets.symmetric(horizontal: 0),
              tabs: [
                Tab(
                  child: Text('Volunteers', style: kTapControllerTextStyle),
                ),
                Tab(
                  child: Text('Attendance', style: kTapControllerTextStyle),
                ),
              ],
            ),
            backgroundColor: Color.fromRGBO(16, 17, 18, 1),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.pop(context);
            },
            label: Text('Events', style: kTapControllerTextStyle),
            icon: Icon(Icons.arrow_back_ios_outlined),
            backgroundColor: Color.fromRGBO(20, 21, 22, 1),
          ),
          body: TabBarView(
            children: [
              ListView.builder(
                  itemCount: widget.volunteersList.length,
                  itemBuilder: (context, index) {
                    return GetUser(
                        userID: widget.volunteersList[index],
                        screen: 'comingList');
                  }),
              ListView.builder(
                  itemCount: widget.attendanceList.length,
                  itemBuilder: (context, index) {
                    return GetUser(
                        userID: widget.attendanceList[index],
                        screen: 'comingList');
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
