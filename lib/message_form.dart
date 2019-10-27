
import 'package:andabera/auth.dart';
import 'package:andabera/card_details.dart';
import 'package:andabera/modelTest.dart';
import 'package:flutter/material.dart';

class CreateAlert extends StatefulWidget {
  @override
  _CreateAlertState createState() => _CreateAlertState();
}
class _CreateAlertState extends State<CreateAlert> {
  final _formKey = GlobalKey<FormState>();
  User _user = new User();
  TextEditingController title;
  TextEditingController description;
  TextEditingController chanel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Create Alert')),
        body: Container(
            padding:
            const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: Builder(
                builder: (context) => Form(
                    key: _formKey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            decoration:
                            InputDecoration(labelText: 'Alert Title'),
                            controller: title,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter Alert Title';
                              }
                              return null;
                            },
                            onSaved: (val) =>
                                setState(() => _user.cardTitle = val),
                          ),
                          TextFormField(
                              decoration:
                              InputDecoration(labelText: 'Description'),
                              controller: description,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter Description.';
                                }
                                return null;
                              },
                              onSaved: (val)=>
                                  setState(() => _user.cardDescription = val)),

                          TextFormField(
                              decoration:
                              InputDecoration(labelText: 'Chanel'),
                              controller: chanel,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter Chanel.';
                                }
                                return null;
                              },
                              onSaved: (val) =>
                                  setState(() => _user.relatedChanel = val)),
                          Container(
                            padding: const EdgeInsets.fromLTRB(0, 50, 0, 20),
                            child: Text('Subscribe'),
                          ),
                          SwitchListTile(
                              title: const Text('Monthly Newsletter'),
                              value: _user.newsletter,
                              onChanged: (bool val) =>
                                  setState(() => _user.newsletter = val)),
                          Container(
                            padding: const EdgeInsets.fromLTRB(0, 50, 0, 20),
                            child: Text('Interests'),
                          ),
                          CheckboxListTile(
                              title: const Text('Cooking'),
                              value: _user.passions[User.PassionCooking],
                              onChanged: (val) {
                                setState(() =>
                                _user.passions[User.PassionCooking] = val);
                              }),
                          CheckboxListTile(
                              title: const Text('Traveling'),
                              value: _user.passions[User.PassionTraveling],
                              onChanged: (val) {
                                setState(() => _user
                                    .passions[User.PassionTraveling] = val);
                              }),
                          CheckboxListTile(
                              title: const Text('Hiking'),
                              value: _user.passions[User.PassionHiking],
                              onChanged: (val) {
                                setState(() =>
                                _user.passions[User.PassionHiking] = val);
                              }),
                          Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16.0, horizontal: 16.0),
                              child: RaisedButton(
                                  onPressed: () {
                                    if(_formKey.currentState.validate()){
                                      _formKey.currentState.save();
                                      print(_user.cardTitle);
                                      authService.saveMessages(_user);
                                      _showDialog(context);
                                    }


//                                    if (form.validate()) {
//                                      form.save();
//                                    }
                                  },
                                  child: Text('Save'))),
                        ])))));
  }
  _showDialog(BuildContext context) {
    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text('Submitting form')));
  }
}