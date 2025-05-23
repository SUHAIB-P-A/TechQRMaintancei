import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:techqrmaintance/core/strings.dart';
import 'package:techqrmaintance/domain/core/failures/main_failurs.dart';
import 'package:techqrmaintance/domain/usermodel/single_user_repo.dart';
import 'package:techqrmaintance/domain/usermodel/user_model_list/user_model_list_saas/user_model.dart';
import 'package:techqrmaintance/infrastructure/api_token_generator.dart';

@LazySingleton(as: SingleUserRepo)
class SingleUserServices implements SingleUserRepo {
  ApiServices singleUserApi = ApiServices();
  @override
  Future<Either<MainFailurs, UserModel>> getSingleUserRepo(
      {required String id}) async {
    try {
      final Response respo =
          await singleUserApi.dio.get("$kBaseURL$kuserADD/$id");
      if (respo.statusCode == 200) {
        log(
          "hello",
          name: "singleUserServices",
        );
        final user = UserModel.fromJson(respo.data['data']);
        log(
          "User hello: ${user.toJson()}",
          name: "singleUserServices",
        );
        return Right(user);
      } else {
        return Left(MainFailurs.serverFailure());
      }
    } on DioException catch (e) {
      log('DioException: ${e.message}',
          error: e, name: "singleUserServices", stackTrace: StackTrace.current);
      await singleUserApi.clearStoredToken();
      return Left(MainFailurs.serverFailure());
    } catch (e) {
      log('Unexpected error: ${e.toString()}',
          error: e, stackTrace: StackTrace.current, name: "singleUserServices");
      return Left(MainFailurs.clientFailure());
    }
  }
}
