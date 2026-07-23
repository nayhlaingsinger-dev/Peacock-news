import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/app/routes.dart';
import 'package:news/cubits/appLocalizationCubit.dart';
import 'package:news/cubits/breakingNewsCubit.dart';
import 'package:news/cubits/slugNewsCubit.dart';
import 'package:news/data/models/BreakingNewsModel.dart';
import 'package:news/data/models/NewsModel.dart';
import 'package:news/utils/strings.dart';
import 'package:news/utils/uiUtils.dart';

//TODO: if change in API calls or variables, change the same in Dashboard screen > initDynamicLinks()
class LoadingScreen extends StatefulWidget {
  String routeSettingsName;
  String newsSlug;

  LoadingScreen({required this.routeSettingsName, required this.newsSlug, Key? key}) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    await Future.delayed(Duration(seconds: 2)); // Simulate API delay
    if (widget.routeSettingsName.contains('/news/')) {
      //for news
      UiUtils.rootNavigatorKey.currentContext
          ?.read<SlugNewsCubit>()
          .getSlugNews(langId: UiUtils.rootNavigatorKey.currentContext!.read<AppLocalizationCubit>().state.id, newsSlug: widget.newsSlug)
          .then((value) {
        NewsModel? model = (value[DATA] as List).map((e) => NewsModel.fromJson(e)).toList().first;
        Navigator.popAndPushNamed(context, Routes.newsDetails,
            arguments: {"model": model, "slug": widget.newsSlug, "isFromBreak": widget.routeSettingsName.contains('/breaking-news/') ? true : false, "fromShowMore": false});
      });
    } else if (widget.routeSettingsName.contains('/breaking-news/')) {
      //for breaking news
      UiUtils.rootNavigatorKey.currentContext?.read<BreakingNewsCubit>().getBreakingNews(langId: UiUtils.rootNavigatorKey.currentContext!.read<AppLocalizationCubit>().state.id).then((value) {
        BreakingNewsModel? brModel = value[0];
        Navigator.of(context).pushReplacementNamed(Routes.newsDetails, arguments: {"breakModel": brModel, "slug": widget.newsSlug, "isFromBreak": true, "fromShowMore": false});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
