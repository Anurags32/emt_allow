class ProfileModel {
  final String name;
  final String? profImg;
  final String email;
  final String? phone;
  final String? mobile;
  final bool pendingLogin;

  ProfileModel({
    required this.name,
    this.profImg,
    required this.email,
    this.phone,
    this.mobile,
    required this.pendingLogin,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      name: json['name']?.toString() ?? '',
      profImg: json['prof_img']?.toString(),
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString(),
      mobile: json['mobile']?.toString(),
      pendingLogin: json['pending_login'] is bool
          ? json['pending_login'] as bool
          : (json['pending_login'] == 1 || json['pending_login'] == true),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'prof_img': profImg,
      'email': email,
      'phone': phone,
      'mobile': mobile,
      'pending_login': pendingLogin,
    };
  }
}
