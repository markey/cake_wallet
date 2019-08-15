import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cake_wallet/palette.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:cake_wallet/src/widgets/primary_button.dart';

class RestoreFromKeys extends StatefulWidget{

  @override
  createState() => _RestoreFromKeys();

}

class _RestoreFromKeys extends State<RestoreFromKeys>{

  final _formKey = GlobalKey<FormState>();
  TextEditingController _controller = new TextEditingController();

  Future _selectDate(BuildContext context) async{
    final DateTime restoreData = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2018),
        lastDate: DateTime(2030));
    if (restoreData != null){
      setState(() {
        _controller.text = DateFormat('yyyy-MM-dd').format(restoreData);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.white,
        appBar: CupertinoNavigationBar(
          middle: Text('Restore from keys'),
          backgroundColor: Colors.white,
          border: null,
        ),
        body: GestureDetector(
          onTap: (){
            SystemChannels.textInput.invokeMethod('TextInput.hide');
          },
          child: Container(
              padding: EdgeInsets.only(
                  left: 20.0,
                  right: 20.0,
                  bottom: 20.0
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Flexible(
                        flex: 5,
                        child: Container(
                          padding: EdgeInsets.only(
                              top: 20.0,
                              bottom: 20.0
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              TextFormField(
                                decoration: InputDecoration(
                                    hintStyle: TextStyle(color: Palette.lightBlue),
                                    hintText: 'Wallet name',
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Palette.lightGrey,
                                            width: 2.0
                                        )
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Palette.lightGrey,
                                            width: 2.0
                                        )
                                    )
                                ),
                                validator: (value){
                                  return null;
                                },
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                    hintStyle: TextStyle(color: Palette.lightBlue),
                                    hintText: 'Address',
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Palette.lightGrey,
                                            width: 2.0
                                        )
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Palette.lightGrey,
                                            width: 2.0
                                        )
                                    )
                                ),
                                validator: (value){
                                  return null;
                                },
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                    hintStyle: TextStyle(color: Palette.lightBlue),
                                    hintText: 'View key (private)',
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Palette.lightGrey,
                                            width: 2.0
                                        )
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Palette.lightGrey,
                                            width: 2.0
                                        )
                                    )
                                ),
                                validator: (value){
                                  return null;
                                },
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                    hintStyle: TextStyle(color: Palette.lightBlue),
                                    hintText: 'Spend key (private)',
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Palette.lightGrey,
                                            width: 2.0
                                        )
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Palette.lightGrey,
                                            width: 2.0
                                        )
                                    )
                                ),
                                validator: (value){
                                  return null;
                                },
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                    hintStyle: TextStyle(color: Palette.lightBlue),
                                    hintText: 'Restore from blockheight',
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Palette.lightGrey,
                                            width: 2.0
                                        )
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Palette.lightGrey,
                                            width: 2.0
                                        )
                                    )
                                ),
                                validator: (value){
                                  return null;
                                },
                              ),
                            ],
                          ),
                        )
                    ),
                    Text(
                      'or',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                            child: Container(
                              child: InkWell(
                                onTap: (){
                                  _selectDate(context);
                                },
                                child: IgnorePointer(
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                        hintStyle: TextStyle(color: Palette.lightBlue),
                                        hintText: 'Restore from date',
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Palette.lightGrey,
                                                width: 2.0
                                            )
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Palette.lightGrey,
                                                width: 2.0
                                            )
                                        )
                                    ),
                                    controller: _controller,
                                    validator: (value){
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                            )
                        )
                      ],
                    ),
                    Flexible(
                        flex: 3,
                        child: Container(
                          alignment: Alignment.bottomCenter,
                          child: PrimaryButton(
                              onPressed: (){},
                              text: 'Recover'
                          ),
                        )
                    )
                  ],
                ),
              )
          ),
        )
    );

  }

}