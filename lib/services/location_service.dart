// import 'dart:html';

// import 'package:location/location.dart';

// class LocationService {
//   Location location  = Location();
//   late LocationData _locData; 

//   Future<void> initialize() async {
//     bool _serviceEnable;
//     PermissionStatus _permission;

//     _serviceEnabled = await location.serviceEnabled(); 
//     if(!_serviceEnabled) {
//       _serviceEnabled = await location.requestService();
//       if(!_serviceEnabled) {
//         return;
//       }
//     }

//     _permission = await location.hasPermission();
//     if(_permission == PermissionStatus.denied) {
//       _permission = await location.requestPermission();
//       if(_permission != PermissionStatus.granted) {
//         return;
//       }
//     }
//   }

//   Future<double?> getLatitude() async {
//     _locData = await location.getLocation();
//     return _locData.latitude;
//   }

//   Future<double?> getLongitude() async {
//     _locData = await location.getLocation();
//     return _locData.longitude;
//   }

// }

// //sang bên file homescreen.dart để thêm longitude và longitude
// // đoạn code được thêm
// @override
// void initSate() {
//   super.initSate();
//   _startLocationService();
//   getId();
// }

// void _startLocationService() async {
//   LocationService().initialize();

//   LocationService().getLongitude().then((value) => {
//     setState(() {
//       User.long = value;
//     });

//     LocationService().getLatitude().then((value) {
//       setState(() {
//         User.lat = value!;
//       });
//     });

//   });
// }

// //sang bên file todayscreen.dart để thêm 
// // đoạn code được thêm
// //thêm string gì đó 7:54

// void _getLocation async {
//   List<Placemark> placemark = await placemarkFromCoordinates(User.lat, User.long);

//   setsState(() {
//     location = "${placemark[0].street}, ${placemark[0].adminstrativeArea}, ${placemark[0].postalCode}, ${placemark[0].country}"
  
//   });
// }



// // xong sửa cái gì đó lung tung 9:20