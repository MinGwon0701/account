import 'package:flutter/material.dart';
import 'Account.dart';
import 'package:intl/intl.dart';
import 'DBHelper.dart';

class ListModify extends StatefulWidget {
  ListModify({Key key}) : super(key: key);

  @override
  _ListModifyState createState() => _ListModifyState();
}

class _ListModifyState extends State<ListModify> {
  final _formKey = GlobalKey<FormState>();

  DateTime selectedDate;
  String priceVal;
  String categoryVal;
  String detailContentsVal;
  int priceSign;

  void _selectDate(BuildContext context, DateTime time) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: time,
      firstDate: DateTime(2000),
      lastDate: DateTime(2021),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  int signCount = 0;

  void signIcon() {
    (priceSign == 1) ? priceSign-- : priceSign++;
    setState(() {});
  }

  Icon iconSetting(int sign) {
    if (signCount == 0) {
      priceSign = sign;
      signCount++;
    }
    return (priceSign == 0
        ? Icon(Icons.remove, color: Colors.red)
        : Icon(Icons.add, color: Colors.blue));
  }

  void controllerFirstSetting(Account account) {
    priceVal = account.price.toString();
    categoryVal = account.category;
    detailContentsVal = account.detailContents;
  }

  int num = 1;

  void controllerSecondSetting(String value) {
    switch (num) {
      case 1:
        categoryVal = value;
        num++;
        break;
      case 2:
        priceVal = value;
        num++;
        break;
      case 3:
        detailContentsVal = value;
        num++;
        break;
    }
  }

  int dateCount = 0;

  void dateSetting(String accountDate) {
    if (dateCount == 0) {
      selectedDate = DateFormat('yyyy-MM-dd').parse(accountDate);
      dateCount++;
    }
  }

  void submit(int index) {
    if (_formKey.currentState.validate()) {
      Account account2 = Account(
          category: categoryVal,
          price: int.parse(priceVal),
          date: "${selectedDate.toLocal()}".split(' ')[0],
          detailContents: detailContentsVal,
          priceSign: priceSign);

      DBHelper().updateData(account2, index);

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = ModalRoute.of(context).settings.arguments;
    int index = args['id'];

    return Scaffold(
      appBar: AppBar(
        title: Text("accountModify"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: FutureBuilder(
              future: DBHelper().getAccount(index),
              builder: (BuildContext context, AsyncSnapshot<Account> snapshot) {
                if (snapshot.hasData) {
                  Account account = snapshot.data;
                  controllerFirstSetting(account);
                  dateSetting(account.date);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      myTextFormField('category', categoryVal),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: iconSetting(account.priceSign),
                            onPressed: () => signIcon(),
                          ),
                          Container(
                            width: 300,
                            child: myTextFormField('price', priceVal),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            RaisedButton(
                              onPressed: () => _selectDate(context,
                                  DateFormat('yyyy-MM-dd').parse(account.date)),
                              child: Text(
                                'Select date',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text("${selectedDate.toLocal()}".split(' ')[0]),
                          ],
                        ),
                      ),
                      myTextFormField('detailContent', detailContentsVal),
                      Padding(
                        padding: const EdgeInsets.only(left: 32.0),
                        child: Builder(
                          builder: (context) => RaisedButton(
                            onPressed: () => submit(index),
                            child: Text('수정'),
                          ),
                        ),
                      ),
                    ],
                  );
                }
                return Center(child: CircularProgressIndicator());
              }),
        ),
      ),
    );
  }

  Padding myTextFormField(String category, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 10.0),
      child: TextFormField(
        initialValue: text,
        validator: (value) {
          if (value.isEmpty) {
            return 'Please enter some text';
          }
          controllerSecondSetting(value);
          return null;
        },
        decoration: InputDecoration(labelText: '$category'),
      ),
    );
  }
}
