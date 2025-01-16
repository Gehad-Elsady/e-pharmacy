import 'package:googleapis_auth/auth_io.dart';

class get_server_key {
  Future<String> server_token() async {
    final scopes = [
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/firebase.database',
      'https://www.googleapis.com/auth/firebase.messaging',
    ];
    final client = await clientViaServiceAccount(
        ServiceAccountCredentials.fromJson({
          "type": "service_account",
          "project_id": "e-pharmacy-e65d1",
          "private_key_id": "ab39152f52b7f1a1ed53ea87a5a1d14fbe941966",
          "private_key":
              "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDHdQvOuQDve32j\nfvrwcAThiXHcEPJoAiOGJ12Rh8EMW0H5ExeaaewtBjKkrnET4QGRLav8qIrsxvx7\na0mV2PNTlZPBc1gZelEGWSpoqCwXT8rpBaxNDlhPvCT4PbbSm4QycibwHcqKAFMo\nlXmVCNBz7Ha+esQ0KP5NXO18F/0yUq/PZRJgeYvIWgn/JH+DI20/BePumqaoVNwD\nnE+rlfu3fHd1uBabh2Hu1g+MJ9J/oKhKkztQAGjvfA6Of3YXdi8CvLfu6LHohiHT\nzBtK7wnreyYnK+fWof8QfzeDHIExvb5vNcyPS1ConREzs0HcKbMJudM5WomJ3r/i\nsRbhD0KDAgMBAAECggEARKe62TzgIA7bV9BJE0MTwwha+1uP/RIjZTWepQ3b+uNc\nqZ4TRVEJfRQBkaMEBEoyjmTwqube7xKtbNQov54uX4qAkhmgbSCnzC4cBWtBxgJu\nv1f3D40NA+EovpQLnqHuVqjpU0SF54umFDWjZJPkoMp3sygx6hxkMH/4tPrS6iNl\nEQrCLYw+F/+Zv8V3DP2TUh7U9piNqRbuXVG+pgtBFmsvpnVSmtWMxP1OKDIqBrQw\n7nt5BewfhoPaf6n5hrH9Nx+bqtupBEoJQavJCJ5X2BCa0Ku1ISK+UYyvj2zzrYcc\nPnMUoPnkJ0v0CvvxOmj/dXPZEaQWvicC6Vh3fj6zXQKBgQD1MC1Nr6CERo77PjMd\nJacO+NeoA6nCijn0u4/ay/ekgUHTc/lXImfWNvGXQYglSocBmpxCIAD7Wps8lVYQ\n+vbV27A9bZllp6lVacmo4+16nK1MUwgFrLVTe+jMijjzk7KGXhhlIRldCfHpQjbe\n/EHMQRBX91va3PZT5+TFXRMTxQKBgQDQQKHJfNbsMGDkSMMkXUkpTFXWrMlLRwai\nzZl80GPmuFnWFclVzUqmqJ9c6Hl8tNbta08MGb9xAGG7EoCwfA+jCjQUqRIEw/fu\ng2gRfrD7WCw1HG2sFGX0lhGHQau/NDCF+8D0VevC18E92J86i2dwx4YTGn1evbqU\naNaIoES5pwKBgEZydzHQ+l/HHiHV9z2yqdNFcEEX/Fim+ov0sBp/bEHZ2Z31vnho\nrEkCNFvvOjzssumlEKx3IZEWsW+wwK/US8OagYLE0MRCbgbahFSAWKVYCvrZCH8I\n5nh8K6FJPZ/Omga9VmkIH4954gXRPo7HD+it8RI1QjEaN7RX9oU2ftq5AoGBAIQq\nAINW7y9GJLe8VdwmN+A1yeRMFBPqJ5P614YW2s/5/0mW2gfSGaZbLYhRIYi7XAuh\nJrGPRaf5jgyjWXinw2S9fP//rKfJlveP/ePce4WIF8Y9HH0xFON8ufMVAmJ+RK1D\ncNmgDdfCBamyaJtHDYbNmZFWJmqSDm9ReZWL4RHRAoGBAL+QwWZCuEsYU4/a/u8V\ngCULCDIPVJDmjGWhIiDgkdRGPbJxE4Q390vZs0eOU6RZkzj5tKI5u5urs0pUFBV1\ntZA+4x+BNsFrMo/95yXpLYyYl/c7ZvR0BOEzNLCW367/qKxuybh6n9ZI1yxKoxoI\n4PRf21NY6uBMVq9iFffNAuod\n-----END PRIVATE KEY-----\n",
          "client_email":
              "firebase-adminsdk-nmcv0@e-pharmacy-e65d1.iam.gserviceaccount.com",
          "client_id": "113937764685120833771",
          "auth_uri": "https://accounts.google.com/o/oauth2/auth",
          "token_uri": "https://oauth2.googleapis.com/token",
          "auth_provider_x509_cert_url":
              "https://www.googleapis.com/oauth2/v1/certs",
          "client_x509_cert_url":
              "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-nmcv0%40e-pharmacy-e65d1.iam.gserviceaccount.com",
          "universe_domain": "googleapis.com"
        }),
        scopes);
    final accessserverkey = client.credentials.accessToken.data;
    return accessserverkey;
  }
}
