import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'views/home_view.dart';
import 'theme/app_theme.dart';
import 'theme/theme_provider.dart';
import 'viewmodels/task_list_viewmodel.dart';
import 'services/language_service.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const TaskManagerApp());
}

class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskListViewModel()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LanguageService()),
      ],
      child: Consumer2<ThemeProvider, LanguageService>(
        builder: (context, themeProvider, languageService, _) {
          return MaterialApp(
            title: 'Task Manager',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            locale: languageService.locale,
            supportedLocales: const [
              Locale('en', ''), // Inglés
              Locale('es', ''), // Español
            ],
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: const HomeView(),
          );
        }
      ),
    );
  }
}
