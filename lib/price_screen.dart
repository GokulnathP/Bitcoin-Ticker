import 'dart:io';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'coin_data.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  void initState() {
    super.initState();
    getCurrencyValue();
  }

  String selectedCurrency = 'USD';

  Map<String, int> coinData = {
    'BTC': 0,
    'ETH': 0,
    'LTC': 0,
  };

  bool loading = false;

  void getCurrencyValue() async {
    setState(() {
      loading = true;
    });
    for (String crypto in cryptoList) {
      final url =
          'https://rest.coinapi.io/v1/exchangerate/$crypto/$selectedCurrency?apikey=2B858CA1-9145-4855-A093-1FC1C078EDD5';
      final response = await http.get(url);
      setState(() {
        coinData[crypto] = json.decode(response.body)['rate'].toInt();
      });
    }
    setState(() {
      loading = false;
    });
  }

  DropdownButton<String> androidDropdownButton() {
    List<DropdownMenuItem<String>> dropdownItems = [];

    for (String currency in currenciesList) {
      var item = DropdownMenuItem(
        value: currency,
        child: Text(currency),
      );
      dropdownItems.add(item);
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
          getCurrencyValue();
        });
      },
    );
  }

  CupertinoPicker iosPicker() {
    List<Widget> items = [];

    for (String currency in currenciesList) {
      items.add(Text(currency));
    }

    return CupertinoPicker(
      itemExtent: 34.0,
      onSelectedItemChanged: (value) {
        selectedCurrency = currenciesList[value];
        getCurrencyValue();
      },
      children: items,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
                child: Card(
                  color: Colors.lightBlueAccent,
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                    child: Text(
                      '1 BTC = ${coinData['BTC'] == 0 || loading ? '?' : coinData['BTC']} $selectedCurrency',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
                child: Card(
                  color: Colors.lightBlueAccent,
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                    child: Text(
                      '1 ETH = ${coinData['ETH'] == 0 || loading ? '?' : coinData['ETH']} $selectedCurrency',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
                child: Card(
                  color: Colors.lightBlueAccent,
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                    child: Text(
                      '1 LTC = ${coinData['LTC'] == 0 || loading ? '?' : coinData['LTC']} $selectedCurrency',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Center(
            child: loading ? CircularProgressIndicator() : Container(),
          ),
          Container(
            height: 100.0,
            alignment: Alignment.center,
            color: Colors.lightBlue,
            child: Platform.isIOS ? iosPicker() : androidDropdownButton(),
          ),
        ],
      ),
    );
  }
}
