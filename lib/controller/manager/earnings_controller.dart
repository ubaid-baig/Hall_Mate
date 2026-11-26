import 'package:get/get.dart';

class MonthEarning {
  const MonthEarning(this.month, this.lakh);

  final String month;
  final double lakh; // in lakh rupees: 4.6 = Rs 4,60,000
}

enum TxType { advance, balance, refund }

class TransactionItem {
  const TransactionItem({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.status,
  });

  final TxType type;
  final String title; // "Advance · Sana Khan"
  final String subtitle; // "HM-1031 · 16 Nov"
  final int amount; // always positive; the type decides + or -
  final String status; // "Paid" / "Cancelled"
}

class EarningsController extends GetxController {
  final String month = 'December 2026';

  final int advances = 375000;
  final int balances = 87500;
  int get total => advances + balances;

  final int pendingAmount = 99000;
  final String pendingNote = 'Hira Ahmed · HM-1044 · due in 2 days';

  final List<MonthEarning> history = const [
    MonthEarning('Jul', 1.9),
    MonthEarning('Aug', 2.6),
    MonthEarning('Sep', 3.4),
    MonthEarning('Oct', 4.1),
    MonthEarning('Nov', 3.2),
    MonthEarning('Dec', 4.6),
  ];

  final List<TransactionItem> transactions = const [
    TransactionItem(
      type: TxType.advance,
      title: 'Advance · Sana Khan',
      subtitle: 'HM-1031 · 16 Nov',
      amount: 150000,
      status: 'Paid',
    ),
    TransactionItem(
      type: TxType.balance,
      title: 'Balance · Faisal family',
      subtitle: 'HM-1019 · 14 Nov',
      amount: 87500,
      status: 'Paid',
    ),
    TransactionItem(
      type: TxType.refund,
      title: 'Refund · Bilal Khan',
      subtitle: 'HM-0987 · 10 Nov',
      amount: 50000,
      status: 'Cancelled',
    ),
  ];

  void export() {
    // TODO: create a CSV / PDF of the transactions and share it.
    Get.snackbar('Export', 'Exporting transactions comes next.');
  }
}