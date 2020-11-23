import 'dart:async';

import 'package:flutter/material.dart';
import 'DBHelper.dart';
import 'Account.dart';

class ListAdd extends StatefulWidget {

  @override
  ListAddState createState() {
    return ListAddState();
  }
}

class ListAddState extends State<ListAdd> {
  DateTime selectedDate = DateTime.now();
  final _formKey = GlobalKey<FormState>();

  String priceVal;
  String categoryVal;
  String detailContentsVal;

  void _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2021),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  int priceSign = 1;

  void signIcon() {
    setState(() {
      if(priceSign == 0)
        priceSign++;
      else if(priceSign == 1)
        priceSign--;
    });
  }

  int num = 1;
  void controllerSetting2(String value) {
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

  void submit() {
    if (_formKey.currentState.validate()) {
      Account account = Account(
          price: int.parse(priceVal),
          category: categoryVal,
          date: "${selectedDate.toLocal()}".split(' ')[0],
          detailContents: detailContentsVal,
          priceSign: priceSign
      );

      DBHelper().createData(account);

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("accountAdd"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              myTextFormField('category', categoryVal),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  myIconButton(priceSign),

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
                      onPressed: () => _selectDate(context),
                      child: Text(
                        'Select date',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      "${selectedDate.toLocal()}".split(' ')[0],
                    ),
                  ],
                ),
              ),
              myTextFormField('detailContent', detailContentsVal),
              Padding(
                padding: const EdgeInsets.only(left: 32.0),
                child: Builder(
                  builder: (context) => RaisedButton(
                    onPressed: () => submit(),
                    child: Text('추가'),
                  ),
                ),
              ),
            ],
          ),
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
          controllerSetting2(value);
          return null;
        },
        decoration: InputDecoration(labelText: 'please input $category'),
      ),
    );
  }

  IconButton myIconButton(int priceSign) {
    return IconButton(
        icon: (priceSign == 0
            ? Icon(Icons.remove, color: Colors.red)
            : Icon(Icons.add, color: Colors.blue)),
        onPressed: signIcon,
    );
  }
}