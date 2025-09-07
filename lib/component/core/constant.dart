import 'package:flutter_dotenv/flutter_dotenv.dart';

final USER_COLLECTION = 'user';
final CATEGORY_COLLECTION = 'category';
final NOTE_COLLECTION = 'note';
final TODO_COLLECTION = 'todo';
final TASK_COLLECTION = 'task';
final JWT_EXPIRED = '7d';
final JWT_SECRET = dotenv.env['JWT_SECRET'];