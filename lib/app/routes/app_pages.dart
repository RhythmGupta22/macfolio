// 📁 lib/app/routes/app_pages.dart
import 'package:get/get.dart';

import '../modules/about_me/bindings/about_me_binding.dart';
import '../modules/about_me/views/about_me_view.dart';
import '../modules/all_apps/bindings/all_apps_binding.dart';
import '../modules/all_apps/views/all_apps_view.dart';
import '../modules/calculator/bindings/calculator_binding.dart';
import '../modules/calculator/views/calculator_view.dart';
import '../modules/contacts/bindings/contacts_binding.dart';
import '../modules/contacts/views/contacts_view.dart';
import '../modules/desktop/bindings/desktop_binding.dart';
import '../modules/desktop/views/desktop_view.dart';
import '../modules/finder/bindings/finder_binding.dart';
import '../modules/finder/views/finder_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/music/bindings/music_binding.dart';
import '../modules/music/views/music_view.dart';
import '../modules/photos/bindings/photos_binding.dart';
import '../modules/photos/views/photos_view.dart';
import '../modules/skills/bindings/skills_binding.dart';
import '../modules/skills/views/skills_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/terminal/bindings/terminal_binding.dart';
import '../modules/terminal/views/terminal_view.dart';
import '../modules/trash/bindings/trash_binding.dart';
import '../modules/trash/views/trash_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.DESKTOP,
      page: () => const DesktopView(),
      binding: DesktopBinding(),
    ),
    GetPage(
      name: Routes.FINDER,
      page: () => const FinderView(),
      binding: FinderBinding(),
    ),
    GetPage(
      name: Routes.ALL_APPS,
      page: () => const AllAppsView(),
      binding: AllAppsBinding(),
    ),
    GetPage(
      name: Routes.CONTACTS,
      page: () => const ContactsView(),
      binding: ContactsBinding(),
    ),
    GetPage(
      name: Routes.MUSIC,
      page: () => const MusicView(),
      binding: MusicBinding(),
    ),
    GetPage(
      name: Routes.CALCULATOR,
      page: () => const CalculatorView(),
      binding: CalculatorBinding(),
    ),
    GetPage(
      name: Routes.PHOTOS,
      page: () => const PhotosView(),
      binding: PhotosBinding(),
    ),
    GetPage(
      name: Routes.SKILLS,
      page: () => const SkillsView(),
      binding: SkillsBinding(),
    ),
    GetPage(
      name: Routes.TERMINAL,
      page: () => const TerminalView(),
      binding: TerminalBinding(),
    ),
    GetPage(
      name: Routes.ABOUT_ME,
      page: () => const AboutMeView(),
      binding: AboutMeBinding(),
    ),
    GetPage(
      name: Routes.TRASH,
      page: () => const TrashView(),
      binding: TrashBinding(),
    ),
  ];
}
