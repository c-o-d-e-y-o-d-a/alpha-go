import 'dart:convert';
import 'dart:typed_data';
import 'package:alpha_go/controllers/timeline_post_controller.dart';
import 'package:alpha_go/controllers/user_controller.dart';
import 'package:alpha_go/controllers/wallet_controller.dart';
import 'package:alpha_go/views/screens/testing-screens/nft_details_screen.dart';
import 'package:alpha_go/views/widgets/navbar_widget.dart';
import 'package:alpha_go/views/widgets/timeline_post_widget.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:responsive_sizer/responsive_sizer.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final WalletController controller = Get.find();
  final UserController userController = Get.find();
  final TimelinePostController postController = Get.find();
  bool isFetchingBalance = false;
  bool _isLoading = true;
  List<Map<String, dynamic>> _results = [];
  Uint8List? _imageData;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await controller.fetchTransanctions();
      await _fetchImage();
      await _fetchRuneBalances();
    });
  }

  Future<void> _fetchRuneBalances() async {
    final url = Uri.parse(
        'https://api.hiro.so/runes/v1/addresses/${controller.address}/balances?offset=0');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        setState(() {
          _results = List<Map<String, dynamic>>.from(data['results']);
          _isLoading = false;
        });
      } else {
        throw Exception(
            'Failed to load balances. Status code: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching balances: $e');
    }
  }

  Future<void> _fetchImage() async {
    final url = Uri.parse(
        'https://api.hiro.so/ordinals/v1/inscriptions/c5ef6f0eb0b0215a73aba5cae3ed35a005b106ce141f60c186f749545c722e34i0/content');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          _imageData = response.bodyBytes;
        });
      } else {
        throw Exception('Failed to load image');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/bg.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: CustomNavBar(
          username: userController.user.walletAddress.substring(0,16),
          onAddPressed: () {},
          onMenuPressed: () {},
          onCopyPressed: () async {
            await Clipboard.setData(ClipboardData(text: controller.address!));
            Get.snackbar(
              'Copy Successful',
              'Wallet Address copied to clipboard',
              colorText: Colors.white,
            );
          },
        ),
        // appBar: AppBar(
        //   backgroundColor: Colors.black,
        //   foregroundColor: const Color(0xffb4914b),
        //   title: Text(controller.address!),
        //   actions: [
        //     IconButton(
        //       onPressed: () async {
        //         await Clipboard.setData(
        //             ClipboardData(text: controller.address!));
        //         Get.snackbar(
        //           'Copy Successful',
        //           'Wallet Address copied to clipboard',
        //           colorText: Colors.white,
        //         );
        //       },
        //       icon: const Icon(Icons.copy),
        //     ),
        //   ],
        // ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  
                  children: [
                    Container(
                      
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xffb4914b)),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          // Profile Picture and Upload Icon
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundImage:
                                    NetworkImage(userController.user.pfpUrl ?? ""),
                                backgroundColor: Colors.grey,
                              ),
                              //  SizedBox(width: 1.w),
                               
                
                              // const Icon(Icons.upload, color: Colors.white),
                            ],
                          ),
                           SizedBox(height: 1.h),
                          // User Name
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                          
                            children: [
                              Text(
                                userController.user.accountName,
                                style: TextStyle(
                                  color: const Color(0xffb4914b),
                                  fontSize: 19.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                           SizedBox(height: 0.4.h),
                          // User Bio
                          Text(
                            userController.user.bio,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.sp,
                            ),
                            textAlign: TextAlign.center,
                          ),
                           SizedBox(height: 3.h),
                          // Current Balance (Centered)
                          Column(
                            children: [
                              Text(
                                "Current Balance",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16.sp,
                                ),
                              ),
                              Text(
                                "${controller.balance ?? 0} Sats",
                                style: TextStyle(
                                  color: Color(0xffb4914b),
                                  fontSize: 21.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Price in USDT:     255\$",
                                style: TextStyle(
                                  color: Color(0xffb4914b),
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          // Send and Receive Buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xffb4914b),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                onPressed: () {},
                                icon: const Icon(Icons.arrow_upward),
                                label: const Text(" Send ", style: TextStyle(fontWeight: FontWeight.bold),),
                              ),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                onPressed: () {},
                                icon: const Icon(Icons.add),
                                label: const Text("Receive",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                     SizedBox(height: 4.h),
                    Container(
                       height: MediaQuery.of(context).size.height * 0.8, 
              
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(color: const Color(0xffb4914b)),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DefaultTabController(
                          length: 3,
                          child: Column(
                            children: [
                              ButtonsTabBar(
                                backgroundColor: Colors.transparent,
                                unselectedBackgroundColor: Colors.transparent,
                                contentPadding: EdgeInsets.only(
                                    top: 1.h, left: 5.w, right: 5.w),
                                labelStyle: const TextStyle(
                                  fontFamily: 'Cinzel',
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xffb4914b),
                                  decoration: TextDecoration.underline,
                                  decorationColor: Color(0xffb4914b),
                                  decorationThickness: 4,
                                  fontSize: 16,
                                ),
                                unselectedLabelStyle: TextStyle(
                                  fontFamily: 'Cinzel',
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w100,
                                  color: const Color(0xffb4914b),
                                ),
                                tabs: const [
                                  Tab(text: "TIMELINE"),
                                  Tab(text: "TOKENS"),
                                  Tab(text: "NFTS"),
                                ],
                              ),
                              Expanded(
                                  child: TabBarView(
                                    children: <Widget>[
                                      // Timeline Tab
                                      ListView.builder(
                                        itemCount: postController.posts.length,
                                        itemBuilder: (context, index) {
                                          final post = postController.posts[index];
                                          final date = DateTime.fromMillisecondsSinceEpoch(post.timestamp);
                                          final formattedDate = "${date.day}/${date.month}/${date.year}";
                                          return TimelineItem(
                                            index: index,
                                            imageUrl: post.imageUrl,
                                            timestamp: formattedDate,
                                          );
                                        },
                                      ),
                                      // Tokens Tab
                                      ListView.builder(
                                        itemCount: _results.length,
                                        itemBuilder: (context, index) {
                                          final result = _results[index];
                                          return ListTile(
                                            leading: Icon(Icons.monetization_on,
                                                color: Color(0xffb4914b)),
                                            title: Text(
                                              result['rune']['name'],
                                              style:
                                                  TextStyle(color: Color(0xffb4914b)),
                                            ),
                                            subtitle: Text(
                                              result['balance'] + " Sats",
                                              style: TextStyle(color: Colors.white70),
                                            ),
                                            trailing: Icon(
                                              Icons.info,
                                              color: Colors.white,
                                              size: 18,
                                            ),
                                          );
                                        },
                                      ),
                                      _isLoading
                                          ? const Center(
                                              child: CircularProgressIndicator())
                                          : InkWell(
                                            onTap: (){
                                              Get.to(NFTDetailsPage());
                                            },
                                            child: Image.memory(_imageData!),
                                              // NFTs Tab,
                                          )
                                      // ListView.builder(
                                      //   itemCount: 10, // Dummy data count
                                      //   itemBuilder: (context, index) {
                                      //     return NFTItem(index: index);
                                      //   },
                                      // ),
                                    ],
                                  ),
                                ),
                                
                              
                
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
                        ),
              ),
            ],
          ),
        ),
          ),
        );
      
    
  }
}
