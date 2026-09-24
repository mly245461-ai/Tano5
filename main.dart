import 'package:flutter/material.dart';

void main() {
  runApp(const TanoApp());
}

class TanoApp extends StatefulWidget {
  const TanoApp({super.key});

  @override
  State<TanoApp> createState() => _TanoAppState();
}

class _TanoAppState extends State<TanoApp> {
  ThemeMode themeMode = ThemeMode.light;
  String language = 'العربية';

  void setLanguage(String value) {
    setState(() => language = value);
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = language == 'العربية';
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tano',
      themeMode: themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        scaffoldBackgroundColor: const Color(0xFFF7F7FB),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
      ),
      home: HomePage(
        isArabic: isArabic,
        language: language,
        onLanguageChanged: setLanguage,
        onThemeChanged: (value) => setState(() => themeMode = value),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final bool isArabic;
  final String language;
  final ValueChanged<String> onLanguageChanged;
  final ValueChanged<ThemeMode> onThemeChanged;

  const HomePage({
    super.key,
    required this.isArabic,
    required this.language,
    required this.onLanguageChanged,
    required this.onThemeChanged,
  });

  String t(String ar, String en) => isArabic ? ar : en;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tano'),
          centerTitle: true,
          actions: [
            IconButton(
              tooltip: t('الإشعارات', 'Notifications'),
              onPressed: () => _open(context, NotificationsPage(isArabic: isArabic)),
              icon: const Icon(Icons.notifications_none_rounded),
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t('مرحباً بك في Tano', 'Welcome to Tano'),
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      t(
                        'الفحص الدوري والوقاية الذكية في مكان واحد.',
                        'Smart monitoring and preventive care in one place.',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _tile(
              context,
              Icons.monitor_heart_outlined,
              t('المراقبة المباشرة', 'Live Monitoring'),
              t('درجة الحرارة و ΔT والحالة الحالية', 'Temperature, ΔT and current status'),
              () => _open(context, MonitoringPage(isArabic: isArabic)),
            ),
            _tile(
              context,
              Icons.history_rounded,
              t('السجل', 'History'),
              t('عرض القياسات السابقة حسب التاريخ', 'View previous measurements by date'),
              () => _open(context, HistoryPage(isArabic: isArabic)),
            ),
            _tile(
              context,
              Icons.auto_awesome_rounded,
              t('تحليل AI', 'AI Analysis'),
              t('صفحة التحليل الذكي', 'Smart analysis page'),
              () => _open(context, AiPage(isArabic: isArabic)),
            ),
            _tile(
              context,
              Icons.notifications_active_outlined,
              t('الإشعارات', 'Notifications'),
              t('التنبيهات والرسائل', 'Alerts and messages'),
              () => _open(context, NotificationsPage(isArabic: isArabic)),
            ),
            _tile(
              context,
              Icons.settings_outlined,
              t('الإعدادات', 'Settings'),
              t('اللغة والمظهر والحساب', 'Language, appearance and account'),
              () => _open(
                context,
                SettingsPage(
                  isArabic: isArabic,
                  language: language,
                  onLanguageChanged: onLanguageChanged,
                  onThemeChanged: onThemeChanged,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tile(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(child: Icon(icon)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: onTap,
      ),
    );
  }

  void _open(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }
}

class MonitoringPage extends StatelessWidget {
  final bool isArabic;
  const MonitoringPage({super.key, required this.isArabic});

  String t(String ar, String en) => isArabic ? ar : en;

  @override
  Widget build(BuildContext context) {
    return _Page(
      title: t('المراقبة المباشرة', 'Live Monitoring'),
      isArabic: isArabic,
      children: [
        _MetricCard(
          icon: Icons.thermostat_rounded,
          title: t('درجة الحرارة', 'Temperature'),
          value: '36.8 °C',
          note: t('طبيعي', 'Normal'),
        ),
        _MetricCard(
          icon: Icons.compare_arrows_rounded,
          title: 'ΔT',
          value: '+0.2 °C',
          note: t('ضمن النطاق الطبيعي', 'Within normal range'),
        ),
        Card(
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                const Icon(Icons.check_circle_rounded, color: Colors.green),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    t(
                      'لا توجد تنبيهات حرجة حالياً.',
                      'There are no critical alerts right now.',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class HistoryPage extends StatelessWidget {
  final bool isArabic;
  const HistoryPage({super.key, required this.isArabic});

  @override
  Widget build(BuildContext context) {
    final rows = [
      ('24/09/2026', '36.8 °C', '+0.2 °C'),
      ('23/09/2026', '36.7 °C', '+0.1 °C'),
      ('22/09/2026', '36.9 °C', '+0.3 °C'),
    ];

    return _Page(
      title: isArabic ? 'السجل' : 'History',
      isArabic: isArabic,
      children: [
        Card(
          elevation: 0,
          child: Column(
            children: rows
                .map(
                  (row) => ListTile(
                    leading: const Icon(Icons.calendar_today_outlined),
                    title: Text(row.$1),
                    subtitle: Text('Temp: ${row.$2}  •  ΔT: ${row.$3}'),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}

class NotificationsPage extends StatelessWidget {
  final bool isArabic;
  const NotificationsPage({super.key, required this.isArabic});

  @override
  Widget build(BuildContext context) {
    return _Page(
      title: isArabic ? 'الإشعارات' : 'Notifications',
      isArabic: isArabic,
      children: [
        _Message(
          icon: Icons.check_circle_outline,
          title: isArabic ? 'الحالة طبيعية' : 'Status is normal',
          body: isArabic ? 'آخر قراءة ضمن النطاق الطبيعي.' : 'The latest reading is within the normal range.',
        ),
        _Message(
          icon: Icons.info_outline,
          title: isArabic ? 'تذكير' : 'Reminder',
          body: isArabic ? 'راجع سجل القياسات اليوم.' : 'Review today’s measurement history.',
        ),
      ],
    );
  }
}

class AiPage extends StatelessWidget {
  final bool isArabic;
  const AiPage({super.key, required this.isArabic});

  @override
  Widget build(BuildContext context) {
    return _Page(
      title: isArabic ? 'تحليل AI' : 'AI Analysis',
      isArabic: isArabic,
      children: [
        Card(
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Icon(Icons.auto_awesome_rounded, size: 54),
                const SizedBox(height: 12),
                Text(
                  isArabic ? 'التحليل الذكي' : 'Smart Analysis',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  isArabic
                      ? 'هذه واجهة جاهزة لربط خدمة AI حقيقية لاحقاً. لا توجد خدمة خارجية متصلة في هذه النسخة.'
                      : 'This page is ready for a real AI service later. No external AI service is connected in this version.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(isArabic ? 'الواجهة جاهزة للربط بخدمة AI.' : 'The interface is ready for AI integration.')),
                  ),
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: Text(isArabic ? 'بدء التحليل' : 'Start analysis'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class SettingsPage extends StatelessWidget {
  final bool isArabic;
  final String language;
  final ValueChanged<String> onLanguageChanged;
  final ValueChanged<ThemeMode> onThemeChanged;

  const SettingsPage({
    super.key,
    required this.isArabic,
    required this.language,
    required this.onLanguageChanged,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return _Page(
      title: isArabic ? 'الإعدادات' : 'Settings',
      isArabic: isArabic,
      children: [
        Card(
          elevation: 0,
          child: ListTile(
            leading: const Icon(Icons.language_rounded),
            title: Text(isArabic ? 'اللغة' : 'Language'),
            subtitle: Text(language),
            onTap: () async {
              final result = await showDialog<String>(
                context: context,
                builder: (context) => SimpleDialog(
                  title: Text(isArabic ? 'اختر اللغة' : 'Choose language'),
                  children: [
                    SimpleDialogOption(
                      onPressed: () => Navigator.pop(context, 'العربية'),
                      child: const Text('العربية'),
                    ),
                    SimpleDialogOption(
                      onPressed: () => Navigator.pop(context, 'English'),
                      child: const Text('English'),
                    ),
                  ],
                ),
              );
              if (result != null) onLanguageChanged(result);
            },
          ),
        ),
        Card(
          elevation: 0,
          child: ListTile(
            leading: const Icon(Icons.account_circle_outlined),
            title: Text(isArabic ? 'الحساب' : 'Account'),
            subtitle: Text(isArabic ? 'واجهة الحساب جاهزة للربط بـ Google/Firebase.' : 'Account UI is ready for Google/Firebase integration.'),
          ),
        ),
        Card(
          elevation: 0,
          child: ListTile(
            leading: const Icon(Icons.dark_mode_outlined),
            title: Text(isArabic ? 'الوضع الداكن' : 'Dark mode'),
            trailing: Switch(
              value: Theme.of(context).brightness == Brightness.dark,
              onChanged: (value) => onThemeChanged(
                value ? ThemeMode.dark : ThemeMode.light,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Page extends StatelessWidget {
  final String title;
  final bool isArabic;
  final List<Widget> children;

  const _Page({
    required this.title,
    required this.isArabic,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(title: Text(title)),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: children,
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String note;

  const _MetricCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            CircleAvatar(radius: 28, child: Icon(icon)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(note),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Message extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;

  const _Message({
    required this.icon,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(body),
      ),
    );
  }
}
