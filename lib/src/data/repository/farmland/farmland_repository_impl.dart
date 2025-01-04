import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:haimdall/src/common/alias/alias.dart';
import 'package:haimdall/src/common/either/either.dart';
import 'package:haimdall/src/common/manager/storage_manager/storage_manager.dart';
import 'package:haimdall/src/data/network/model/request/farmland/farmland_change_schedule_request.dart';
import 'package:haimdall/src/data/network/model/request/farmland/farmland_drain_request.dart';
import 'package:haimdall/src/data/network/model/request/farmland/farmland_drain_water_request.dart';
import 'package:haimdall/src/data/network/model/request/farmland/farmland_planting_request.dart';
import 'package:haimdall/src/data/network/model/request/farmland/farmland_record_request.dart';
import 'package:haimdall/src/data/network/model/request/farmland/farmland_update_basic_info_request.dart';
import 'package:haimdall/src/data/network/model/request/farmland/farmland_watering_request.dart';
import 'package:haimdall/src/data/network/network.dart';
import 'package:haimdall/src/domain/model/farmland/calendar/farmland_date_data.dart';
import 'package:haimdall/src/domain/model/farmland/farmland.dart';
import 'package:haimdall/src/domain/model/farmland/recording/farmland_record_data.dart';
import 'package:haimdall/src/domain/model/history/change/change_request_data.dart';
import 'package:haimdall/src/domain/repository/farmland/farmland_repository.dart';
import 'package:haimdall/src/presentation/farmland/home/progress/farmland_progress_controller.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tuple/tuple.dart';

class FarmlandRepositoryImpl implements FarmlandRepository {
  final FarmlandApi _farmlandApi;
  FarmlandDateData? _cachedFarmlandDateData;

  FarmlandRepositoryImpl(this._farmlandApi);

  @override
  Future<Result<List<Farmland>>> getFarmlandList() async {
    final userId = Get.find<StorageManager>().userId;
    final result = await _farmlandApi.getFarmlandList(userId);

    if (result.isSuccess()) {
      final data = (result as Success).value as Map<String, dynamic>;
      final farmlandList = data['farmland_list'] as List<dynamic>;
      final list = farmlandList.map((e) => Farmland.fromJson(e)).toList();

      return Right(list);
    } else {
      return Left((result as Failure).exception);
    }
  }

  @override
  Future<Result<void>> addFarmlandInfo(
    String ownerName,
    double areaSize,
  ) async {
    final result = await _farmlandApi.postFarmland(
      ownerName,
      areaSize,
    );

    if (result.isSuccess()) {
      return const Right(null);
    } else {
      return Left((result as Failure).exception);
    }
  }

  @override
  Future<Result<FarmlandDateData>> getFarmlandDateData(int farmlandId) async {
    final result = await _farmlandApi.getFarmlandDateData(farmlandId);

    if (result.isSuccess()) {
      final data = (result as Success).value as Map<String, dynamic>;
      final farmlandDateData = FarmlandDateData.fromJson(data);
      _cachedFarmlandDateData = farmlandDateData;

      return Right(farmlandDateData);
    } else {
      return Left((result as Failure).exception);
    }
  }

  @override
  Future<Result<void>> patchFarmlandBasicInfo(
    int farmlandId,
    Uint8List photo,
    double latitude,
    double longitude,
    String filePath,
  ) async {
    final result = await _farmlandApi.patchFarmlandBasicInfo(
      FarmlandUpdateBasicInfoRequest(
        farmlandId: farmlandId,
        photo: photo,
        latitude: latitude,
        longitude: longitude,
      ),
      filePath,
    );

    if (result.isSuccess()) {
      return const Right(null);
    } else {
      return Left((result as Failure).exception);
    }
  }

  @override
  Future<Result<void>> patchFarmlandPlanting(
    int farmlandId,
    DateTime plantingDate,
    String plantingMethod,
    String riceCultivar,
  ) async {
    final result = await _farmlandApi.patchFarmlandPlanting(
      FarmlandPlantingRequest(
        farmlandId: farmlandId,
        plantingDate: plantingDate,
        plantingMethod: plantingMethod,
        riceCultivar: riceCultivar,
      ),
    );

    if (result.isSuccess()) {
      return const Right(null);
    } else {
      return Left((result as Failure).exception);
    }
  }

  @override
  Future<Result<void>> postFarmlandWatering(
      int farmlandId, List<Tuple2<DateTime, DateTime>> pumpDates) async {
    final request = FarmlandWateringRequest(
      farmlandId: farmlandId,
      pumpDates: pumpDates
          .map(
            (data) => PumpDateRequest(
              pumpOnDate: data.item1, // pump on
              pumpOffDate: data.item2, // pump off
            ),
          )
          .toList(),
    );

    final result = await _farmlandApi.postFarmlandWatering(request);

    if (result.isSuccess()) {
      return const Right(null);
    } else {
      return Left((result as Failure).exception);
    }
  }

  @override
  Future<Result<int>> getWateringCount(int farmlandId) async {
    final result = await _farmlandApi.getWateringCount(farmlandId);

    if (result.isSuccess()) {
      final data = (result as Success).value;
      final count = data['watering_count'] ?? 0;

      return Right(count);
    } else {
      return Left((result as Failure).exception);
    }
  }

  @override
  Future<Result<void>> patchFarmlandDrain(
    int farmlandId,
    List<Tuple2<DateTime, DateTime>> drainDates,
  ) async {
    final request = FarmlandDrainRequest(
      farmlandId: farmlandId,
      drainDates: drainDates
          .map(
            (data) => DrainDateRequest(
              waterDrainStartDate: data.item1, // Drain Water Start
              waterDrainEndDate: data.item2, // Drain Water End
            ),
          )
          .toList(),
    );

    final result = await _farmlandApi.patchFarmlandDrain(request);

    if (result.isSuccess()) {
      return const Right(null);
    } else {
      return Left((result as Failure).exception);
    }
  }

  @override
  Future<Result<FarmlandRecordData>> getFarmlandRecordData(
    int farmlandId,
    int? wateringId,
    DateTime targetDate,
  ) async {
    final result = await _farmlandApi.getFarmlandRecordData(
      farmlandId,
      wateringId,
      targetDate,
    );

    if (result.isSuccess()) {
      final data = (result as Success).value;
      final farmlandRecordData = FarmlandRecordData.fromJson(data, targetDate);

      return Right(farmlandRecordData);
    } else {
      return Left((result as Failure).exception);
    }
  }

  @override
  Future<Result<void>> postFarmlandRecord(
    int farmlandId,
    DateTime targetDate, {
    String? fertilizerType,
    double? fertilizerAmount,
    String? pesticideType,
    double? pesticideAmount,
    double? harvestAmount,
    String? diary,
  }) async {
    final result = await _farmlandApi.postFarmlandRecord(FarmlandRecordRequest(
      farmlandId: farmlandId,
      targetDate: targetDate,
      fertilizerType: fertilizerType,
      fertilizerAmount: fertilizerAmount,
      pesticideType: pesticideType,
      pesticideAmount: pesticideAmount,
      harvestAmount: harvestAmount,
      diary: diary,
    ));

    if (result.isSuccess()) {
      return const Right(null);
    } else {
      return Left((result as Failure).exception);
    }
  }

  @override
  Future<Result<void>> patchFarmlandWatering(
    int wateringId,
    int farmlandId,
    double latitude,
    double longitude,
    DateTime recordTime,
    Uint8List photo,
  ) async {
    final request = FarmlandDrainWaterRequest(
      wateringId: wateringId,
      farmlandId: farmlandId,
      latitude: latitude,
      longitude: longitude,
      recordTime: recordTime,
      photo: photo,
    );
    final result = await _farmlandApi.patchFarmlandWatering(request);

    if (result.isSuccess()) {
      return const Right(null);
    } else {
      return Left((result as Failure).exception);
    }
  }

  @override
  Future<Result<List<AwdChangeData>>> getAwdChangeRequestList(
    int farmlandId,
  ) async {
    final result = await _farmlandApi.getAwdChangeHistory(farmlandId);

    if (result.isSuccess()) {
      final data = (result as Success).value as Map<String, dynamic>;
      final list = data['awd_change_list']
          .map<AwdChangeData>((e) => AwdChangeData.fromJson(e))
          .toList();

      return Right(list);
    } else {
      return Left((result as Failure).exception);
    }
  }

  @override
  Future<Result<List<PumpChangeData>>> getPumpChangeRequestList(
    int farmlandId,
  ) async {
    final result = await _farmlandApi.getPumpChangeHistory(farmlandId);

    if (result.isSuccess()) {
      final data = (result as Success).value as Map<String, dynamic>;
      final list = data['pump_change_list']
          .map<PumpChangeData>((e) => PumpChangeData.fromJson(e))
          .toList();

      return Right(list);
    } else {
      return Left((result as Failure).exception);
    }
  }

  @override
  Future<Result<void>> changePumpStatus(
    int farmlandId,
    int wateringId,
    bool isOn,
  ) async {
    final result = await _farmlandApi.changePumpStatus(
      farmlandId,
      wateringId,
      isOn,
    );

    if (result.isSuccess()) {
      return const Right(null);
    } else {
      return Left((result as Failure).exception);
    }
  }

  @override
  FarmlandDateData? getLastFarmlandDateData() {
    return _cachedFarmlandDateData;
  }

  @override
  int? findWateringId(
    DateTime targetDate, {
    bool hasPump = true,
    bool hasDrain = true,
  }) {
    final data = getLastFarmlandDateData();

    if (data == null) {
      return null;
    } else {
      return data.wateringDateList.firstWhereOrNull((e) {
        final hasPumpDate = isSameDay(targetDate, e.pumpOnDate) ||
            isSameDay(targetDate, e.pumpOffDate) ||
            (targetDate.isAfter(e.pumpOnDate!) &&
                targetDate.isBefore(e.pumpOffDate!));
        final hasDrainDate = isSameDay(targetDate, e.waterDrainStartDate) ||
            isSameDay(targetDate, e.waterDrainEndDate) ||
            (targetDate.isAfter(e.waterDrainStartDate!) &&
                targetDate.isBefore(e.waterDrainEndDate!));
        return (hasPump && hasPumpDate) || (hasDrain && hasDrainDate);
      })?.wateringId;
    }
  }

  @override
  DateTime? findPumpOffDate(DateTime targetDate) {
    final data = getLastFarmlandDateData();

    if (data == null) {
      return null;
    } else {
      return data.wateringDateList.firstWhereOrNull((e) {
        final hasPumpDate = isSameDay(targetDate, e.pumpOnDate) ||
            isSameDay(targetDate, e.pumpOffDate) ||
            (targetDate.isAfter(e.pumpOnDate!) &&
                targetDate.isBefore(e.pumpOffDate!));
        return hasPumpDate;
      })?.pumpOffDate;
    }
  }

  @override
  DateTime? findPumpOnDate(DateTime targetDate) {
    final data = getLastFarmlandDateData();

    if (data == null) {
      return null;
    } else {
      return data.wateringDateList.firstWhereOrNull((e) {
        final hasPumpDate = isSameDay(targetDate, e.pumpOnDate) ||
            isSameDay(targetDate, e.pumpOffDate) ||
            (targetDate.isAfter(e.pumpOnDate!) &&
                targetDate.isBefore(e.pumpOffDate!));
        return hasPumpDate;
      })?.pumpOnDate;
    }
  }

  @override
  Future<Result<void>> changeAwdSchedule(
    int farmlandId,
    List<Tuple2<DateTime, DateTime>> dates,
    String reason,
  ) async {
    final request = FarmlandChangeScheduleRequest(
      farmlandId: farmlandId,
      changeDate: dates
          .map(
            (data) => ChangeScheduleDateRequest(
              waterDrainStartDate: data.item1, // Drain Water Start
              waterDrainEndDate: data.item2, // Drain Water End
            ),
          )
          .toList(),
      changeReason: reason,
    );

    final result = await _farmlandApi.postAwdChange(request);

    if (result.isSuccess()) {
      return const Right(null);
    } else {
      return Left((result as Failure).exception);
    }
  }

  @override
  Future<Result<void>> changePumpSchedule(
    int farmlandId,
    List<Tuple2<DateTime, DateTime>> dates,
    String reason,
  ) async {
    final request = FarmlandChangeScheduleRequest(
      farmlandId: farmlandId,
      changeDate: dates
          .map(
            (data) => ChangeScheduleDateRequest(
              waterDrainStartDate: data.item1, // Drain Water Start
              waterDrainEndDate: data.item2, // Drain Water End
            ),
          )
          .toList(),
      changeReason: reason,
    );

    final result = await _farmlandApi.postPumpChange(request);

    if (result.isSuccess()) {
      return const Right(null);
    } else {
      return Left((result as Failure).exception);
    }
  }

  @override
  Future<Result<void>> completeProject(int farmlandId) async {
    final result = await _farmlandApi.patchCompleteProject(farmlandId);

    if (result.isSuccess()) {
      return const Right(null);
    } else {
      return Left((result as Failure).exception);
    }
  }

  @override
  Future<Result<Tuple2<AWDStatus, int>>> getAwdStatus(int farmlandId) async {
    final result = await _farmlandApi.getAWDStatus(farmlandId);

    if (result.isSuccess()) {
      final data = (result as Success).value as Map<String, dynamic>;
      final status = AWDStatus.fromJson(data['awd_status'] ?? '');
      final pumpCount = data['pump_count'] ?? 0;
      return Right(Tuple2(status, pumpCount));
    } else {
      return Left((result as Failure).exception);
    }
  }
}
