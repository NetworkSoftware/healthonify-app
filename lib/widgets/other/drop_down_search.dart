import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:search_choices/search_choices.dart';

class DropdownSearch extends StatefulWidget {
  final Function getValue;
  const DropdownSearch({Key? key, required this.getValue}) : super(key: key);

  @override
  State<DropdownSearch> createState() => _DropdownSearch();
}

class _DropdownSearch extends State<DropdownSearch> {
  TextEditingController mobileController = TextEditingController();
  String selectedValue = "";

  List<String> dropDownOptions = ["Select a company"];

  List data = [];

  // List<Companies> data = [];

  // Future getSearchApi(String searchValue) async {
  //   try {
  //     data = await Provider.of<CompaniesList>(context, listen: false)
  //         .getCompanies("query=$searchValue&companyName=1");
  //   } catch (e) {
  //     log(e.toString());
  //     Fluttertoast.showToast(msg: 'Unable to fetch companies');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return SearchChoices.single(
      menuBackgroundColor: Theme.of(context).canvasColor,
      value: selectedValue,
      style: Theme.of(context).textTheme.bodySmall,
      hint: "Select a company",
      searchHint: "Select a company",
      selectedValueWidgetFn: (item) {
        log(item.toString());
        return SizedBox(
          width: double.infinity,
          child: item.toString().isEmpty
              ? Text(
                  "Select a company",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Colors.grey),
                )
              : Text(
                  item.toString(),
                  style: Theme.of(context).textTheme.titleMedium!,
                ),
        );
      },
      futureSearchFn: (String? keyword, String? orderBy, bool? orderAsc,
          List<Tuple2<String, String>>? filters, int? pageNb) async {
        //
        //! await getSearchApi(keyword!);

        List<DropdownMenuItem> results = (data)
            .map<DropdownMenuItem>(
              (e) => DropdownMenuItem(
                value: e.companyName,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  margin: const EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Text(
                      e.companyName!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
              ),
            )
            .toList();
        return (Tuple2<List<DropdownMenuItem>, int>(results, data.length));
      },
      onChanged: (String value) {
        for (var element in data) {
          if (element.companyName == value) {
            widget.getValue(element.id);
            break;
          }
        }
        setState(() {
          selectedValue = value;
        });
      },
      isExpanded: true,
    );
  }
}
