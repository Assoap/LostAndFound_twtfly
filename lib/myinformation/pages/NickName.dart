///修改呢称
import 'package:flutter/material.dart';

class NickNamePage extends StatelessWidget {
  const NickNamePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('修改用户名'),
        ),
        body: SafeArea(
            minimum: EdgeInsets.all(30),
            child: ListView(
              children: [
                TextField(
                  decoration:
                      InputDecoration(labelText: ('昵称'), hintText: ('请修改昵称')),
                ),
                OutlinedButton(onPressed: () {}, child: Text('确定'))
              ],
            )));
  }
}
