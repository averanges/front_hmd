import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PumpScheduleItemController extends GetxController {
  final isShowCalendar = false.obs;
  final pumpDate = Rxn<DateTime>();
  final pumpFocusedDay = DateTime.now().obs;
  final pumpStart = Rxn<DateTime>();
  final pumpEnd = Rxn<DateTime>();
  final pumpPlantingDate = ''.obs;
  final dateFormat = DateFormat('yyyy-MM-dd');

  void onTapPumpPlanting() {
    isShowCalendar.toggle();
  }

  void onSelectedDay(DateTime selectedDay) {
    pumpDate.value = selectedDay;
    // onTapPumpPlanting();
  }

  void onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    pumpDate.value = null;
    pumpFocusedDay.value = focusedDay;
    pumpStart.value = start;
    pumpEnd.value = end;

    if (start != null && end != null) {
      pumpPlantingDate.value =
          '${dateFormat.format(start)} ~ ${dateFormat.format(end)}';
      onTapPumpPlanting();
    }
  }
}
