import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import '../../../services/verify_identity_service.dart';
import '../../../services/dropdown_service.dart';  // ← new import

part 'verify_identity_state.dart';

class VerifyIdentityCubit extends Cubit<VerifyIdentityState> {
  final VerifyIdentityRepository _repository;

  VerifyIdentityCubit({
    required VerifyIdentityRepository repository,
    required String category,
    required String duration,
    required int zones,
    required String planId,
  })  : _repository = repository,
        super(VerifyIdentityState(
          category: category,
          duration: duration,
          zones: zones,
          planId: planId,
        ));

  // ─── Load dropdown data ───────────────────────────────────────────────────

  Future<void> loadDropdowns() async {
    if (state.stations.isNotEmpty && state.offices.isNotEmpty) return;
    emit(state.copyWith(isLoadingDropdowns: true, clearDropdownError: true));
    try {
      final results = await Future.wait([
        DropdownService.fetchStations(),
        DropdownService.fetchOffices(),
      ]);
      emit(state.copyWith(
        stations: results[0] as List<StationItem>,
        offices: results[1] as List<OfficeItem>,
        isLoadingDropdowns: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoadingDropdowns: false,
        dropdownError: 'Failed to load stations. Please try again.',
      ));
    }
  }

  // ─── Text fields ──────────────────────────────────────────────────────────

  void officeChanged(String value) =>
      emit(state.copyWith(office: value));

  void startStationChanged(String value) =>
      emit(state.copyWith(startStation: value));

  void endStationChanged(String value) =>
      emit(state.copyWith(endStation: value));

  // ─── File picking ─────────────────────────────────────────────────────────

  Future<void> pickNationalIdFront() async {
    await _pickFile(
      onUploading: () => emit(state.copyWith(
        nationalIdFront:
            state.nationalIdFront.copyWith(status: UploadStatus.uploading),
      )),
      onSuccess: (name, path) => emit(state.copyWith(
        nationalIdFront: DocumentFile(
            fileName: name, filePath: path, status: UploadStatus.success),
      )),
      onError: (msg) => emit(state.copyWith(
        nationalIdFront: state.nationalIdFront
            .copyWith(status: UploadStatus.error, errorMessage: msg),
      )),
    );
  }

  Future<void> pickNationalIdBack() async {
    await _pickFile(
      onUploading: () => emit(state.copyWith(
        nationalIdBack:
            state.nationalIdBack.copyWith(status: UploadStatus.uploading),
      )),
      onSuccess: (name, path) => emit(state.copyWith(
        nationalIdBack: DocumentFile(
            fileName: name, filePath: path, status: UploadStatus.success),
      )),
      onError: (msg) => emit(state.copyWith(
        nationalIdBack: state.nationalIdBack
            .copyWith(status: UploadStatus.error, errorMessage: msg),
      )),
    );
  }

  Future<void> pickUniversityId() async {
    await _pickFile(
      onUploading: () => emit(state.copyWith(
        universityId:
            state.universityId.copyWith(status: UploadStatus.uploading),
      )),
      onSuccess: (name, path) => emit(state.copyWith(
        universityId: DocumentFile(
            fileName: name, filePath: path, status: UploadStatus.success),
      )),
      onError: (msg) => emit(state.copyWith(
        universityId: state.universityId
            .copyWith(status: UploadStatus.error, errorMessage: msg),
      )),
    );
  }

  Future<void> pickMilitaryId() async {
    await _pickFile(
      onUploading: () => emit(state.copyWith(
        militaryId:
            state.militaryId.copyWith(status: UploadStatus.uploading),
      )),
      onSuccess: (name, path) => emit(state.copyWith(
        militaryId: DocumentFile(
            fileName: name, filePath: path, status: UploadStatus.success),
      )),
      onError: (msg) => emit(state.copyWith(
        militaryId: state.militaryId
            .copyWith(status: UploadStatus.error, errorMessage: msg),
      )),
    );
  }

  Future<void> _pickFile({
    required void Function() onUploading,
    required void Function(String name, String path) onSuccess,
    required void Function(String error) onError,
  }) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) return;

      final picked = result.files.single;
      if (picked.path == null) {
        onError('Could not access file. Please try again.');
        return;
      }

      final sizeInMb = File(picked.path!).lengthSync() / (1024 * 1024);
      if (sizeInMb > 5) {
        onError('File must be smaller than 5 MB.');
        return;
      }

      onUploading();
      await Future.delayed(const Duration(milliseconds: 400));
      onSuccess(picked.name, picked.path!);
    } catch (e) {
      onError(e.toString().replaceAll('Exception: ', ''));
    }
  }

  // ─── Submit ───────────────────────────────────────────────────────────────

  Future<void> continueToPayment() async {
    if (!state.canProceed) return;
    emit(state.copyWith(isSubmitting: true, clearSubmitError: true));

    try {
      await _repository.createSubscription(
        category: state.category,
        duration: state.duration,
        zones: state.zones,
        office: state.office.trim(),
        startStation: state.startStation.trim(),
        endStation: state.endStation.trim(),
        nationalIdFront: File(state.nationalIdFront.filePath!),
        nationalIdBack: File(state.nationalIdBack.filePath!),
        universityId: state.isStudent && state.universityId.filePath != null
            ? File(state.universityId.filePath!)
            : null,
        militaryId: state.isMilitary && state.militaryId.filePath != null
            ? File(state.militaryId.filePath!)
            : null,
      );

      emit(state.copyWith(isSubmitting: false, isSubmitSuccess: true));
    } catch (e) {
      emit(state.copyWith(
        isSubmitting: false,
        submitError: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }

  void clearError() => emit(state.copyWith(clearSubmitError: true));
}