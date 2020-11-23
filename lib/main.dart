import 'package:flutter/material.dart';
import 'accountAdd.dart';
import 'accountDetail.dart';
import 'accountModify.dart';
import 'DBHelper.dart';
import 'testPage.dart';
import 'Account.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

void main() {
  runApp(MaterialApp(
    title: 'Account',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    initialRoute: '/',
    routes: {
      '/': (context) => MyHomePage(),
      '/ListDetail': (context) => ListDetail(),
      '/ListModify': (context) => ListModify(),
      '/ListAdd': (context) => ListAdd(),
      '/TestPage': (context) => TestPage(),
    },
  ));
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController searchController = TextEditingController();
  String searchVal = '';
  List<String> agoSearchVal = [];

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("account"),
      ),
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                padding: EdgeInsets.symmetric(horizontal: 10),
                width: size.width * 0.83,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  border: Border.all(width: 1, color: Colors.black26),
                ),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search',
                    hintStyle: TextStyle(color: Colors.grey[500]),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  setState(() {
                    searchVal = searchController.text;
                    if(searchVal != '')
                      agoSearchVal.add(searchVal);
                  });
                },
              )
            ],
          ),
          Container(
            height: 50,
            child: (agoSearchVal.isNotEmpty) ? ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: agoSearchVal.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 11, horizontal: 10),
                    child: FlatButton(
                      child: Text(
                        agoSearchVal[index],
                        style: TextStyle(fontSize: 22, color: Colors.black45),
                      ),
                      onPressed: () {
                        searchController.text = agoSearchVal[index];
                      },
                    ),
                  );
                }) : Center(child: Text('이전 검색어가 없습니다.')),
          ),
          Expanded(
            child: FutureBuilder(
              future: DBHelper().getSomeAccount(searchVal),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Account>> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      Account item = snapshot.data[index];
                      return Dismissible(
                        key: UniqueKey(),
                        background: Container(
                          color: Colors.blue,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/ListDetail',
                                arguments: <String, int>{'id': item.id});
                          },
                          child: Slidable(
                            actionPane: SlidableDrawerActionPane(),
                            actionExtentRatio: 0.25,
                            child: Container(
                              color: Colors.white,
                              child: ListTile(
                                leading: (item.priceSign == 0
                                    ? Icon(Icons.remove, color: Colors.red)
                                    : Icon(Icons.add, color: Colors.blue)),
                                title: Text(item.price.toString(),
                                    style: TextStyle(fontSize: 18)),
                                subtitle: Text(item.category),
                                trailing: Text(item.date),
                              ),
                            ),
                            actions: <Widget>[
                              IconSlideAction(
                                  caption: 'Test',
                                  icon: Icons.speaker_notes,
                                  onTap: () {
                                    Navigator.pushNamed(context, '/TestPage');
                                  }),
                            ],
                            secondaryActions: <Widget>[
                              IconSlideAction(
                                  caption: 'Modify',
                                  color: Colors.black45,
                                  icon: Icons.create,
                                  onTap: () {
                                    Navigator.pushNamed(context, '/ListModify',
                                        arguments: <String, int>{
                                          'id': item.id,
                                        }).then((value) => setState(() {}));
                                  }),
                              IconSlideAction(
                                  caption: 'Delete',
                                  color: Colors.red,
                                  icon: Icons.delete,
                                  onTap: () {
                                    setState(() {
                                      DBHelper().deleteAccount(item.id);
                                    });
                                  }),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/ListAdd'),
        tooltip: 'listAdd',
        child: Icon(Icons.add),
      ),
    );
  }
}
