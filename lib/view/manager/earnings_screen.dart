import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';
import 'package:hall_mate/controller/manager/earnings_controller.dart';
import 'package:hall_mate/widgets/manager/manager_widget.dart';
import 'package:hall_mate/widgets/manager/venue_setup.dart';

class EarningsScreen extends StatelessWidget {
  const EarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.of(context).size.height;
    final sw = MediaQuery.of(context).size.width;
    final colors = AppColors.of(context);
    final EarningsController c = Get.put(EarningsController());

    return Scaffold(
      backgroundColor: colors.bgSurface,
      body: SafeArea(
        child: Column(
          children: [
            const ManagerTopBar(title: 'Earnings', subtitle: 'Shaan Banquet Hall'),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(sw * 0.05, sh * 0.02, sw * 0.05, sh * 0.03),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ---------- Month picker (look only for now) ----------
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: colors.bgScreen,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: colors.borderStrong),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.calendar_today_outlined,
                              size: 15, color: colors.textSecondary),
                          const SizedBox(width: 8),
                          Text(c.month, style: AppTextStyles.titleSmall()),
                          const SizedBox(width: 4),
                          Icon(Icons.keyboard_arrow_down,
                              size: 18, color: colors.textSecondary),
                        ],
                      ),
                    ),
                    SizedBox(height: sh * 0.018),

                    // ---------- Green summary card ----------
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: colors.primary,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Received this month',
                            style: AppTextStyles.bodySmall(
                                color: colors.textOnPrimary.withOpacity(0.75)),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Rs ${formatRs(c.total)}',
                            style: AppTextStyles.h1(color: colors.textOnPrimary)
                                .copyWith(fontSize: 30),
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Expanded(
                                  child: _MiniStat(
                                      label: 'Advances', amount: c.advances)),
                              const SizedBox(width: 10),
                              Expanded(
                                  child: _MiniStat(
                                      label: 'Balances', amount: c.balances)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: sh * 0.018),

                    // ---------- Bar chart ----------
                    _HistoryChart(history: c.history),
                    SizedBox(height: sh * 0.018),

                    // ---------- Pending advance warning ----------
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: venueAmber.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: venueAmber.withOpacity(0.45)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.schedule, size: 22, color: venueAmber),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Rs ${formatRs(c.pendingAmount)} advance pending',
                                  style: AppTextStyles.titleSmall(color: venueAmber),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  c.pendingNote,
                                  style: AppTextStyles.bodySmall(color: venueAmber),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: sh * 0.025),

                    // ---------- Transactions ----------
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Transactions', style: venueCardTitle()),
                        GestureDetector(
                          onTap: c.export,
                          child: Text('Export',
                              style: AppTextStyles.titleSmall(
                                  color: colors.primaryInk)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: colors.bgScreen,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: colors.borderStrong),
                      ),
                      child: Column(
                        children: [
                          for (int i = 0; i < c.transactions.length; i++) ...[
                            _TxRow(item: c.transactions[i]),
                            if (i != c.transactions.length - 1)
                              const VenueRowDivider(),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================================
// "Advances Rs 3,75,000" box inside the green card
// =====================================================================

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.label, required this.amount});

  final String label;
  final int amount;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.textOnPrimary.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: AppTextStyles.bodySmall(
                  color: colors.textOnPrimary.withOpacity(0.75))),
          const SizedBox(height: 2),
          Text('Rs ${formatRs(amount)}',
              style: AppTextStyles.titleSmall(color: colors.textOnPrimary)),
        ],
      ),
    );
  }
}

// =====================================================================
// Last 6 months bar chart (drawn with plain containers, no package)
// =====================================================================

class _HistoryChart extends StatelessWidget {
  const _HistoryChart({required this.history});

  final List<MonthEarning> history;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final maxLakh = history.map((e) => e.lakh).reduce((a, b) => a > b ? a : b);
    const maxBarHeight = 100.0;

    return VenueCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Last 6 months', style: venueCardTitle()),
              Text('Rs lakh',
                  style: AppTextStyles.bodySmall(color: colors.textMuted)),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 150,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (int i = 0; i < history.length; i++)
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          history[i].lakh.toStringAsFixed(1),
                          style: AppTextStyles.bodySmall(
                            color: i == history.length - 1
                                ? colors.textPrimary
                                : colors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          height: history[i].lakh / maxLakh * maxBarHeight,
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          decoration: BoxDecoration(
                            color: i == history.length - 1
                                ? colors.primary
                                : colors.primary.withOpacity(0.3),
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(8)),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          history[i].month,
                          style: AppTextStyles.bodySmall(color: colors.textMuted),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// One transaction row
// =====================================================================

class _TxRow extends StatelessWidget {
  const _TxRow({required this.item});

  final TransactionItem item;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final isRefund = item.type == TxType.refund;

    final IconData icon = switch (item.type) {
      TxType.advance => Icons.account_balance_wallet_outlined,
      TxType.balance => Icons.receipt_long_outlined,
      TxType.refund => Icons.undo_rounded,
    };
    final Color tint = isRefund ? colors.danger : colors.primaryInk;
    final bool paid = item.status == 'Paid';

    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: tint.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: tint),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, style: AppTextStyles.titleSmall()),
                const SizedBox(height: 2),
                Text(item.subtitle,
                    style: AppTextStyles.bodySmall(color: colors.textMuted)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isRefund ? '–' : '+'} Rs ${formatRs(item.amount)}',
                style: AppTextStyles.titleSmall(color: tint),
              ),
              const SizedBox(height: 4),
              ManagerBadge(
                text: item.status,
                color: paid ? colors.primaryInk : colors.textSecondary,
                small: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}