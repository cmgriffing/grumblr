import 'package:grumblr/http.dart';

class ApiAuthService {

  register(String email, String password) {
    return Http().post('/register', data: {
      email: email,
      password: password,
    });
  }

  login(String email, String password) {
    return Http().post('/login', data: {
      email: email,
      password: password,
    });
  }

  validate() {
    return Http().get('/validate');
  }
}
