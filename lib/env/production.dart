import 'package:haimdall/env/build_type.dart';
import 'package:haimdall/env/environment.dart';

void main() => Environment.newInstance(BuildType.production).run();
