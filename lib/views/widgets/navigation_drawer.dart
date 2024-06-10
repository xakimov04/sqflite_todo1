import 'package:experensies/views/screens/login_page/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 30, top: 90, bottom: 55),
          color: const Color(0xff041955),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: const BoxDecoration(
                  color: Color(0xffEB06FF),
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xff0A215E),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: CircleAvatar(
                        backgroundImage: AssetImage('images/image.png'),
                        radius: 40,
                      ),
                    ),
                  ),
                ),
              ),
              const Gap(20),
              const Text(
                'John\nDepler',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Gap(50),
              _buildDrawerItem(Icons.grid_view, 'Home', () {}),
              _buildDrawerItem(
                  Icons.admin_panel_settings_outlined, 'Admin Page', () {}),
              _buildDrawerItem(
                  CupertinoIcons.settings_solid, 'Settings', () {}),
              _buildDrawerItem(
                Icons.login_rounded,
                'Log Out',
                () {
                 
                },
              ),
              const Spacer(),
              const Text(
                "Good",
                style: TextStyle(fontSize: 15, color: Color(0xff354B8C)),
              ),
              const Text(
                'Consistancy',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 45,
          right: 30,
          bottom: 140,
          child: Image.asset(
            fit: BoxFit.fill,
            "images/line.png",
            height: 50,
            // width: 250,
          ),
        ),
      ],
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 25,
            ),
            const Gap(20),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
