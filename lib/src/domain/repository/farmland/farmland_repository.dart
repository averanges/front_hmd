import 'package:flutter/services.dart';
import 'package:haimdall/src/common/alias/alias.dart';
import 'package:haimdall/src/domain/model/farmland/calendar/farmland_date_data.dart';
import 'package:haimdall/src/domain/model/farmland/farmland.dart';
import 'package:haimdall/src/domain/model/farmland/recording/farmland_record_data.dart';
import 'package:haimdall/src/domain/model/history/change/change_request_data.dart';
import 'package:haimdall/src/presentation/farmland/home/progress/farmland_progress_controller.dart';
import 'package:tuple/tuple.dart';

abstract class FarmlandRepository {
  Future<Result<List<Farmland>>> getFarmlandList();

  Future<Result<void>> addFarmlandInfo(
    String ownerName,
    double areaSize,
  );

  Future<Result<FarmlandDateData>> getFarmlandDateData(int farmlandId);

  Future<Result<void>> patchFarmlandBasicInfo(
    int farmlandId,
    Uint8List photo,
    double latitude,
    double longitude,
    String filePath,
  );

  Future<Result<void>> patchFarmlandPlanting(
    int farmlandId,
    DateTime plantingDate,
    String plantingMethod,
    String riceCultivar,
  );

  Future<Result<void>> postFarmlandWatering(
    int farmlandId,
    List<Tuple2<DateTime, DateTime>> pumpDates,
  );

  Future<Result<int>> getWateringCount(int farmlandId);

  Future<Result<void>> patchFarmlandDrain(
    int farmlandId,
    List<Tuple2<DateTime, DateTime>> drainDates,
  );

  Future<Result<FarmlandRecordData>> getFarmlandRecordData(
    int farmlandId,
    int? wateringId,
    DateTime targetDate,
  );

  Future<Result<void>> postFarmlandRecord(
    int farmlandId,
    DateTime targetDate, {
    String? fertilizerType,
    double? fertilizerAmount,
    String? pesticideType,
    double? pesticideAmount,
    double? harvestAmount,
    String? diary,
  });

  Future<Result<void>> patchFarmlandWatering(
    int wateringId,
    int farmlandId,
    double latitude,
    double longitude,
    DateTime recordTime,
    Uint8List photo,
  );

  Future<Result<List<AwdChangeData>>> getAwdChangeRequestList(
    int farmlandId,
  );

  Future<Result<List<PumpChangeData>>> getPumpChangeRequestList(
    int farmlandId,
  );

  Future<Result<void>> changePumpStatus(
    int farmlandId,
    int wateringId,
    bool isOn,
  );

  Future<Result<void>> changeAwdSchedule(
    int farmlandId,
    List<Tuple2<DateTime, DateTime>> dates,
    String reason,
  );

  Future<Result<void>> changePumpSchedule(
    int farmlandId,
    List<Tuple2<DateTime, DateTime>> dates,
    String reason,
  );

  Future<Result<Tuple2<AWDStatus, int>>> getAwdStatus(int farmlandId);

  Future<Result<void>> completeProject(int farmlandId);

  FarmlandDateData? getLastFarmlandDateData();

  int? findWateringId(
    DateTime targetDate, {
    bool hasPump,
    bool hasDrain,
  });

  DateTime? findPumpOnDate(DateTime targetDate);

  DateTime? findPumpOffDate(DateTime targetDate);
}
