import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CarouselView extends StatelessWidget {
  const CarouselView({super.key});

  List<String> _createImageList() {
    return [
      'https://talkstar-photos.s3.amazonaws.com/uploads/be32b1d2-5661-42c0-b526-5505b85ea452/GabrielMarmentini_2023S-embed.jpg',
      'https://talkstar-assets.s3.amazonaws.com/production/talks/talk_128545/83c23708-f025-4895-a19e-8c59faa5febc/corruptiontextless300.jpg',
      'https://talkstar-assets.s3.amazonaws.com/production/talks/talk_126809/83dfb64b-9c47-4e07-bb21-bd2305b73c8e/Erysichthontextless.jpg',
      'https://talkstar-photos.s3.amazonaws.com/uploads/4c9d3eae-ee1f-4f19-a793-e48723726914/MatthewEbert_2024S-embed.jpg',
      'https://talkstar-photos.s3.amazonaws.com/uploads/fcfd33ec-5c24-480a-8b4a-fb703a8bb5a8/DyhiaBelhabib_2023W-embed.jpg',
      'https://talkstar-assets.s3.amazonaws.com/production/talks/talk_126099/33d06b0e-1df0-4e7e-b20d-98a5cf4830c8/angertextless.jpg',
      'https://talkstar-photos.s3.amazonaws.com/uploads/1789f5bb-07bd-415a-93b3-02f0b9b49535/SuleikaJaouad_2024H-embed.jpg',
      'https://talkstar-photos.s3.amazonaws.com/uploads/e295bf7e-3ac2-48e0-94f5-9d712fe175c0/EshaChhabra_2023W-embed.jpg',
      'https://talkstar-photos.s3.amazonaws.com/uploads/e1f29b45-cbd4-4283-8c61-5913bb2ffbc3/ChristineSchulerDeschryver_2023W-embed.jpg',
      'https://talkstar-photos.s3.amazonaws.com/uploads/a102abc7-9b62-4f88-81fd-9142340ffc49/SlavaBalbek_2023S-embed.jpg',
    ];
  }

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        enlargeCenterPage: true,
        enableInfiniteScroll: false,
        viewportFraction: 0.7,
      ),
      items: _createImageList()
          .map(
            (item) => SizedBox(
              child: Image.network(
                item,
                fit: BoxFit.fill,
              ),
            ),
          )
          .toList(),
    );
  }
}
