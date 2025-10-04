import 'package:flutter/material.dart';
import '../../../widgets/common/dock.dart';
import '../../../widgets/common/desktop_icon.dart';
import '../../../widgets/common/menu_bar.dart';
import '../../../widgets/common/draggable_window.dart';
import '../../../widgets/common/all_apps_window.dart';
import '../../../widgets/common/window_animations.dart';
import '../../../widgets/common/video_background.dart';

class WindowState {
  final String title;
  final List<String> items;
  bool isOpen;
  bool isMinimized;
  bool isClosing;
  Rect? lastRect;

  WindowState({
    required this.title,
    required this.items,
    this.isOpen = false,
    this.isMinimized = false,
    this.isClosing = false,
    this.lastRect,
  });
}

class WindowManager {
  final Map<String, WindowState> windowStates = {};
  Rect? minimizeRect;
  String? minimizingWindowTitle;

  void openWindow(String title, List<String> items) {
    windowStates[title] = WindowState(title: title, items: items, isOpen: true, isMinimized: false);
  }

  void toggleWindow(String title, List<String> items) {
    final win = windowStates[title];
    if (win == null) {
      windowStates[title] = WindowState(title: title, items: items, isOpen: true, isMinimized: false);
    } else if (win.isOpen && !win.isMinimized) {
      win.isMinimized = true;
      win.isOpen = true;
    } else if (win.isOpen && win.isMinimized) {
      win.isMinimized = false;
      win.isOpen = true;
    } else {
      win.isOpen = true;
      win.isMinimized = false;
    }
  }

  void closeWindow(String title) {
    windowStates.remove(title);
  }

  void minimizeWindow(String title) {
    final win = windowStates[title];
    if (win != null) {
      win.isMinimized = true;
    }
  }
}

class DesktopView extends StatefulWidget {
  const DesktopView({super.key});
  @override
  State<DesktopView> createState() => _DesktopViewState();
}

class _DesktopViewState extends State<DesktopView> {
  final WindowManager _windowManager = WindowManager();
  late final Offset dockOffset;
  bool showAllAppsWindow = false;
  bool _isRestoring = false;
  bool _isInitialLoad = true;

  // List of all app icons for the launcher
  final List<AppInfo> allApps = [
    AppInfo(name: 'Finder', iconPath: 'assets/icons/Finder.png'),
    AppInfo(name: 'All Apps', iconPath: 'assets/icons/All Apps.png'),
    AppInfo(name: 'Contact Me', iconPath: 'assets/icons/Contact Me.png'),
    AppInfo(name: 'Music', iconPath: 'assets/icons/Music.png'),
    AppInfo(name: 'Calculator', iconPath: 'assets/icons/Calculator.png'),
    AppInfo(name: 'Photos', iconPath: 'assets/icons/Photos.png'),
    AppInfo(name: 'Skills', iconPath: 'assets/icons/Skills.png'),
    AppInfo(name: 'Terminal', iconPath: 'assets/icons/Terminal.png'),
    AppInfo(name: 'About Me', iconPath: 'assets/icons/About Me.png'),
    AppInfo(name: 'Trash', iconPath: 'assets/icons/Trash.png'),
  ];

  @override
  void initState() {
    super.initState();
    // Reset initial load flag after animation
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() => _isInitialLoad = false);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Calculate dock offset based on screen width
    final screenWidth = MediaQuery.of(context).size.width;
    dockOffset = Offset(screenWidth / 2 - 24.0, 900); // Center horizontally, 900 pixels from top
  }

  void _minimizeWindow(String title, GlobalKey<State<StatefulWidget>> windowKey) {
    if (!_windowManager.windowStates.containsKey(title) || windowKey.currentContext == null) return;

    final context = windowKey.currentContext!;
    final renderObject = context.findRenderObject();
    if (renderObject is! RenderBox) return;

    final pos = renderObject.localToGlobal(Offset.zero);
    final size = renderObject.size;
    final rect = Rect.fromLTWH(pos.dx, pos.dy, size.width, size.height);

    setState(() {
      final win = _windowManager.windowStates[title]!;
      win.lastRect = rect;
      win.isMinimized = true;
      _isRestoring = false;
    });
  }

  void _restoreWindow(String title) {
    final win = _windowManager.windowStates[title];
    if (win == null || !win.isMinimized) return;

    setState(() {
      win.isMinimized = false;
      _isRestoring = true;
    });
  }

  void _closeWindow(String title, Rect rect) {
    final win = _windowManager.windowStates[title];
    if (win == null) return;

    setState(() {
      win.isClosing = true;
      win.lastRect = rect;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Stack(children: [
      const VideoBackground(),
      const Positioned(top: 0, left: 0, right: 0, child: MacMenuBar()),

      // Desktop Icons
      DesktopIcon(
        icon: Icons.folder,
        label: 'Applications',
        type: DesktopIconType.folder,
        initialPosition: const Offset(40, 120),
        onDoubleTap: () {
          _windowManager.openWindow('Applications', ['Chrome', 'VS Code', 'Figma']);
          setState(() {});
        },
      ),

      // Windows
      for (final win in _windowManager.windowStates.values)
        if (win.isClosing && win.lastRect != null)
          WindowCloseAnimation(
            key: ValueKey('close_${win.title}'),
            rect: win.lastRect!,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(179),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DraggableWindow(
                title: win.title,
                items: win.items,
                onClose: () {},
                onFolderTap: (_, __) {},
              ),
            ),
            onComplete: () {
              _windowManager.closeWindow(win.title);
              setState(() {});
            },
          )
        else if (win.isMinimized && win.lastRect != null)
          WindowMinimizeAnimation(
            key: ValueKey('min_${win.title}'),
            startRect: win.lastRect!,
            endOffset: dockOffset,
            isReversed: _isRestoring,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(179),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  win.title,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
            onComplete: () {
              if (_isRestoring) {
                win.isMinimized = false;
                win.lastRect = null;
              }
              setState(() {});
            },
          )
        else if (!win.isMinimized && win.title != 'All Apps')
          Builder(
            key: ValueKey(win.title),
            builder: (context) {
              final windowKey = GlobalKey<State<StatefulWidget>>();
              return DraggableWindow(
                key: windowKey,
                title: win.title,
                items: win.items,
                onClose: () {
                  if (windowKey.currentContext != null) {
                    final box = windowKey.currentContext!.findRenderObject() as RenderBox;
                    final pos = box.localToGlobal(Offset.zero);
                    _closeWindow(win.title, Rect.fromLTWH(pos.dx, pos.dy, box.size.width, box.size.height));
                  }
                },
                onFolderTap: (label, children) {
                  _windowManager.toggleWindow(label, ['File 1', 'File 2', '$label Folder']);
                  setState(() {});
                },
                onMinimize: () => _minimizeWindow(win.title, windowKey),
              );
            },
          ),

      // All Apps Window
      if (showAllAppsWindow && !(_windowManager.windowStates['All Apps']?.isMinimized ?? false))
        AllAppsWindow(
          onClose: () {
            showAllAppsWindow = false;
            _windowManager.windowStates['All Apps']?.isOpen = false;
            setState(() {});
          },
          apps: allApps,
        ),

      // Dock
      Align(
        alignment: Alignment.bottomCenter,
        child: Dock(
          onIconTap: (label) {
            if (label == 'All Apps') {
              showAllAppsWindow = true;
              _windowManager.openWindow('All Apps', []);
            } else {
              final win = _windowManager.windowStates[label];
              if (win != null && win.isMinimized) {
                _restoreWindow(label);
              } else {
                _windowManager.toggleWindow(label, ['Item 1', 'Item 2']);
              }
            }
            setState(() {});
          },
          minimizedStates: _windowManager.windowStates.map((k, v) => MapEntry(k, v.isMinimized)),
        ),
      ),
    ]);

    // Wrap with desktop opening animation if it's initial load
    if (_isInitialLoad) {
      content = DesktopOpenAnimation(child: content);
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: content,
    );
  }
}