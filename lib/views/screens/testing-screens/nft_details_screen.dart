import 'package:alpha_go/views/widgets/NFT_card_widget.dart';
import 'package:alpha_go/views/widgets/golden_button.dart';
import 'package:alpha_go/views/widgets/navbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class NFTDetailsPage extends StatelessWidget {

  const NFTDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
final String NftDescription = 'This is a detailed description of the NFT. '
        'It includes information about its creation, significance, and other relevant details.\n\n'
        'The NFT was created by a renowned digital artist known for their unique style and innovative approach. '
        'Each piece in this collection is a one-of-a-kind digital artwork that has been meticulously crafted to showcase the artist\'s vision.\n\n'
        'Significance: This NFT represents a significant milestone in the world of digital art. '
        'It symbolizes the fusion of technology and creativity, pushing the boundaries of what is possible in the digital realm.\n\n'
        'Additional Details: The NFT is stored on a secure blockchain, ensuring its authenticity and provenance. '
        'Collectors can rest assured that they are acquiring a genuine piece of digital art that will hold its value over time.';    return  Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomNavBar(username: '0XFFE3FDCFS33S..', onAddPressed: (){}, onMenuPressed: (){}, onCopyPressed: (){}),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
  decoration: BoxDecoration(
    border: Border.all(
      color: Colors.amber, // Golden color
      width: 1,           // Border thickness
    ),
    borderRadius: BorderRadius.circular(16), // Match the ClipRRect border radius
  ),
  child: ClipRRect(
    borderRadius: BorderRadius.circular(16),
    child: Image.network(
      'https://images.unsplash.com/photo-1732461380169-fd49843d91af?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHwxM3x8fGVufDB8fHx8fA%3D%3D',
      width: 100.w,
      height: 40.h,
      fit: BoxFit.cover,
    ),
  ),
),
              SizedBox(height: 16.0),
              Text(
                 
                 'The ORBITANS',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Color(0xffb4914b)),
              ),
              SizedBox(height: 1.h),
              Text(
                'Minted on Sep30, 2022',
                style: TextStyle(fontSize: 14.px, color: Color.fromARGB(255, 168, 168, 167)),
              ),
              SizedBox(height: 4.h),
              Column(
                crossAxisAlignment:CrossAxisAlignment.start ,
                children: [ 
                  Text('Created By',  style:
                          TextStyle(fontSize: 14.px, color: Color(0xffb4914b))),
                           SizedBox(height: 1.h),
                  Row(
                    children: [
                      CircleAvatar(
  radius: 10, // Adjust the radius as needed
  backgroundImage: NetworkImage('https://example.com/profile.jpg'), // Replace with your image URL
  backgroundColor: Colors.grey, // Fallback color if the image is not available
),
SizedBox(width: 2.w,),
Text('Dish Studio', style: TextStyle(fontSize: 16.px, color: Color(0xffb4914b))),
                      
                    ],
                  )
                ],
              ),
               SizedBox(height: 4.h),
              Text(
              NftDescription,
                style: TextStyle(fontSize: 16.px,color:  const Color.fromARGB(255, 194, 193, 193),)),
              
              SizedBox(height: 6.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GoldenButton(text: ' Buy Now ', onPressed: (){}),
                ],
              ),
              SizedBox(height: 10.h),
              Text(
                'Similar NFTs',
                style: TextStyle(fontSize: 16.px, fontWeight: FontWeight.bold, color: Color(0xffb4914b)),
              ),
              SizedBox(height: 4.h),
              // Add a list of recommended NFTs here
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 5, // Number of recommended NFTs
                itemBuilder: (context, index) {
                  return CardNFT(nftName: 'RandomNft', creator: 'RandomCreator', imageUrl: 'https://images.unsplash.com/photo-1732461380169-fd49843d91af?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHwxM3x8fGVufDB8fHx8fA%3D%3D', description: 'RandomDescription');
                },
              ),
              
            ],
          ),
        ),
      ),
    );
  }
} 