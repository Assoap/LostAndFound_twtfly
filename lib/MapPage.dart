import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:amap_flutter_location/amap_flutter_location.dart';
import 'package:amap_flutter_location/amap_location_option.dart';

import 'package:flutter/material.dart';
import 'Config.dart';
import 'NewWidgets/AmapLocation.dart';



class MapPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() =>_MapPageState();
}

class _MapPageState extends State<MapPage>{
  late Map<String, Object> _locationResult;
  late AMapController _mapController;
  var map;

  //地图初始化
  void _onMapCreated(AMapController controller) {
    setState(() {
      _mapController = controller;
    });
  }

  //改变镜头位置
   void _changeCameraPosition(LatLng position) {
    _mapController?.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: position, zoom: Config.nowZoom),
      ),
      animated: true,
    );
  }

  //记录镜头位置并绘制marker
  void _onCameraMoveEnd(CameraPosition cameraPosition){
    setState(() {
      Config.nowLocationMarker['now']=Marker(position: cameraPosition.target);
      Config.nowLatLng=cameraPosition.target;
      Config.nowZoom=cameraPosition.zoom;
    });
  }

  //获得位置并改变镜头位置
  void getPosition(){
    Config.setAmapLocationApiKey();
    Config.setAmapLocationPrivacyAgree();
    AmapLocation amapLocation=new AmapLocation();
    amapLocation.AMapLocationStart();
    var location=amapLocation;

    location.locationListener = location.locationPlugin.onLocationChanged().listen((Map<String, Object> result) {
      setState(() {
        print(result);
        _locationResult = result;
        if (_locationResult != null) {
          double longitude = double.tryParse(_locationResult['longitude'].toString())!;
          double latitude = double.tryParse(_locationResult['latitude'].toString())!;
          _changeCameraPosition(LatLng(latitude, longitude));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    map = AMapWidget(
      apiKey: Config.amapApiKeys,
      privacyStatement: Config.amapPrivacyStatement,
      onMapCreated: _onMapCreated,

      //设置地图初始位置，Config.nowLatLng为空时默认在天安门
      initialCameraPosition: Config.nowLatLng==null? CameraPosition(target: LatLng(39.909187, 116.397451)):CameraPosition(target: Config.nowLatLng,zoom:Config.nowZoom),

      //地图marker
      markers: Set<Marker>.of(Config.nowLocationMarker.values),
      onCameraMoveEnd: _onCameraMoveEnd,
    );
    return Stack(
      children: <Widget>[
        map,

        //一个在地图中心的点，用来辅助瞄准
        Center(
          child: Icon(
            Icons.circle,
            color: Colors.blue,
            size: 5,
          ),
        ),

        //定位按钮
        Positioned(
          top: 20,
          right: 20,
          child: ElevatedButton(
              onPressed: getPosition,

              //利用ValueListenableBuilder监听是否获取权限，获取权限后立刻改变按钮文字
              child: ValueListenableBuilder(
                valueListenable: Config.hasLocationPermission,
                builder: (context,value,child){
                  return Config.hasLocationPermission.value?
                  Text('定位'):Text('获取权限');
                },
                child: Config.hasLocationPermission.value?
                  Text('定位'):Text('获取权限'),
              )
          ),
        )
      ],
    );
  }
}
