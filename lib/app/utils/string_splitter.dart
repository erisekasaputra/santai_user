String splitCamelCase(String text) {
  // Gunakan regex untuk menyisipkan spasi sebelum huruf kapital, kecuali di awal
  final regex = RegExp(r'(?<=[a-z])(?=[A-Z])');
  // Pisahkan berdasarkan regex, lalu gabungkan dengan spasi
  final result = text.split(regex).join(' ');
  // Pastikan huruf pertama selalu kapital
  return result[0].toUpperCase() + result.substring(1);
}
