import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_app/user_management/landing_page.dart';
import 'package:my_app/user_management/login_page.dart';
import 'package:my_app/user_management/signup_page.dart';

class Routers {
  GoRouter router = GoRouter(routes: [
    GoRoute(
        name: 'loginPage',
        path: '/login',
        pageBuilder: (context, state) {
          return const MaterialPage(child: LoginPage());
        }),
    GoRoute(
        name: 'signup',
        path: '/signup',
        pageBuilder: (context, state) {
          return const MaterialPage(child: SignUpPage());
        }),
    GoRoute(
        name: 'landinPage',
        path: '/',
        pageBuilder: (context, state) {
          return const MaterialPage(child: LandingPage());
        }),
  ]);
}
