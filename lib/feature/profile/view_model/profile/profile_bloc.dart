import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:out_split_in/core/sms/sms_import_service.dart';

part 'profile_state.dart';
part 'profile_event.dart';
part 'profile_bloc.freezed.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final SmsImportService smsImportService;
  ProfileBloc(this.smsImportService) : super(const ProfileState()) {
    on<MessageSync>(inboxSmsSync);
  }
  Future<void> inboxSmsSync(MessageSync event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(loadingStatus: ProfileLoadingStatus.loading));
    try {
      final result = await smsImportService.importInbox();
      debugPrint('Message sync result: $result');
      emit(
        state.copyWith(
          loadingStatus: ProfileLoadingStatus.success,
          msg: 'Message sync completed successfully',
        ),
      );
    } catch (e) {
      debugPrint('Error during message sync: ${e.toString()}');
      emit(
        state.copyWith(
          loadingStatus: ProfileLoadingStatus.error,
          msg: 'Error during message sync: ${e.toString()}',
        ),
      );
    }
  }
}
