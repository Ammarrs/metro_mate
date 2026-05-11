part of 'verify_identity_cubit.dart';

enum UploadStatus { idle, uploading, success, error }

// ── New imports needed at top of cubit file ──
// import '../../../services/dropdown_service.dart';

class DocumentFile {
  final String? fileName;
  final String? filePath;
  final UploadStatus status;
  final String? errorMessage;

  const DocumentFile({
    this.fileName,
    this.filePath,
    this.status = UploadStatus.idle,
    this.errorMessage,
  });

  DocumentFile copyWith({
    String? fileName,
    String? filePath,
    UploadStatus? status,
    String? errorMessage,
  }) {
    return DocumentFile(
      fileName: fileName ?? this.fileName,
      filePath: filePath ?? this.filePath,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class VerifyIdentityState extends Equatable {
  // ── Passed from subscription / plan screens ───────────────────────────────
  final String category;
  final String duration;
  final int zones;
  final String planId;

  // ── Collected on this screen ──────────────────────────────────────────────
  final String office;
  final String startStation;
  final String endStation;

  // ── Document uploads ──────────────────────────────────────────────────────
  final DocumentFile nationalIdFront;
  final DocumentFile nationalIdBack;
  final DocumentFile universityId;
  final DocumentFile militaryId;

  // ── Submission state ──────────────────────────────────────────────────────
  final bool isSubmitting;
  final bool isSubmitSuccess;
  final String? submitError;

  // ── Dropdown data ─────────────────────────────────────────────────────────
  final List<StationItem> stations;
  final List<OfficeItem> offices;
  final bool isLoadingDropdowns;
  final String? dropdownError;

  const VerifyIdentityState({
    required this.category,
    required this.duration,
    required this.zones,
    required this.planId,
    this.office = '',
    this.startStation = '',
    this.endStation = '',
    this.nationalIdFront = const DocumentFile(),
    this.nationalIdBack = const DocumentFile(),
    this.universityId = const DocumentFile(),
    this.militaryId = const DocumentFile(),
    this.isSubmitting = false,
    this.isSubmitSuccess = false,
    this.submitError,
    this.stations = const [],
    this.offices = const [],
    this.isLoadingDropdowns = false,
    this.dropdownError,
  });

  bool get isStudent => category.toLowerCase() == 'students';
  bool get isMilitary => category.toLowerCase() == 'military';

  bool get canProceed {
    final stationsOk =
        office.trim().isNotEmpty &&
        startStation.trim().isNotEmpty &&
        endStation.trim().isNotEmpty;

    final nationalOk =
        nationalIdFront.status == UploadStatus.success &&
        nationalIdBack.status == UploadStatus.success;

    final extraOk = isStudent
        ? universityId.status == UploadStatus.success
        : isMilitary
            ? militaryId.status == UploadStatus.success
            : true;

    return stationsOk && nationalOk && extraOk;
  }

  VerifyIdentityState copyWith({
    String? office,
    String? startStation,
    String? endStation,
    DocumentFile? nationalIdFront,
    DocumentFile? nationalIdBack,
    DocumentFile? universityId,
    DocumentFile? militaryId,
    bool? isSubmitting,
    bool? isSubmitSuccess,
    String? submitError,
    bool clearSubmitError = false,
    List<StationItem>? stations,
    List<OfficeItem>? offices,
    bool? isLoadingDropdowns,
    String? dropdownError,
    bool clearDropdownError = false,
  }) {
    return VerifyIdentityState(
      category: category,
      duration: duration,
      zones: zones,
      planId: planId,
      office: office ?? this.office,
      startStation: startStation ?? this.startStation,
      endStation: endStation ?? this.endStation,
      nationalIdFront: nationalIdFront ?? this.nationalIdFront,
      nationalIdBack: nationalIdBack ?? this.nationalIdBack,
      universityId: universityId ?? this.universityId,
      militaryId: militaryId ?? this.militaryId,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSubmitSuccess: isSubmitSuccess ?? this.isSubmitSuccess,
      submitError: clearSubmitError ? null : (submitError ?? this.submitError),
      stations: stations ?? this.stations,
      offices: offices ?? this.offices,
      isLoadingDropdowns: isLoadingDropdowns ?? this.isLoadingDropdowns,
      dropdownError:
          clearDropdownError ? null : (dropdownError ?? this.dropdownError),
    );
  }

  @override
  List<Object?> get props => [
        category, duration, zones, planId,
        office, startStation, endStation,
        nationalIdFront.status, nationalIdFront.fileName,
        nationalIdBack.status, nationalIdBack.fileName,
        universityId.status, universityId.fileName,
        militaryId.status, militaryId.fileName,
        isSubmitting, isSubmitSuccess, submitError,
        stations.length, offices.length,
        isLoadingDropdowns, dropdownError,
      ];
}