String formatCamelCase(String input) {
  if (input.isEmpty) return '';

  // Thêm dấu cách trước các chữ cái viết hoa (trừ ký tự đầu tiên)
  String spaced = input.replaceAllMapped(
    RegExp(r'([A-Z])'),
    (match) => ' ${match.group(0)}',
  );

  // Viết hoa chữ cái đầu mỗi từ
  String result = spaced
      .trim()
      .split(' ')
      .map((word) => word[0].toUpperCase() + word.substring(1))
      .join(' ');

  return result;
}
