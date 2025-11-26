class VersionModel {
  final String versionNum;
  final bool requiredUpdate;

  VersionModel({required this.versionNum, required this.requiredUpdate});

  factory VersionModel.fromJson(Map<String, dynamic> json) {
    return VersionModel(
      versionNum: json['version_num'],
      requiredUpdate: json['required_update'] == "1",
    );
  }
}
