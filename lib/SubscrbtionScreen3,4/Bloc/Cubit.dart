import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:second/SubscrbtionScreen3,4/Bloc/State.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubscriptionCubitS3 extends Cubit<SubscriptionState> {
  final Dio dio;

  SubscriptionCubitS3(this.dio) : super(const SubscriptionInitial()) {
    dio.options.responseType = ResponseType.json;
  }

  Future<String> _getLanguage() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString('lang') ?? 'en';
  }

  Future<void> checkStatus() async {
    emit(const SubscriptionLoading());

    try {
      final shared = await SharedPreferences.getInstance();

      final token = shared.getString('Token');

      if (token == null || token.isEmpty) {
        emit(
          const SubscriptionError(
            "Token not found",
          ),
        );

        return;
      }

      /// STATUS API
      final statusResponse = await dio.get(
        "https://metrodb-production.up.railway.app/api/v1/subscriptions/subscription-pay/status",
        options: Options(
          validateStatus: (status) => true,
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
          },
        ),
      );

      print("STATUS RESPONSE:");
      print(statusResponse.data);
      print(statusResponse.data.runtimeType);

      // 404 means the user has no subscription at all — clear local state
      // and send them back to Screen 1 / Screen 2.
      if (statusResponse.statusCode == 404) {
        await _clearSubscriptionId();
        emit(const SubscriptionNotFound());
        return;
      }

      if (statusResponse.data is! Map<String, dynamic>) {
        emit(
          const SubscriptionError(
            "Invalid status response format",
          ),
        );

        return;
      }

      final statusData = statusResponse.data as Map<String, dynamic>;

      final status = statusData['data']?['status']?.toString();

      print("Status = $status");

      // Null or blank status means the backend returned data with no
      // recognisable status field — treat as "no subscription".
      if (status == null || status.isEmpty) {
        await _clearSubscriptionId();
        emit(const SubscriptionNotFound());
        return;
      }

      /// DETAILS API
      final detailsResponse = await dio.get(
        "https://metrodb-production.up.railway.app/api/v1/subscriptions/subscription-pay",
        options: Options(
          validateStatus: (status) => true,
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
            "Accept-Language": await _getLanguage(),
          },
        ),
      );

      print("DETAILS RESPONSE:");
      print(detailsResponse.data);
      print(detailsResponse.data.runtimeType);

      if (detailsResponse.data is! Map<String, dynamic>) {
        emit(
          const SubscriptionError(
            "Invalid details response format",
          ),
        );

        return;
      }

      final responseData = detailsResponse.data as Map<String, dynamic>;

      final data = responseData['data'];

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
          if (data is Map<String, dynamic>) {
            emit(
              SubscriptionActive(data),
            );
          } else {
            emit(
              const SubscriptionError(
                "Invalid active subscription data",
              ),
            );
          }
          break;

        case "renew":
          if (data is Map<String, dynamic>) {
            emit(
              SubscriptionRenew(data),
            );
          } else {
            emit(
              const SubscriptionError(
                "Invalid renew subscription data",
              ),
            );
          }
          break;
        case "manualRenew":
          emit(const SubscriptionmanualRenew());
          break;

        default:
          // Unknown status — the subscription was likely deleted on the backend.
          // Clear the local key so the next visit starts from Screen 1.
          await _clearSubscriptionId();
          emit(const SubscriptionNotFound());
      }
    } catch (e, stackTrace) {
      print("ERROR:");
      print(e);

      print("STACKTRACE:");
      print(stackTrace);

      emit(
        SubscriptionError(
          e.toString(),
        ),
      );
    }
  }

  /// Removes the locally-cached subscription id so that the next time the
  /// user opens the Subscription tab they start from Screen 1 again.
  Future<void> _clearSubscriptionId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('subscription_id');
    } catch (_) {}
  }

  Future<String> confirmRenew() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String? token = prefs.getString("Token");

      final response = await dio.patch(
        "https://metrodb-production.up.railway.app/api/v1/subscriptions/renew",
        data: {
          "wantRenew": true,
        },
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
            "Accept-Language": await _getLanguage(),
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data['message'];
      }

      return "Failed To Renew";
    } catch (e) {
      return e.toString();
    }
  }
}