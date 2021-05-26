import 'package:flutter/material.dart';
import 'package:shop_app_bloc/modules/login/login_screen.dart';
import 'package:shop_app_bloc/shared/network/local/cache_helper.dart';
import 'package:shop_app_bloc/shared/styles/colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BoardingModel {
  String image;
  String title;
  String subTitle;
  BoardingModel({
    this.image,
    this.title,
    this.subTitle,
  });
}

class OnBoardingScreen extends StatefulWidget {
  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  var boardController = PageController();

  bool _isFinished = false;

  final List<BoardingModel> boardingList = [
    BoardingModel(
      image: 'assets/images/onboarding_image2.png',
      title: 'Buy & Sell',
      subTitle: 'Browse the menu and order directly from the application',
    ),
    BoardingModel(
      image: 'assets/images/fav.png',
      title: 'Find favorite items',
      subTitle: 'find your favorite products easily',
    ),
    BoardingModel(
      image: 'assets/images/delivary.png',
      title: 'Delivery',
      subTitle: 'Pick up delivery at your door and enjoy groceries',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.only(
            left: 25,
            right: 25,
            top: 20,
            bottom: 35,
          ),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  onPageChanged: (index) {
                    if (index == boardingList.length - 1) {
                      setState(() {
                        _isFinished = true;
                      });
                    } else {
                      setState(() {
                        _isFinished = false;
                      });
                    }
                  },
                  controller: boardController,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) =>
                      _buildBoardingItem(boardingList[index]),
                  itemCount: 3,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  SmoothPageIndicator(
                    controller: boardController,
                    count: 3,
                    axisDirection: Axis.horizontal,
                    effect: ExpandingDotsEffect(
                      expansionFactor: 1.5,
                      spacing: 5.0,
                      //  radius: 4.0,
                      dotWidth: 12.0,
                      dotHeight: 10.0,
                      //  paintStyle: PaintingStyle.fill,
                      strokeWidth: 1.5,
                      dotColor: Colors.grey,
                      activeDotColor: primaryColor,
                    ),
                  ),
                  Spacer(),
                  FloatingActionButton(
                    onPressed: () {
                      if (_isFinished) {
                        onSubmit();
                      }

                      boardController.nextPage(
                        duration: Duration(milliseconds: 700),
                        curve: Curves.fastLinearToSlowEaseIn,
                      );
                    },
                    // backgroundColor: Colors.redAccent,
                    child: Icon(Icons.arrow_forward_ios),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  //   ),
  // );

  Widget _buildBoardingItem(BoardingModel model) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Spacer(),
              TextButton(
                onPressed: onSubmit,
                child: Text(
                  'SKIP',
                  style: TextStyle(
                    fontSize: 20,
                    color: primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          Spacer(),
          Image.asset(model.image),
          Spacer(),
          Text(
            model.title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            model.subTitle,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      );

  void onSubmit() {
    CacheHelper.saveData(key: 'onBoardingFinished', data: true).then((value) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
      );
    });
  }
}
