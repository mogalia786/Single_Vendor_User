import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
//import 'package:user_app/Widgets/footer_widget.dart';
import 'package:user_app/Widgets/profile_widget.dart';
import 'package:user_app/Widgets/web_menu.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: AdaptiveTheme.of(context).mode.isDark == true
          ? null
          : const Color.fromARGB(255, 247, 240, 240),
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(
            fontWeight: FontWeight.bold,
          ),).tr(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(0),
              child: Column(
                children: [
                  const Gap(20),
                  if (MediaQuery.of(context).size.width >= 1100)
                    Align(
                      alignment: MediaQuery.of(context).size.width >= 1100
                          ? Alignment.centerLeft
                          : Alignment.center,
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              context.push('/');
                            },
                            child: const Text(
                              'Home',
                              style: TextStyle(fontSize: 10),
                            ).tr(),
                          ),
                          const Text(
                            '/ My Profile',
                            style: TextStyle(fontSize: 10),
                          ).tr(),
                        ],
                      ),
                    ),
                  Align(
                    alignment: MediaQuery.of(context).size.width >= 1100
                        ? Alignment.centerLeft
                        : Alignment.center,
                    child: const Text(
                      'Account Information',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ).tr(),
                  ),
                  const Gap(20),
                ],
              ),
            ),
            MediaQuery.of(context).size.width >= 1100
                ? const Padding(
                    padding: EdgeInsets.only(left: 100, right: 100),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Card(
                              shape: BeveledRectangleBorder(),
                              color: Colors.white,
                              surfaceTintColor: Colors.white,
                              child: WebMenu(path: '/profile')),
                        ),
                        Gap(20),
                        Expanded(
                            flex: 6,
                            child: Card(
                              shape: BeveledRectangleBorder(),
                              color: Colors.white,
                              surfaceTintColor: Colors.white,
                              child: SingleChildScrollView(
                                child: ProfileWidget(),
                              ),
                            ))
                      ],
                    ),
                  )
                : const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: ProfileWidget(),
                  ),
            const Gap(20),
            //const FooterWidget()
          ],
        ),
      ),
    );
  }
}
