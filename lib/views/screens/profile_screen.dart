import 'dart:convert';
import 'dart:io';
import 'package:alpha_go/controllers/timeline_post_controller.dart';
import 'package:alpha_go/controllers/user_controller.dart';
import 'package:alpha_go/controllers/wallet_controller.dart';
import 'package:alpha_go/views/screens/nft_details_screen.dart';
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
  bool _isLoading = true;
  List<Map<String, dynamic>> _results = [];
  Uint8List? _imageData;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await controller.fetchTransanctions();
      await _fetchRuneBalances();
      await _fetchImage();
    });
  }

  Future<double> getUsdtPrice() async {
    try {
      final response = await http.get(
        Uri.parse('https://rest.coinapi.io/v1/exchangerate/BTC/USD'),
        headers: {
          HttpHeaders.authorizationHeader:
              'D07A3A3B-7641-4158-B7F5-81A6FD8B3265',
        },
      );

      if (response.statusCode == 200) {
        // Decode the response body
        Map<String, dynamic> data = json.decode(response.body);

        // Extract the rate
        double rate = data['rate'];

        // Convert 2 satoshis to BTC and then to USD
        double priceInUsd = (controller.balance! / 100000000) * rate;

        return priceInUsd;
      } else {
        throw Exception('Failed to load exchange rate');
      }
    } catch (e) {
      return 0; // Return 0 or handle error appropriately
    }
  }


  Future<void> _fetchRuneBalances() async {
    final url = Uri.parse(
        'https://api.hiro.so/runes/v1/addresses/${controller.address ?? ""}/balances?offset=0');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        setState(() {
          _results = List<Map<String, dynamic>>.from(data['results'] ?? []);
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
          leadingWidget: Row(
            children: [
              Text(
                userController.user.walletAddress.substring(0, 14),
                style:  TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Color(0xffb4914b),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(
                      ClipboardData(text: userController.user.walletAddress));

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Username copied!")),
                  );
                },
                child:
                     Icon(Icons.copy, size: 18.sp, color: Color(0xffb4914b)),
              ),
            ],
          ),
          actionWidgets: Row(
            children: [
              IconButton(
                icon:  Icon(Icons.add_box,
                    size: 26.px, color: Color(0xffb4914b)),
                onPressed: () {},
              ),
              IconButton(
                icon:
                     Icon(Icons.menu, size: 29.px, color: Color(0xffb4914b)),
                onPressed: () {},
              ),
            ],
          ),
        ),
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(3.h),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: Stack(
                          children: [
                            Positioned(
                              right: 8,
                              top: 8,
                              child: IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.share),
                                color: const Color(0xffb4914b),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: const Color(0xffb4914b)),
                              ),
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    radius: 12.w,
                                    backgroundImage: NetworkImage(
                                        userController.user.pfpUrl ?? ""),
                                    backgroundColor: Colors.grey,
                                  ),
                                  SizedBox(height: 1.h),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        userController.user.accountName ?? "User",
                                        style: TextStyle(
                                          color: const Color(0xffb4914b),
                                          fontSize: 19.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 0.4.h),
                                  Text(
                                    userController.user.bio ?? "",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15.sp,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 3.h),
                                  FutureBuilder<double>(
                                    future: getUsdtPrice(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return const CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        return Text(
                                          'Error: ${snapshot.error}',
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 15.sp,
                                          ),
                                        );
                                      } else {
                                        final price = snapshot.data ?? 0;
                                        return Column(
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
                                                color: const Color(0xffb4914b),
                                                fontSize: 21.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              "Price in USDT: $price\$",
                                              style: TextStyle(
                                                color: const Color(0xffb4914b),
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                    },
                                  ),
                                  SizedBox(height: 3.h),
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
                                        label: const Text(
                                          "Send",
                                          style:
                                              TextStyle(fontWeight: FontWeight.bold),
                                        ),
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
                                        label: const Text(
                                          "Receive",
                                          style:
                                              TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: Padding(
            padding: EdgeInsets.all(2.h),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.black,
                border: Border(
                  top: BorderSide(color: Color(0xffb4914b)),
                  left: BorderSide(color: Color(0xffb4914b)),
                  right: BorderSide(color: Color(0xffb4914b)),
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: DefaultTabController(
                length: 3,
                child: Column(
                  children: [
                    ButtonsTabBar(
                      backgroundColor: Colors.transparent,
                      unselectedBackgroundColor: Colors.transparent,
                      contentPadding:
                          EdgeInsets.only(top: 1.h, left: 5.w, right: 5.w),
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
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: postController.posts.length,
                            itemBuilder: (context, index) {
                              final post = postController.posts[index];
                              final date = DateTime.fromMillisecondsSinceEpoch(
                                  post.timestamp);
                              final formattedDate =
                                  "${date.day}/${date.month}/${date.year}";
                              return TimelineItem(
                                index: index,
                                imageUrl: post.imageUrl,
                                timestamp: formattedDate,
                              );
                            },
                          ),
                          ListView.builder(
                            itemCount: _results.length,
                            itemBuilder: (context, index) {
                              final token = _results[index];
                              return ListTile(
                                title: Text(token['ticker'] ?? ""),
                                subtitle:
                                    Text("Balance: ${token['balance'] ?? 0}"),
                              );
                            },
                          ),
                          _imageData != null
                              ? GestureDetector(
                                  onTap: () {
                                    Get.to(() => NFTDetailsPage(
                                          imageData: _imageData,
                                        ));
                                  },
                                  child: Image.memory(_imageData!),
                                )
                              : const Center(
                                  child: CircularProgressIndicator(),
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
