import 'package:hive/hive.dart';

part 'user.g.dart';
@HiveType(typeId: 1)
class User{
  @HiveField(0)
  String name;
  @HiveField(1)
  String height;
  @HiveField(2)
  String weight;
  
  User({required this.height,required this.name,required this.weight,
  });
}