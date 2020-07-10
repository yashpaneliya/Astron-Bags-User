import 'dart:convert';
import 'package:astron_bags_user/products.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'main.dart';
import 'models/productmodel.dart';
import 'package:location/location.dart';

var state;
var API_KEY = 'DGHqEuAzfnaH3KGswNAY0sW08rQDYOJU';

Location location = new Location();

bool _serviceEnabled;
PermissionStatus _permissionGranted;
LocationData _locationData;

class ProductDetails extends StatefulWidget {
  final ProductModel product;

  const ProductDetails({Key key, this.product}) : super(key: key);
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  getCurrentLocation() async {
    print('inside geo');
    var latstr;
    var longstr;
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    latstr = _locationData.latitude;
    longstr = _locationData.longitude;
    http.Response res = await http.get(
      'https://api.tomtom.com/search/2/reverseGeocode/$latstr%2C$longstr.json?key=$API_KEY',
    );

    var body = json.decode(res.body);
    setState(() {
      state = body['addresses']
          .elementAt(0)['address']['countrySubdivision']
          .toString();
    });
    print(state);
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Products(
                category: widget.product.category,
              ),
            ));
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            widget.product.model,
            style: TextStyle(color: astronColor),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: astronColor,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Center(
                child: Image.network(
              widget.product.imgLink,
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.5,
            )),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        offset: Offset(2, 2),
                        blurRadius: 5)
                  ],
                  border: Border.all(color: astronColor, width: 2.0),
                  borderRadius: BorderRadius.circular(10.0)),
              margin: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 10.0, left: 30.0),
                        child: Text(
                          'Model : ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20.0),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10.0, left: 10.0),
                        child: Text(
                          widget.product.model,
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 10.0, left: 30.0),
                        child: Text(
                          'Category : ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20.0),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10.0, left: 10.0),
                        child: Text(
                          widget.product.category,
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            top: 10.0, left: 30.0, bottom: 10.0),
                        child: Text(
                          'Price : ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20.0),
                        ),
                      ),
                      state == 'Gujarat'
                          ? Container(
                              margin: EdgeInsets.only(
                                  top: 10.0, left: 10.0, bottom: 10.0),
                              child: Text(
                                "₹ " + widget.product.gprice + " /-",
                                style: TextStyle(fontSize: 20.0),
                              ),
                            )
                          : Container(
                              margin: EdgeInsets.only(
                                  top: 10.0, left: 10.0, bottom: 10.0),
                              child: Text(
                                "₹ " + widget.product.oprice + " /-",
                                style: TextStyle(fontSize: 20.0),
                              ),
                            ),
                    ],
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
