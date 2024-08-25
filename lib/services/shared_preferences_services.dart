import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceService{


  SharedPreferenceService._privateConstructor();

  //singleton instance variable
  static SharedPreferenceService? _instance;


  //getter to access the singleton instance
  static SharedPreferenceService get instance {
    _instance ??= SharedPreferenceService._privateConstructor();
    return _instance!;
  }

  Future saveSharedPreferenceString({required String key,required value}) async{

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    return sharedPreferences.setString(key, value);

  }

  Future getSharedPreferenceString(String key) async{

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    return sharedPreferences.getString(key);

  }

  Future getSharedPreferenceBool(String key) async{

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    return sharedPreferences.getBool(key);

  }
  Future removeSharedPreferenceBool(String key) async{

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    return sharedPreferences.remove(key);

  }

  Future saveSharedPreferenceBool({required String key,required value}) async{

    print("saveSharedPreferenceBool saved");

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    return sharedPreferences.setBool(key, value);

  }


}