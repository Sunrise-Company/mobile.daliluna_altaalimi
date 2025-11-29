class BreadcrumbItem {
  final String title;
  final String route;
  final Map<String, dynamic>? arguments;

  BreadcrumbItem({required this.title, required this.route, this.arguments});
}
