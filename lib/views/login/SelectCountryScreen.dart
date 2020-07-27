import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/data_models/country.dart';
import 'package:flutter_chat_app/providers/Countries.dart';
import 'package:flutter_chat_app/customwidgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter_chat_app/resource/Colors.dart' as AppColors;

class SelectCountry extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final countriesProvider = Provider.of<CountryProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor:AppColors.colorWhite ,
        iconTheme:IconThemeData(color: AppColors.colorPrimary),
        title: Text('Search your country', style: TextStyle(color: AppColors.colorPrimary, fontWeight: FontWeight.bold)),
        bottom: PreferredSize(
          preferredSize: Size(double.infinity, 50.0),
          child:
              SearchCountryTF(controller: countriesProvider.searchController),
        ),
      ),
      body: ListView.builder(
        itemCount: countriesProvider.searchResults.length,
        itemBuilder: (BuildContext context, int i) {
          return SelectableWidget(
            country: countriesProvider.searchResults[i],
            selectThisCountry: (Country c) {
              print(i);
              countriesProvider.selectedCountry = c;
              Navigator.of(context).pop();
            },
          );
        },
      ),
    );
  }
}
