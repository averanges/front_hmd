import 'package:haimdall/src/common/either/either.dart';
import 'package:haimdall/src/common/exception/exceptions.dart';

typedef Result<R> = Either<CommonException, R>;
