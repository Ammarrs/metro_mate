import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:second/SubscrbtionScreen3,4/Bloc/State.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubscriptionCubitS3 extends Cubit<SubscriptionState> {
  final Dio dio;

  SubscriptionCubitS3(this.dio) : super(const SubscriptionInitial());

  Future<void> checkStatus() async {
    emit(const SubscriptionLoading());

    try {
      SharedPreferences shard = await SharedPreferences.getInstance();
      String? token = shard.getString('Token');
      final response = await dio.get(
          "https://metrodb-production.up.railway.app/api/v1/subscriptions/subscription-pay/status",
          options: Options(
            validateStatus: (status) => true,
            headers: {
              "Authorization": "Bearer $token",
            },
          ));

      final status = response.data['data']?['status']?.toString();
      print("Subscription status: $status");
      print("token: $token");
      print("API Status = $status");

      switch (status) {
        case "pending":
          emit(const SubscriptionPending());
          break;

        case "accepted":
          emit(const SubscriptionAccepted());
          break;

        case "rejected":
          emit(const SubscriptionRejected());
          break;

        case "expired":
          emit(const SubscriptionExpired());
          break;
        case "active":
          emit(const SubscriptionActive());
          break;

        default:
          emit(const SubscriptionError("Unknown status"));
      }
    } catch (e) {
      emit(SubscriptionError(e.toString()));
    }
  }
}
