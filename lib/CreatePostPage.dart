import 'package:flutter/material.dart';

import 'RouterManager.dart';
import 'NewWidgets/NewTextField.dart';
import 'Models/InputRecorder.dart';

import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:photo_manager/photo_manager.dart';

class CreatePostPage extends StatefulWidget {  @override
  State<StatefulWidget> createState() {
    return _CreatePostPageState();
  }
}

class _CreatePostPageState extends State<CreatePostPage> {
  var isLost=true;
  var postDescription='';
  var chosenOne='卡片';
  var isLocated=false;
  var postContentRecorder= InputRecorder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,

        leading: IconButton(
          icon: Icon(
            Icons.backspace,
            color: Colors.blueGrey,
          ),
          onPressed: (){
            RouterManager.router.pop(context);
          },
        ),
        title: Text(
          '发帖',
          style: TextStyle(

          ),
        ),
      ),

      body: Container(
        padding: EdgeInsetsDirectional.only(start: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(padding: EdgeInsetsDirectional.only(top:10)),

            Text(
              '请选择发帖类型',
              style: TextStyle(
                color: Colors.blueGrey,
                fontSize: 20,
              ),
            ),

            Padding(padding: EdgeInsetsDirectional.only(top: 10)),

            ///选择失物拾物
            Row(
              children: <Widget>[
                GestureDetector(
                  onTap: (){
                    setState(() {
                      isLost=true;
                    });
                  },
                  child: Container(
                    width: 80,
                    height: 40,
                    child: Center(
                      child: Text(
                        '失物',
                        style: TextStyle(
                          color: isLost==true? Colors.white : Colors.blue,
                          fontSize: 20
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: isLost==true? Colors.blue : Colors.white,
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
                Padding(padding: EdgeInsetsDirectional.only(start: 10)),
                GestureDetector(
                  onTap: (){
                    setState(() {
                      isLost=false;
                    });
                  },
                  child: Container(
                    width: 80,
                    height: 40,
                    child: Center(
                      child: Text(
                        '拾物',
                        style: TextStyle(
                            color: isLost==true? Colors.blue : Colors.white,
                            fontSize: 20
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: isLost==true? Colors.white : Colors.blue,
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
              ],
            ),

            Text(
              '请简单描述物品',
              style: TextStyle(
                color: Colors.blueGrey,
                fontSize: 20,
              ),
            ),

            ///输入物品描述
            Container(
              padding: EdgeInsetsDirectional.only(end:50),
              child: TextField(
                onChanged: (value){setState(() {
                  postDescription = value;
                });},
                decoration: InputDecoration(
                  counterText: '${postDescription.length}/50',
                ),
              ),
            ),

            Text(
              '请选择物品类型',
              style: TextStyle(
                color: Colors.blueGrey,
                fontSize: 20,
              ),
            ),

            ///选择物品类型
            Row(
              children: <Widget>[
                GestureDetector(
                  child: ItemKind(
                    imagePath: 'assets/card.png',
                    name: '卡片',
                    isChosen: chosenOne,
                  ),
                  onTap: (){
                    setState(() {
                      chosenOne='卡片';
                    });
                  },
                ),
                Padding(padding: EdgeInsetsDirectional.only(end: 15)),
                GestureDetector(
                  child: ItemKind(
                      imagePath: 'assets/key.png',
                      name: '钥匙',
                      isChosen: chosenOne,
                  ),
                  onTap: (){
                    setState(() {
                      chosenOne='钥匙';
                    });
                  },
                ),
                Padding(padding: EdgeInsetsDirectional.only(end: 15)),
                GestureDetector(
                  child: ItemKind(
                      imagePath: 'assets/phone.png',
                      name: '手机',
                      isChosen: chosenOne,
                  ),
                  onTap: (){
                    setState(() {
                      chosenOne='手机';
                    });
                  },
                )
              ],
            ),

            Text(
              '请选择${isLost==true? '失物':'拾物'}位置(可不选)',
              style: TextStyle(
                color: Colors.blueGrey,
                fontSize: 20,
              ),
            ),

            ///选择位置
            Row(
              children: [
                ElevatedButton(
                  onPressed: (){
                      RouterManager.router.navigateTo(context, '/map?mode=1');
                      setState(() {
                        isLocated=true;
                      });
                    },
                  child: Text('开启地图'),
                ),
                Text(isLocated==true? '已选择位置':'未选择位置'),
              ],
            ),

            Text(
              '请输入详细描述（可空）',
              style: TextStyle(
                color: Colors.blueGrey,
                fontSize: 20,
              ),
            ),

            ///详细内容输入框，输入内容记录在postContentRecorder.value中
            Stack(
              children: [
                Container(
                    padding: EdgeInsetsDirectional.only(end:20),
                    child: NewTextField(maxLine: 7, minLine: 7, valueRecorder: postContentRecorder)
                ),
                Positioned(
                  child: IconButton(
                    icon: Icon(Icons.image),
                    onPressed: ()async{final List<AssetEntity>? result = await AssetPicker.pickAssets(context);},
                  ),
                )
              ],
            ),
          ],
        ),
      )
    );
  }
}

//选择物品种类组件
class ItemKind extends StatefulWidget {
  final String imagePath;
  final String name;
  final String isChosen;
  ItemKind({Key? key, required this.imagePath, required this.name, required this.isChosen});

  @override
  State<StatefulWidget> createState() => _ItemKindState();
}

class _ItemKindState extends State<ItemKind> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: 40,
      child: Column(
        children: <Widget>[
          Container(
            height: 40,
            width: 40,
            child: Image(
              image: AssetImage(widget.imagePath),
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: widget.isChosen==widget.name? Colors.blue : Colors.white,
                width: 2,
              )
            ),
          ),
          Padding(padding: EdgeInsetsDirectional.only(top: 10)),
          Text(
            widget.name,
            style: TextStyle(color: widget.isChosen==widget.name? Colors.blue : Colors.blueGrey,),
          )
        ],
      ),
    );
  }
}