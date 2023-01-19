import 'package:elfaa/constants.dart';
import 'package:flutter/material.dart';

class SGNotification extends StatefulWidget {
  const SGNotification({super.key});

  @override
  State<SGNotification> createState() => _AdminAlertPageState();
}

class _AdminAlertPageState extends State<SGNotification> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 90,
        title: Text(
          'التنبيهات',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        flexibleSpace: Container(
            decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(28),
              bottomRight: Radius.circular(28)),
          color: kPrimaryColor,
        )),
      ),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: [
            ListView.builder(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: 8,
                itemBuilder: ((context, index) {
                  if (index == 0) {
                    return Center(
                        child: Container(
                            alignment: Alignment.center,
                            height: height * 0.08,
                            child: Text(
                              '19/12/2022',
                              style: Theme.of(context).textTheme.titleLarge,
                            )));
                  }

                  if (index == 5) {
                    return Center(
                        child: Container(
                            alignment: Alignment.center,
                            height: height * 0.08,
                            child: Text(
                              '17/12/2022',
                              style: Theme.of(context).textTheme.titleLarge,
                            )));
                  } else {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(blurRadius: 10, color: Colors.black12)
                            ]
                            // border:
                            //     Border.all(color: Colors.black, width: 2)

                            ),
                        margin: EdgeInsets.symmetric(vertical: 4),

                        padding: EdgeInsets.symmetric(
                          vertical: height * 0.02,
                        ),
                        //color: Colors.amber,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  // Icon(Icons.arrow_back_ios_new),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    '6:00',
                                    style: Theme.of(context).textTheme.caption,
                                  )
                                ],
                              ),
                              Text('الحالة'),
                              Row(
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        'اسم الطفل',
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1,
                                      ),
                                      Text(
                                        'رقم البلاغ',
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: width * 0.02,
                                  ),
                                  CircleAvatar(
                                    backgroundColor: kOrangeColor,
                                    child: Icon(
                                      Icons.notifications_active,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                }))
          ],
        ),
      ),
    );
  }
}
