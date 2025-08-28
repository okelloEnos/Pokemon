// // import 'package:example/other/refresh_glowindicator.dart';
// // import 'package:example/ui/MainActivity.dart';
// // import 'package:example/ui/SecondActivity.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:pokemon/pokemons/data/repository/fer.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';
// // import 'ui/indicator/base/IndicatorActivity.dart';
// // import 'package:flutter_localizations/flutter_localizations.dart';
//
// void main() => runApp(MyApp());
//
// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return RefreshConfiguration(
//       footerTriggerDistance: 15,
//       dragSpeedRatio: 0.91,
//       headerBuilder: () => MaterialClassicHeader(),
//       footerBuilder: () => ClassicFooter(),
//       enableLoadingWhenNoData: false,
//       enableRefreshVibrate: false,
//       enableLoadMoreVibrate: false,
//       shouldFooterFollowWhenNotFull: (state) {
//         // If you want load more with noMoreData state ,may be you should return false
//         return false;
//       },
//       child: MaterialApp(
//         title: 'Pulltorefresh Demo',
//         debugShowCheckedModeBanner: false,
//         builder: (context, child) {
//           return ScrollConfiguration(
//             child: child ?? Container(),
//             behavior: RefreshScrollBehavior(),
//           );
//         },
//         theme: ThemeData(
//           // This is the theme of your application.
//           //s
//           // Try running your application with "flutter run". You'll see the
//           // application has a blue toolbar. Then, without quitting the app, try
//           // changing the primarySwatch below to Colors.green and then invoke
//           // "hot reload" (press "r" in the console where you ran "flutter run",
//           // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
//           // counter didn't reset back to zero; the application is not restarted.
//             primarySwatch: Colors.blue,
//             primaryColor: Colors.greenAccent),
//         localizationsDelegates: [
//           RefreshLocalizations.delegate,
//           // GlobalWidgetsLocalizations.delegate,
//           // GlobalMaterialLocalizations.delegate,
//           // GlobalCupertinoLocalizations.delegate
//         ],
//         supportedLocales: [
//           const Locale('en'),
//           const Locale('zh'),
//           const Locale('ja'),
//           const Locale('uk'),
//           const Locale('it'),
//           const Locale('ru'),
//           const Locale('fr'),
//           const Locale('es'),
//           const Locale('nl'),
//           const Locale('sv'),
//           const Locale('pt'),
//           const Locale('ko'),
//         ],
//         locale: const Locale('zh'),
//         localeResolutionCallback: (Locale? locale, Iterable<Locale> supportedLocales) {
//           //print("change language");
//           return locale;
//         },
//         home: const PokemonAppExample(),
//         // routes: {
//         //   "sec": (BuildContext context) {
//         //     return SecondActivity(
//         //       title: "SecondAct",
//         //     );
//         //   },
//         //   "indicator": (BuildContext context) {
//         //     return IndicatorActivity();
//         //   }
//         // },
//       ),
//     );
//   }
// }
//
// /*
//  * Author: Jpeng
//  * Email: peng8350@gmail.com
//  * Time:  2019-09-08 14:44
//  */
//
// // import 'package:flutter/material.dart';
//
// // 在不自定义的默认情况下,当你拖到顶端不能再拖的时候会出现光晕,假如你只想在撞击顶部时看到光晕的情况
// // 以下例子就是可以解决这种问题
//
// // Android平台 自定义刷新光晕效果
// class RefreshScrollBehavior extends ScrollBehavior {
//   @override
//   Widget buildViewportChrome(
//       BuildContext context, Widget child, AxisDirection axisDirection) {
//     // When modifying this function, consider modifying the implementation in
//     // _MaterialScrollBehavior as well.
//     switch (getPlatform(context)) {
//       case TargetPlatform.iOS:
//         return child;
//       case TargetPlatform.macOS:
//       case TargetPlatform.android:
//         return GlowingOverscrollIndicator(
//           child: child,
//           // this will disable top Bouncing OverScroll Indicator showing in Android
//           showLeading: true, //顶部水波纹是否展示
//           showTrailing: true, //底部水波纹是否展示
//           axisDirection: axisDirection,
//           notificationPredicate: (notification) {
//             if (notification.depth == 0) {
//               // 越界了拖动触发overScroll的话就没必要展示水波纹
//               if (notification.metrics.outOfRange) {
//                 return false;
//               }
//               return true;
//             }
//             return false;
//           },
//           color: Theme.of(context).primaryColor,
//         );
//       case TargetPlatform.fuchsia:
//       case TargetPlatform.linux:
//       case TargetPlatform.windows:
//     }
//     return GlowingOverscrollIndicator(
//       child: child,
//       // this will disable top Bouncing OverScroll Indicator showing in Android
//       showLeading: true, //顶部水波纹是否展示
//       showTrailing: true, //底部水波纹是否展示
//       axisDirection: axisDirection,
//       notificationPredicate: (notification) {
//         if (notification.depth == 0) {
//           // 越界了拖动触发overScroll的话就没必要展示水波纹
//           if (notification.metrics.outOfRange) {
//             return false;
//           }
//           return true;
//         }
//         return false;
//       },
//       color: Theme.of(context).primaryColor,
//     );
//   }
// }