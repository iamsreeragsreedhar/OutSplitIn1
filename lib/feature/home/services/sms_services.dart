class SmsRecord {
  final String? id;
  final String? address;
  final String? body;
  final DateTime? date;
  final String? sender;

  const SmsRecord({
    this.id,
    this.address,
    this.body,
    this.date,
    this.sender,
  });
}

class SmsServices {
  Future<bool> requestPermission() async {
    return false;
  }

  Future<List<SmsRecord>> getSmsMessages() async {
    return const [];
  }
}
