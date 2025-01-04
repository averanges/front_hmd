import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AwdScheduleItemController extends GetxController {
  final isShowCalendar = false.obs;
  final drainWaterDate = Rxn<DateTime>();
  final drainWaterFocusedDay = DateTime.now().obs;
  final drainWaterStart = Rxn<DateTime>();
  final drainWaterEnd = Rxn<DateTime>();
  final drainWaterPlantingDate = ''.obs;
  final dateFormat = DateFormat('yyyy-MM-dd');

  void onTapDrainWaterPlanting() {
    isShowCalendar.toggle();
  }

  void onSelectedDay(DateTime selectedDay) {
    drainWaterDate.value = selectedDay;
    // onTapDrainWaterPlanting();
  }

  void onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    drainWaterDate.value = null;
    drainWaterFocusedDay.value = focusedDay;
    drainWaterStart.value = start;
    drainWaterEnd.value = end;

    if (start != null && end != null) {
      drainWaterPlantingDate.value =
          '${dateFormat.format(start)} ~ ${dateFormat.format(end)}';
      onTapDrainWaterPlanting();
    }
  }
}
