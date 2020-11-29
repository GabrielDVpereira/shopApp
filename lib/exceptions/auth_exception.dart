class AuthException implements Exception {
  final String key;

  static const Map<String, String> errors = {
    "EMAIL_NOT_FOUND": "Email não encontrado.",
    "INVALID_PASSWORD": "Senha inválida.",
    "USER_DISABLED": "Usuário desativado.",
    "EMAIL_EXISTS": "Esse email já está sendo utilizado.",
    "OPERATION_NOT_ALLOWED": "Operação não permitida.",
    "TOO_MANY_ATTEMPTS_TRY_LATER":
        "Muitas tentativas, tente novamente mais tarde."
  };

  const AuthException(this.key);

  @override
  String toString() {
    if (errors.containsKey(key)) {
      return errors[key];
    } else {
      return "Algo deu errado, tente novamente mais tarde.";
    }
  }
}
