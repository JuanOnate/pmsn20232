import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiCast{
  Future<List<Map<String, dynamic>>?> getCast(int idMovie) async {
    final apiKey = '5019e68de7bc112f4e4337a500b96c56&language=es-MX&page=1';
    final castApiURL = Uri.parse('https://api.themoviedb.org/3/movie/$idMovie/credits?api_key=$apiKey');
    final response = await http.get(castApiURL);
    if(response.statusCode == 200){
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<Map<String, dynamic>> cast = List<Map<String, dynamic>>.from(data['cast']);
      return cast;
    }
    return null;
  }
}