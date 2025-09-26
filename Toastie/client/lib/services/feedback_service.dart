import 'package:toastie/entities/feedback/feedback_entity.dart';
import 'package:toastie/repositories/feedback_repository.dart';
import 'package:toastie/services/services.dart';
import 'package:toastie/utils/time/time_utils.dart';

class FeedbackService {
  FeedbackService() {}

  Future<void> createFeedback({
    required FeedbackType type,
    required String details,
    String? contact,
  }) async {
    FeedbackEntity feedbackEntity = FeedbackEntity(
      date_time: convertToUnixDateTime(DateTime.now()),
      type: type,
      details: details,
      contact: contact,
    );
    await locator<FeedbackRepository>()
        .addFeedback(feedbackEntity: feedbackEntity);
  }
}
