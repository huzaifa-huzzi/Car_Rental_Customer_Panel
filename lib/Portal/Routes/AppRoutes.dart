import 'package:car_rental_customerPanel/Autentication/Login/Login.dart';
import 'package:car_rental_customerPanel/Portal/SideScreen/SideScreen.dart';
import 'package:car_rental_customerPanel/Portal/Vendor/Payment/Payment.dart';
import 'package:car_rental_customerPanel/Portal/Vendor/Payment/Subtabs/PaymentDetails.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';




class AppNavigation {
  static final router = GoRouter(
    initialLocation: '/login',
    routes: [
       GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      ///  SHELL ROUTE (With Sidebar Layout)
      ShellRoute(
        builder: (context, state, child) {
          final extras = state.extra as Map<String, dynamic>?;
          bool hideMobile = extras?["hideMobileAppBar"] == true;

          final String path = state.uri.toString().toLowerCase();
          if (path.contains('add') ||
              path.contains('edit') ||
              path.contains('detail')) {
            hideMobile = true;
          }

          return SidebarScreen(
            onTap: (route) {
              context.go(route);
            },
            hideMobileAppBar: hideMobile,
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: '/payment',
            builder: (context, state) => const PaymentScreen(),
          ),
          GoRoute(
            path: '/payment/detail',
            builder: (context, state) => const PaymentDetail(),
          ),
        ],
      ),
    ],
  );

  ///  WRAP SIDEBAR
  static Widget _wrapSidebar(GoRouterState state, Widget child) {
    final extras = state.extra as Map<String, dynamic>?;

    bool hideMobile = extras?["hideMobileAppBar"] == true;
    final String path = state.uri.toString().toLowerCase();
    if (path.contains('add') ||
        path.contains('edit') ||
        path.contains('detail')) {
      hideMobile = true;
    }

    return SidebarScreen.wrapWithSidebarIfNeeded(
      child: child,
      hideMobileAppBar: hideMobile,
    );
  }
}