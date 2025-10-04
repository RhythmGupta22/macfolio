import 'dart:ui';
import 'package:flutter/material.dart';

class AppInfo {
  final String name;
  final String iconPath;
  const AppInfo({required this.name, required this.iconPath});
}

class AllAppsWindow extends StatefulWidget {
  final VoidCallback onClose;
  final List<AppInfo> apps;
  const AllAppsWindow({super.key, required this.onClose, required this.apps});

  @override
  State<AllAppsWindow> createState() => _AllAppsWindowState();
}

class _AllAppsWindowState extends State<AllAppsWindow> {
  String _search = '';
  int _page = 0;
  final _pageController = PageController();

  static const int appsPerPage = 20;

  List<AppInfo> get filteredApps {
    if (_search.trim().isEmpty) return widget.apps;
    return widget.apps.where((a) => a.name.toLowerCase().contains(_search.toLowerCase())).toList();
  }

  int get pageCount => (filteredApps.length / appsPerPage).ceil().clamp(1, 999);

  List<AppInfo> appsForPage(int page) {
    final start = page * appsPerPage;
    final end = (start + appsPerPage).clamp(0, filteredApps.length);
    return filteredApps.sublist(start, end);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            // Fullscreen blur and overlay
            ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                child: Container(
                  color: Colors.black.withOpacity(0.55),
                ),
              ),
            ),
            // Blended close button (top-right)
            Positioned(
              top: 32,
              right: 40,
              child: GestureDetector(
                onTap: widget.onClose,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.13),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Icon(Icons.close, color: Colors.white.withOpacity(0.85), size: 28),
                ),
              ),
            ),
            Positioned(
              top: 32,
              left: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 500),
                child: SizedBox(
                  width: 420,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search apps...',
                      hintStyle: const TextStyle(color: Colors.white54, fontSize: 16),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.08),
                      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    onChanged: (v) {
                      setState(() {
                        _search = v;
                        _page = 0;
                        _pageController.jumpToPage(0);
                      });
                    },
                  ),
                ),
              ),
            ),

            // Main content
            Positioned.fill(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 900,
                    maxHeight: 700,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: Container(
                          constraints: const BoxConstraints(maxHeight: 580),
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount: pageCount,
                            onPageChanged: (p) => setState(() => _page = p),
                            itemBuilder: (context, pageIdx) {
                              final pageApps = appsForPage(pageIdx);
                              return GridView.builder(
                                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 5,
                                  crossAxisSpacing: 80,
                                  mainAxisSpacing: 40,
                                  childAspectRatio: 0.7, // Adjusted to give more vertical space
                                ),
                                itemCount: pageApps.length,
                                itemBuilder: (context, i) {
                                  final app = pageApps[i];
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                      app.iconPath,
                                      ),
                                      Text(
                                        app.name,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 0.1,
                                        ),
                                        maxLines: 1,
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                      // Page indicators
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WindowButton extends StatelessWidget {
  final Color color;
  final VoidCallback onTap;

  const _WindowButton({
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
