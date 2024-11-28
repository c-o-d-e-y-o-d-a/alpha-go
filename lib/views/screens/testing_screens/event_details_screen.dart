import 'package:alpha_go/models/event_model.dart';
import 'package:alpha_go/models/user_model.dart';
import 'package:alpha_go/views/widgets/nft_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class EventDetailsPage extends StatelessWidget {
  final EventModel event;
  final List<WalletUser> hosts;
  const EventDetailsPage({super.key, required this.event, required this.hosts});

  @override
  Widget build(BuildContext context) {
    const String eventDescription =
        'Join us for an exclusive event where innovation meets creativity. '
        'Discover the future of digital experiences and network with top industry leaders.\n\n'
        'This event will showcase cutting-edge technologies, immersive workshops, and inspiring keynote speeches. '
        'Whether you are a tech enthusiast, an artist, or an entrepreneur, this is an opportunity to connect and grow.\n\n'
        'Event Highlights:\n- Keynote by renowned speakers\n- Interactive workshops\n- Exclusive NFT rewards';

     String eventDetails = 'Name of Event: ${event.eventName}+\n'
        'Venue: ${event.locationName}\n'
        'Cost: ${event.cost}\n';

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Event Details',
          style: TextStyle(color: Colors.amber),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event Image with Golden Border
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.amber,
                    width: 3.sp,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    event.imageUrl,
                    width: 100.w,
                    height: 40.h,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),

              // Event Title
              Text(
                event.eventName,
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xffb4914b),
                ),
              ),
              SizedBox(height: 1.h),

              // Event Date and Venue
              Text(
                "${event.startTime}-${event.endTime} | ${event.locationName}",
                style: TextStyle(
                  fontSize: 14.px,
                  color: const Color(0xffb4914b),
                ),
              ),
              SizedBox(height: 4.h),

              // Description
              Text(
                event.description,
                style: TextStyle(
                  fontSize: 16.px,
                  color: const Color.fromARGB(255, 194, 193, 193),
                ),
              ),
              SizedBox(height: 4.h),

              // Event Details Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(color: Colors.amber, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Event Details',
                      style: TextStyle(
                        fontSize: 16.px,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xffb4914b),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      eventDetails,
                      style: TextStyle(
                        fontSize: 14.px,
                        color: const Color(0xffb4914b),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 4.h),

              // Registration Button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffb4914b),
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 32),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      // Handle registration
                    },
                    child: const Text(
                      'Register Now',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6.h),

              // Similar NFTs Section
              Text(
                'NFTs You Might Get',
                style: TextStyle(
                  fontSize: 16.px,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xffb4914b),
                ),
              ),
              SizedBox(height: 4.h),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 3, // Number of NFTs
                itemBuilder: (context, index) {
                  return CardNFT(
                    nftName: 'Exclusive NFT $index',
                    creator: 'Event Creator',
                    imageUrl:
                        'https://plus.unsplash.com/premium_photo-1671997600458-00d572868c4d?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NXx8bmZ0fGVufDB8fDB8fHww',
                    description:
                        'This is an exclusive NFT for attendees of this event.',
                  );
                },
              ),
              SizedBox(height: 6.h),
            ],
          ),
        ),
      ),
    );
  }
}
