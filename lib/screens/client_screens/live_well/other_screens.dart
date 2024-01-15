import 'package:flutter/material.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';

class OtherLiveWellScreens extends StatelessWidget {
  final String appBarTitle;
  const OtherLiveWellScreens({required this.appBarTitle, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  CustomAppBar(appBarTitle: appBarTitle),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 20,
                  mainAxisExtent: 166,
                  childAspectRatio: 1 / 0.55,
                ),
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            'https://imgs.search.brave.com/eYF4sjJtIwGXSsBVCROThrjMHRBxt4X_Bv_FggpFUY4/rs:fit:1200:1200:1/g:ce/aHR0cHM6Ly93d3cu/Ymlnc3RyaWR6LmNv/bS93cC1jb250ZW50/L3VwbG9hZHMvMjAx/OS8wMi9zdGFydC1h/LW1lZGl0YXRpb24t/cHJhY3RpY2UuanBl/Zw',
                            height: 100,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Headline',
                        style: Theme.of(context).textTheme.labelMedium,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'Author',
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        '10 mins',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: Colors.grey,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
