import 'package:alpha_go/views/widgets/navbar_widget.dart';
import 'package:alpha_go/views/widgets/recommendation_tile_widget.dart';
import 'package:alpha_go/views/widgets/search_options_widget.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
enum SearchType { User, Place, Event, NFTs, Tags }

extension SearchTypeExtension on SearchType {
  String get label {
    switch (this) {
      case SearchType.User:
        return 'Users';
      case SearchType.Place:
        return 'Places';
      case SearchType.Event:
        return 'Events';
      case SearchType.NFTs:
        return 'NFTs';
      case SearchType.Tags:
        return 'Tags';
    }
  }
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  SearchType selectedSearchType = SearchType.User; // Default selected option
  //---------------- Dummy data ----------------
  List<String> users = [
    'John Doe',
    'Jane Smith',
    'Tom Jones',
    'Nischal Gautam'
  ];
  List<String> places = ['Paris', 'New York', 'Tokyo'];
  List<String> events = ['Music Concert', 'Art Exhibition', 'Tech Conference'];
  List<String> nfts = ['CryptoPunk', 'Bored Ape', 'Azuki'];
  List<String> tags = ['Art', 'Technology', 'Music'];
//--------------------------------------------
  List<String> suggestions = [];
  List<String> filteredSuggestions = []; 
  final TextEditingController searchController = TextEditingController();

  void getSuggestions() {
    setState(() {
      switch (selectedSearchType) {
        case SearchType.User:
          suggestions = users;
          break;
        case SearchType.Place:
          suggestions = places;
          break;
        case SearchType.Event:
          suggestions = events;
          break;
        case SearchType.NFTs:
          suggestions = nfts;
          break;
        case SearchType.Tags:
          suggestions = tags;
          break;
      }
      filterSuggestions(searchController.text);
    });
  }
   void filterSuggestions(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredSuggestions = List.from(suggestions);
      } else {
        filteredSuggestions = suggestions
            .where((item) => item.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getSuggestions();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/bg.jpg'), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: CustomNavBar(
          leadingWidget: Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back_ios, color: Color(0xffb4914b)),
                ),
              ),
              Text('Search',
                  style: TextStyle(color: const Color(0xffb4914b), fontSize: 18.sp)),
            ],
          ),
          actionWidgets: Container(),
        ),
        body: 
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.8.w, vertical: 2.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Search for?',
                      style:
                          TextStyle(color: const Color(0xffb4914b), fontSize: 16.sp)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: SearchType.values.map((type) {
                          return SearchOptionChip(
                            label: type.label,
                            selectedLabel: selectedSearchType.label,
                            onSelected: (value) {
                              setState(() {
                                selectedSearchType = SearchType.values
                                    .firstWhere((e) => e.label == value);
                                getSuggestions();
                              });
                            },
                          );
                        }).toList(),

                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  Padding(
                                       padding: EdgeInsets.symmetric(vertical: 4.h),

                    child: TextField(
                      controller: searchController,
                      onChanged: (query) {
                        setState(() {
                          if (query.isEmpty) {
                            filteredSuggestions = List.from(suggestions);
                          } else {
                            filteredSuggestions = suggestions
                                .where((item) => item
                                    .toLowerCase()
                                    .contains(query.toLowerCase()))
                                .toList();
                          }
                        });
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.black.withOpacity(0.6),
                        hintText: 'Search...',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 16.sp),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide:
                              const BorderSide(color: Color(0xffb4914b), width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide:
                              const BorderSide(color: Color(0xffb4914b), width: 1),
                        ),
                      ),
                      style: TextStyle(color: Colors.white, fontSize: 18.sp),
                    ),
                  ),
                   
                  Expanded(
                    child: ListView(
                      children: filteredSuggestions.map((suggestion) {
                        return RecommendationTile(
  suggestion: suggestion,
  onTap: () {
  },
);
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          
      ),
    );
  }

}
