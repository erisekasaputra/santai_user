import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:intl/intl.dart';

class TimezoneService {
  Future<void> initializeTimeZones() async {
    // Inisialisasi timezone jika diperlukan
    await FlutterTimezone.getLocalTimezone();
  }

  Future<String> getDeviceTimezone() async {
    // Mendapatkan nama timezone perangkat
    String timezone = await FlutterTimezone.getLocalTimezone();
    
    return timezone; // Contoh: "Asia/Jakarta"
  }

  Future<Map<String, String>> getDetailedDeviceTimezone() async {
    await initializeTimeZones();
    
    // Mendapatkan nama timezone
    String timezone = await getDeviceTimezone();
    
    // Mendapatkan waktu saat ini di timezone tersebut
    final now = DateTime.now().toUtc().add(Duration(hours: DateTime.now().timeZoneOffset.inHours));
    
    // Menghitung offset
    final offset = now.timeZoneOffset;
    final offsetHours = offset.inHours;
    final offsetMinutes = offset.inMinutes.remainder(60).abs();
    
    final offsetSign = offset.isNegative ? '-' : '+';
    final offsetString = '${offsetSign}${offsetHours.abs().toString().padLeft(2, '0')}:${offsetMinutes.toString().padLeft(2, '0')}';
    
    return {
      'name': timezone,
      'abbreviation': DateFormat('zzzz').format(now),
      'offset': offsetString,
      'currentTime': DateFormat('yyyy-MM-dd HH:mm:ss').format(now),
      'isDST': (offset.isNegative && offsetHours < 0) ? 'Yes' : 'No',
    };
  }
}