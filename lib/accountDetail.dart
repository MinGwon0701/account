import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'DBHelper.dart';
import 'Account.dart';

class ListDetail extends StatefulWidget {
  ListDetail({Key key}) : super(key: key);

  @override
  _ListDetailState createState() => _ListDetailState();
}

class _ListDetailState extends State<ListDetail> {
  @override
  Widget build(BuildContext context) {
    final Map<String, int> args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("accountDetail"),
      ),
      body: FutureBuilder(
          future: DBHelper().getAccount(args['id']),
          builder: (BuildContext context, AsyncSnapshot<Account> snapshot) {
            if (snapshot.hasData) {
              Account account = snapshot.data;
              print(account.id);
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Container(
                        width: 320,
                        height: 250,
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                account.price.toString() + '원',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 40,
                                  color: (account.priceSign == 1
                                      ? Colors.blue
                                      : Colors.red),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    account.category,
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Text(
                                    account.date,
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 10),
                    child: Text(
                      account.detailContents,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
