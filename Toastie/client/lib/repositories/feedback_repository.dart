import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastie/entities/feedback/feedback_entity.dart';
import 'package:toastie/services/services.dart';

class FeedbackRepository {
  FeedbackRepository() {}

  static final String _tableName = 'feedback';

  Future<void> addFeedback({required FeedbackEntity feedbackEntity}) async {
    await locator<SupabaseClient>()
        .from(_tableName)
        .insert(feedbackEntity.toJson());
  }
}
