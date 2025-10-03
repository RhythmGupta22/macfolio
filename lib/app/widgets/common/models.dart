class AppItem {
  final String label;
  final bool isFolder, isTrash, isExecutable;
  final List<AppItem>? children;

  AppItem({
    required this.label,
    this.isFolder = false,
    this.isTrash = false,
    this.isExecutable = false,
    this.children,
  });
}

// Central lists
final desktopItems = [
  AppItem(label: 'Applications', isFolder: true, children: [
    AppItem(label: 'Chrome', isExecutable: true),
    AppItem(label: 'VS Code', isExecutable: true),
    AppItem(label: 'Figma', isExecutable: true),
  ]),
  AppItem(label: 'README.txt', isExecutable: false),
];

final allApps = desktopItems
    .where((i) => i.isFolder)
    .expand((f) => f.children!)
    .toList();

final trashItems = [
  AppItem(label: 'DeletedItem1.txt'),
  AppItem(label: 'OldScreenshot.png'),
];