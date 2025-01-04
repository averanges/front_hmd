part of '../network.dart';

class FarmlandApi {
  final _client = NetworkClient.getApiClient();

  //https://www.zerostudiobackend.site/haimdall/docs#/Farmland/FarmlandController_getFarmlandList
  /*
  // 유저의 농지 리스트 수집 api
  // 해당 api의 응답값에 들어 있는 `status` 값은 `승인 상태`를 의미함. 이에 따라 `승인 중`, `승인 완료` 등을 보여면 됨
  // 또한 응답값에 포함된 `current_step`은 농사 정보 입력 단계를 의미함. 입력 단계에 대한 자세한 내용은 DB 구조가 나와있는 Lucid Chart를 확인
  // Response: FarmlandListResponse
  */
  Future<NetworkResult> getFarmlandList(String userId) {
    return _client.get(
      uri: '${NetworkConstants.uriFarmlandList}?id=$userId',
    );
  }

  Future<NetworkResult> postFarmland(
    String ownerName,
    double areaSize,
  ) {
    return _client.post(
      uri: NetworkConstants.uriFarmland,
      body: {
        'owner_name': ownerName,
        'area_size': areaSize,
      },
    );
  }

  /*
    https://www.zerostudiobackend.site/haimdall/docs#/Farmland/FarmlandController_updateFarmlandPlanting
    농사정보 입력 api
    모내기 일자
    모내기 방식
    벼 품종
   */
  Future<NetworkResult> patchFarmlandPlanting(FarmlandPlantingRequest request) {
    return _client.patch(
      uri: NetworkConstants.uriFarmlandPlanting,
      body: request.toJson(),
    );
  }

  /*
   https://www.zerostudiobackend.site/haimdall/docs#/Farmland/FarmlandController_createFarmlandWatering
    펌프 일정 등록 api
  */
  Future<NetworkResult> postFarmlandWatering(FarmlandWateringRequest request) {
    return _client.post(
      uri: NetworkConstants.uriFarmlandWatering,
      body: request.toJson(),
    );
  }

  /*
    https://www.zerostudiobackend.site/haimdall/docs#/Farmland/FarmlandController_getWateringCount
    펌프 일정 갯수 수집 API (GET)
    해당 값 갯수 만큼 물빼기 일정을 추가 ui를 보여주시면 될 것 같습니다
   */
  Future<NetworkResult> getWateringCount(int farmlandId) {
    return _client.get(
      uri:
          '${NetworkConstants.uriFarmlandWateringCount}?farmland_id=$farmlandId',
    );
  }

  /*
    https://www.zerostudiobackend.site/haimdall/docs#/Farmland/FarmlandController_registerFarmlandDrain
    물빼기 일정 등록 API (PATCH)
   */
  Future<NetworkResult> patchFarmlandDrain(FarmlandDrainRequest request) {
    return _client.patch(
      uri: NetworkConstants.uriFarmlandDrain,
      body: request.toJson(),
    );
  }

  /*
    https://www.zerostudiobackend.site/haimdall/docs#/Farmland/FarmlandController_getFarmlandDateData
    [GET] 모내기, 펌프, 물빼기 일정에 대한 데이터 수집 api
    해당 api를 사용하여 얻은 데이터를 캘린더에 보여주시면 될 것 같습니다
    Response: FarmlandDateDate
   */
  Future<NetworkResult> getFarmlandDateData(int farmlandId) {
    return _client.get(
      uri: '${NetworkConstants.uriFarmlandDateData}?farmland_id=$farmlandId',
    );
  }

  /*
    https://www.zerostudiobackend.site/haimdall/docs#/Farmland/FarmlandController_getFarmlandRecordData
    [GET] 선택한 날짜에 기록 정보가 있는지 확인하는 api
    물빼기, 비료, 농약, 수확, 일지에 대한 등록여부를 boolean 값으로 반환
    Response: FarmlandRecordingStatus
   */
  Future<NetworkResult> getFarmlandRecordData(
    int farmlandId,
    int? wateringId,
    DateTime targetDate,
  ) {
    var uri = NetworkConstants.uriFarmlandRecord;
    uri += '?farmland_id=$farmlandId';
    if (wateringId != null) {
      uri += '&watering_id=$wateringId';
    }
    uri += '&target_date=${targetDate.toIso8601String()}';
    return _client.get(uri: uri);
  }

  /*
   https://www.zerostudiobackend.site/haimdall/docs#/Farmland/FarmlandController_completeProject
   [PATCH] 해당 농지의 프로젝트 진행 상태를 완료로 변경
   */
  Future<NetworkResult> patchCompleteProject(int farmlandId) {
    return _client.patch(
      uri: NetworkConstants.uriFarmlandCompleteProject,
      body: {
        'farmland_id': farmlandId,
      },
    );
  }

  /*
      https://www.zerostudiobackend.site/haimdall/docs#/Farmland/FarmlandController_registerScheduleChange
      [POST] 일정 변경 요청 api
      물 빼기 일정 갯수는 해당 농지에 등록된 물 빼기 일정 갯수만큼 전송해야 하며, 해당 갯수 정보는 watering_count api를 사용
   */
  Future<NetworkResult> postAwdChange(
    FarmlandChangeScheduleRequest request,
  ) {
    return _client.post(
      uri: NetworkConstants.uriFarmlandAwdChange,
      body: request.toAwdJson(),
    );
  }

  Future<NetworkResult> postPumpChange(
    FarmlandChangeScheduleRequest request,
  ) {
    return _client.post(
      uri: NetworkConstants.uriFarmlandPumpChange,
      body: request.toPumpJson(),
    );
  }

  /*
    https://www.zerostudiobackend.site/haimdall/docs#/Farmland/FarmlandController_updateFarmlandBasicInfo
    [PATCH] 농지 기본 정보 등록 api (이미지, 경도, 위도)
   */
  Future<NetworkResult> patchFarmlandBasicInfo(
      FarmlandUpdateBasicInfoRequest request, String filePath) {

    return _client.multipartRequest(
      uri: NetworkConstants.uriFarmlandBasicInfo,
      method: HttpMethod.patch,
      body: request.toJson(),
      file: http.MultipartFile.fromBytes(
        'image',
        request.photo,
        filename: 'upload.jpg',
      ),
    );
  }

  Future<NetworkResult> postFarmlandRecord(FarmlandRecordRequest request) {
    return _client.post(
      uri: NetworkConstants.uriFarmlandRecord,
      body: request.toJson(),
    );
  }

  // 물빼기 기록 API (사진 업로드)
  Future<NetworkResult> patchFarmlandWatering(
      FarmlandDrainWaterRequest request) {
    return _client.multipartRequest(
      uri: NetworkConstants.uriFarmlandWatering,
      method: HttpMethod.patch,
      body: request.toJson(),
      file: http.MultipartFile.fromBytes(
        'image',
        request.photo,
        filename: 'upload.jpg',
      ),
      headers: {
        'Content-Type': 'multipart/form-data',
      },
    );
  }

  // AWD 스케쥴 변경 요청 내역 조회
  Future<NetworkResult> getAwdChangeHistory(int farmlandId) {
    return _client.get(
      uri:
          '${NetworkConstants.uriFarmlandAwdChangeList}?farmland_id=$farmlandId',
    );
  }

  // 펌프 스케쥴 변경 요청 내역 조회
  Future<NetworkResult> getPumpChangeHistory(int farmlandId) {
    return _client.get(
      uri:
          '${NetworkConstants.uriFarmlandPumpChangeList}?farmland_id=$farmlandId',
    );
  }

  // 펌프 기록 On/Off
  Future<NetworkResult> changePumpStatus(
    int farmlandId,
    int wateringId,
    bool isOn,
  ) {
    return _client.patch(
      uri: NetworkConstants.uriFarmlandPump,
      body: {
        'farmland_id': farmlandId,
        'watering_id': wateringId,
        'type': isOn,
      },
    );
  }

  // [GET] AWD Status
  Future<NetworkResult> getAWDStatus(int farmlandId) {
    return _client.get(
      uri: '${NetworkConstants.uriFarmlandAwdStatus}?farmland_id=$farmlandId',
    );
  }
}
