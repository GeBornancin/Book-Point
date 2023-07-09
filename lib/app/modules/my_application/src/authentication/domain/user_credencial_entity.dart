class UserCredentialApp {
  final AuthType authType;
  final String? uId;
  final String? name;
  late final String email;
  final String? password;
  final String? token;
  final DateTime? tokenExpireIn;
  String? profileImage; // Campo para armazenar a URL da imagem do perfil

  UserCredentialApp({
    required this.authType,
    this.uId,
    this.name,
    required this.email,
    this.password,
    this.token,
    this.tokenExpireIn,
    this.profileImage, // Incluir o parâmetro do construtor
  });
}
enum AuthType { email, google }
