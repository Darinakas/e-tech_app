import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/locale_provider.dart';
import 'edit_profile_page.dart';
import 'login_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  void _deleteAccount(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        await user.delete();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.accountDeleted)),
        );

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
              (route) => false,
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'requires-recent-login') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)!.reloginRequired)),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error: ${e.message}")),
          );
        }
      }
    }
  }

  void _confirmDelete(BuildContext context, AppLocalizations localizations) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(localizations.deleteAccount),
        content: Text(localizations.deleteAccountConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(localizations.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _deleteAccount(context);
            },
            child: Text(
              localizations.delete,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);
    final user = FirebaseAuth.instance.currentUser;
    final localizations = AppLocalizations.of(context)!;

    String getCurrentLanguageName(String code) {
      switch (code) {
        case 'ru':
          return localizations.russian;
        case 'kk':
          return localizations.kazakh;
        default:
          return localizations.english;
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text(localizations.settings)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(localizations.editProfile),
            subtitle: Text(user?.displayName ?? "User"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditProfilePage(
                    username: user?.displayName ?? "",
                    phone: user?.phoneNumber ?? "",
                    address: "Astana, Kazakhstan",
                  ),
                ),
              );

              if (result != null && result is Map) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(localizations.profileUpdated)),
                );
              }
            },
          ),
          const Divider(),

          ListTile(
            leading: const Icon(Icons.color_lens),
            title: Text(localizations.darkMode),
            subtitle: Text(
              [
                "Light Theme",
                "Dark Theme",
                "Purple Theme"
              ][themeProvider.themeIndex],
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => SimpleDialog(
                  title: Text(localizations.darkMode),
                  children: [
                    SimpleDialogOption(
                      child: const Text("Light Theme"),
                      onPressed: () {
                        themeProvider.setTheme(0);
                        Navigator.pop(context);
                      },
                    ),
                    SimpleDialogOption(
                      child: const Text("Dark Theme"),
                      onPressed: () {
                        themeProvider.setTheme(1);
                        Navigator.pop(context);
                      },
                    ),
                    SimpleDialogOption(
                      child: const Text("Purple Theme"),
                      onPressed: () {
                        themeProvider.setTheme(2);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          const Divider(),

          ListTile(
            leading: const Icon(Icons.language),
            title: Text(localizations.language),
            subtitle: Text(
              getCurrentLanguageName(localeProvider.locale.languageCode),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => SimpleDialog(
                  title: Text(localizations.language),
                  children: [
                    SimpleDialogOption(
                      child: Text(localizations.english),
                      onPressed: () {
                        localeProvider.setLocale(const Locale('en'));
                        Navigator.pop(context);
                      },
                    ),
                    SimpleDialogOption(
                      child: Text(localizations.russian),
                      onPressed: () {
                        localeProvider.setLocale(const Locale('ru'));
                        Navigator.pop(context);
                      },
                    ),
                    SimpleDialogOption(
                      child: Text(localizations.kazakh),
                      onPressed: () {
                        localeProvider.setLocale(const Locale('kk'));
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          const Divider(),

          ListTile(
            leading: const Icon(Icons.delete_forever, color: Colors.red),
            title: Text(
              localizations.deleteAccount,
              style: const TextStyle(color: Colors.red),
            ),
            onTap: () => _confirmDelete(context, localizations),
          ),
        ],
      ),
    );
  }
}
