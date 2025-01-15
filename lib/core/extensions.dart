extension StringToDate on String {
  DateTime toDate() {
    final dia = int.parse(split('/')[0]);
    final mes = int.parse(split('/')[1]);
    final ano = int.parse(split('/')[2]);
    return DateTime(ano, mes, dia);
  }
}
