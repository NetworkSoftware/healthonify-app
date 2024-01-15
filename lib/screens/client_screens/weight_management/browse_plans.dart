import 'package:flutter/material.dart';
import 'package:healthonify_mobile/screens/client_screens/weight_management/plans_list.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';

class BrowseWmPlans extends StatelessWidget {
  const BrowseWmPlans({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List imgUrls = [
      'https://imgs.search.brave.com/uhQy4_QjAxPhavtwuE05aEdSjyz0zLPVhiCGjCqkra0/rs:fit:1200:824:1/g:ce/aHR0cHM6Ly93d3cu/YmxhY2tiZXJyeWNs/aW5pYy5jby51ay93/cC1jb250ZW50L3Vw/bG9hZHMvMjAxOS8x/MS9XZWlnaHQtTWFu/YWdlbWVudC5qcGc',
      'https://imgs.search.brave.com/P3BuzhHJE9EPQsOwkxZLnqxQ9eY4BCNc5qkQMqNaboE/rs:fit:1200:1131:1/g:ce/aHR0cDovL3BpZWRt/b250aGVhbHRoY2Fy/ZS5jb20vd3AtY29u/dGVudC91cGxvYWRz/LzIwMTYvMDEvcGll/ZG1vbnQtaGVhbHRo/Y2FyZS13ZWlnaHQt/bWFuYWdlbWVudC5q/cGc',
      'https://imgs.search.brave.com/atnaB4u9u1uKVrhjrDLN5K1-OQ4eIl5-Lterprx3HeM/rs:fit:1200:1200:1/g:ce/aHR0cHM6Ly93d3cu/bnV0cmlwcm9jYW4u/Y2Evd3AtY29udGVu/dC91cGxvYWRzLzIw/MjAvMDUvV2VpZ2h0/TG9zcy1zY2FsZWQu/anBlZw',
      'https://imgs.search.brave.com/GDF2qBZyloBQJRjYymC0sj3l8p_-1Rb5ux7GEIDw4Ss/rs:fit:1024:576:1/g:ce/aHR0cHM6Ly93d3cu/YmVzdGhlYWx0aG1h/Zy5jYS93cC1jb250/ZW50L3VwbG9hZHMv/c2l0ZXMvMTYvMjAx/OC8wMy9Zb2dhLWZv/ci1XZWlnaHQtTG9z/cy0xMDI0eDU3Ni5q/cGc',
    ];
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'View Plans'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'Select Services',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              ListView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: imgUrls.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Card(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return const WmPlansList();
                          }));
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            imgUrls[index],
                            height: 160,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
