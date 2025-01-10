import 'package:alpha_go/views/widgets/navbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String selectedSearchType = 'User'; // Default selected option
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

  void getSuggestions() {
    setState(() {
      if (selectedSearchType == 'User') {
        suggestions = users;
      } else if (selectedSearchType == 'Place') {
        suggestions = places;
      } else if (selectedSearchType == 'Event') {
        suggestions = events;
      } else if (selectedSearchType == 'NFTs') {
        suggestions = nfts;
      } else if (selectedSearchType == 'Tags') {
        suggestions = tags;
      }
      filteredSuggestions = List.from(suggestions); 
    });
  }

  @override
  void initState() {
    super.initState();
    getSuggestions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/bg.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.8.w, vertical: 2.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 1.h),
                Text('Search for?',
                    style:
                        TextStyle(color: const Color(0xffb4914b), fontSize: 16.sp)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 2.h),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            'Users',
                            'Places',
                            'Events',
                            'NFTs',
                            'Tags'
                          ].map((label) {
                            return _buildSearchOption(label);
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 4.h),
                TextField(
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
                 SizedBox(height: 4.h),
                Expanded(
                  child: ListView(
                    children: filteredSuggestions.map((suggestion) {
                      return _buildRecommendationTile(suggestion);
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchOption(String label) {
    bool isSelected = selectedSearchType == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedSearchType = label;
          getSuggestions();
        });
      },
      child: Container(
        margin: EdgeInsets.only(right: 4.w),
        padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 4.w),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xffb4914b) : Colors.white,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? const Color(0xffb4914b) : Colors.white,
            fontSize: 16.sp,
          ),
        ),
      ),
    );
  }

  Widget _buildRecommendationTile(
    String suggestion,
  ) {
    return InkWell(
      onTap: () {}, 

      child: Container(
        margin: EdgeInsets.symmetric(vertical: 1.3.h, horizontal: 2.w),
        padding: EdgeInsets.symmetric(vertical: 1.8.h, horizontal: 1.5.w),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xffb4914b),
            width: 0.3,
          ),
        ),
        child: ListTile(
          leading: CircleAvatar(
            radius: 5.7.w,
            backgroundColor: const Color(0xffb4914b),
            child: CircleAvatar(
              backgroundImage: const AssetImage('assets/profile.jpg'),
              radius: 5.w,
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                suggestion,
                style: TextStyle(color: Colors.white, fontSize: 16.sp),
              ),
              Text(
                overflow: TextOverflow.clip,
                'randm description here ...',
                style: TextStyle(color: Colors.grey, fontSize: 14.sp),
              ),
            ],
          ),
          trailing: const Icon(Icons.more_vert, color: Color(0xffb4914b)),
          onTap: () {
            // Navigate to the detail page
          },
        ),
      ),
    );
  }
}
