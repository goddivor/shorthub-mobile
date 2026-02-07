// lib/screens/admin/pages/admin_analytics_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:iconsax/iconsax.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/theme_extensions.dart';
import '../../../providers/shorts_provider.dart';
import '../../../widgets/common/loading_indicator.dart';
import '../../../widgets/common/error_widget.dart';
import '../../../l10n/app_localizations.dart';

class AdminAnalyticsPage extends ConsumerWidget {
  const AdminAnalyticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(shortsStatsProvider);
    final l10n = AppLocalizations.of(context)!;

    return statsAsync.when(
      data: (stats) => RefreshIndicator(
        onRefresh: () async => ref.invalidate(shortsStatsProvider),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Key Metrics
            _buildKeyMetrics(context, stats, l10n),
            const SizedBox(height: 20),

            // Status Distribution Pie Chart
            _buildChartCard(context,
              title: l10n.analyticsStatusDistribution,
              icon: Iconsax.chart,
              child: SizedBox(
                height: 260,
                child: _StatusPieChart(stats: stats, l10n: l10n),
              ),
            ),
            const SizedBox(height: 16),

            // Bar chart of status counts
            _buildChartCard(context,
              title: l10n.analyticsWeeklyActivity,
              icon: Iconsax.chart_2,
              child: SizedBox(
                height: 240,
                child: _StatusBarChart(stats: stats, l10n: l10n),
              ),
            ),
            const SizedBox(height: 16),

            // Completion funnel
            _buildChartCard(context,
              title: l10n.analyticsCompletionTrend,
              icon: Iconsax.trend_up,
              child: SizedBox(
                height: 200,
                child: _CompletionLineChart(stats: stats, l10n: l10n),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      loading: () => LoadingIndicator(message: l10n.loading),
      error: (error, _) => ErrorDisplay(
        message: l10n.errorLoadingStats,
        onRetry: () => ref.invalidate(shortsStatsProvider),
      ),
    );
  }

  Widget _buildKeyMetrics(BuildContext context, ShortsStats stats, AppLocalizations l10n) {
    final completionRate = stats.total > 0
        ? ((stats.completed + stats.validated + stats.published) / stats.total * 100)
        : 0.0;
    final lateRate = stats.total > 0 ? (stats.rejected / stats.total * 100) : 0.0;
    final avgPerWeek = stats.total > 0 ? (stats.total / 4.0) : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.analyticsKeyMetrics,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _MetricCard(
              label: l10n.analyticsCompletionRate,
              value: '${completionRate.toStringAsFixed(0)}%',
              color: AppColors.success,
              icon: Iconsax.tick_circle,
            ),
            const SizedBox(width: 10),
            _MetricCard(
              label: l10n.analyticsAvgPerWeek,
              value: avgPerWeek.toStringAsFixed(1),
              color: AppColors.primary,
              icon: Iconsax.chart_1,
            ),
            const SizedBox(width: 10),
            _MetricCard(
              label: l10n.analyticsLateRate,
              value: '${lateRate.toStringAsFixed(0)}%',
              color: AppColors.error,
              icon: Iconsax.warning_2,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildChartCard(BuildContext context, {required String title, required IconData icon, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

// ──────────────── Metric Card ────────────────

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _MetricCard({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 22, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(fontSize: 10, color: context.textTertiary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────── Pie Chart ────────────────

class _StatusPieChart extends StatelessWidget {
  final ShortsStats stats;
  final AppLocalizations l10n;

  const _StatusPieChart({required this.stats, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final sections = <_PieData>[
      if (stats.assigned > 0)
        _PieData(l10n.statusAssigned, stats.assigned.toDouble(), AppColors.statusAssigned),
      if (stats.inProgress > 0)
        _PieData(l10n.statusInProgress, stats.inProgress.toDouble(), AppColors.statusInProgress),
      if (stats.completed > 0)
        _PieData(l10n.statusCompleted, stats.completed.toDouble(), AppColors.statusCompleted),
      if (stats.validated > 0)
        _PieData(l10n.statusValidated, stats.validated.toDouble(), AppColors.statusValidated),
      if (stats.published > 0)
        _PieData(l10n.statusPublished, stats.published.toDouble(), AppColors.statusPublished),
      if (stats.rejected > 0)
        _PieData(l10n.statusRejected, stats.rejected.toDouble(), AppColors.statusRejected),
    ];

    if (sections.isEmpty) {
      return Center(
        child: Text(l10n.analyticsNoData, style: TextStyle(color: context.textHint)),
      );
    }

    return Row(
      children: [
        Expanded(
          flex: 3,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 36,
              sections: sections
                  .map((d) => PieChartSectionData(
                        value: d.value,
                        color: d.color,
                        radius: 50,
                        title: '${d.value.toInt()}',
                        titleStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ))
                  .toList(),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: sections.map((d) => _LegendItem(label: d.label, color: d.color)).toList(),
          ),
        ),
      ],
    );
  }
}

class _PieData {
  final String label;
  final double value;
  final Color color;
  _PieData(this.label, this.value, this.color);
}

class _LegendItem extends StatelessWidget {
  final String label;
  final Color color;

  const _LegendItem({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(label, style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}

// ──────────────── Bar Chart ────────────────

class _StatusBarChart extends StatelessWidget {
  final ShortsStats stats;
  final AppLocalizations l10n;

  const _StatusBarChart({required this.stats, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final data = [
      _BarData(l10n.statusAssigned, stats.assigned.toDouble(), AppColors.statusAssigned),
      _BarData(l10n.statusInProgress, stats.inProgress.toDouble(), AppColors.statusInProgress),
      _BarData(l10n.statusCompleted, stats.completed.toDouble(), AppColors.statusCompleted),
      _BarData(l10n.statusValidated, stats.validated.toDouble(), AppColors.statusValidated),
      _BarData(l10n.statusPublished, stats.published.toDouble(), AppColors.statusPublished),
      _BarData(l10n.statusRejected, stats.rejected.toDouble(), AppColors.statusRejected),
    ];

    final maxY = data.map((d) => d.value).fold(0.0, (a, b) => a > b ? a : b);

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxY > 0 ? maxY * 1.2 : 10,
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '${data[group.x.toInt()].label}\n${rod.toY.toInt()}',
                const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= data.length) return const SizedBox.shrink();
                // Short label (first 3 chars)
                final label = data[index].label.length > 4
                    ? data[index].label.substring(0, 4)
                    : data[index].label;
                return SideTitleWidget(
                  meta: meta,
                  child: Text(label, style: TextStyle(fontSize: 9, color: context.textHint)),
                );
              },
              reservedSize: 30,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 32,
              getTitlesWidget: (value, meta) {
                if (value == 0) return const SizedBox.shrink();
                return Text(
                  value.toInt().toString(),
                  style: TextStyle(fontSize: 10, color: context.textHint),
                );
              },
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: maxY > 0 ? (maxY / 4).ceilToDouble().clamp(1, double.infinity) : 2,
          getDrawingHorizontalLine: (value) => FlLine(
            color: context.borderColor,
            strokeWidth: 0.8,
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: data.asMap().entries.map((entry) {
          return BarChartGroupData(
            x: entry.key,
            barRods: [
              BarChartRodData(
                toY: entry.value.value,
                color: entry.value.color,
                width: 22,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _BarData {
  final String label;
  final double value;
  final Color color;
  _BarData(this.label, this.value, this.color);
}

// ──────────────── Line Chart ────────────────

class _CompletionLineChart extends StatelessWidget {
  final ShortsStats stats;
  final AppLocalizations l10n;

  const _CompletionLineChart({required this.stats, required this.l10n});

  @override
  Widget build(BuildContext context) {
    // Simulated funnel: show how shorts flow through statuses
    // Each point represents cumulative count at each stage
    final funnelData = [
      stats.total.toDouble(),
      stats.assigned.toDouble() + stats.inProgress.toDouble() + stats.completed.toDouble() + stats.validated.toDouble() + stats.published.toDouble(),
      stats.inProgress.toDouble() + stats.completed.toDouble() + stats.validated.toDouble() + stats.published.toDouble(),
      stats.completed.toDouble() + stats.validated.toDouble() + stats.published.toDouble(),
      stats.validated.toDouble() + stats.published.toDouble(),
      stats.published.toDouble(),
    ];

    final maxY = funnelData.fold(0.0, (a, b) => a > b ? a : b);

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: maxY > 0 ? (maxY / 4).ceilToDouble().clamp(1, double.infinity) : 2,
          getDrawingHorizontalLine: (value) => FlLine(
            color: context.borderColor,
            strokeWidth: 0.8,
          ),
        ),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                final labels = [
                  l10n.statusRolled,
                  l10n.statusAssigned,
                  l10n.statusInProgress,
                  l10n.statusCompleted,
                  l10n.statusValidated,
                  l10n.statusPublished,
                ];
                final index = value.toInt();
                if (index < 0 || index >= labels.length) return const SizedBox.shrink();
                final label = labels[index].length > 4
                    ? labels[index].substring(0, 4)
                    : labels[index];
                return SideTitleWidget(
                  meta: meta,
                  child: Text(label, style: TextStyle(fontSize: 9, color: context.textHint)),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 32,
              getTitlesWidget: (value, meta) {
                if (value == 0) return const SizedBox.shrink();
                return Text(
                  value.toInt().toString(),
                  style: TextStyle(fontSize: 10, color: context.textHint),
                );
              },
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        minY: 0,
        maxY: maxY > 0 ? maxY * 1.1 : 10,
        lineBarsData: [
          LineChartBarData(
            spots: funnelData
                .asMap()
                .entries
                .map((e) => FlSpot(e.key.toDouble(), e.value))
                .toList(),
            isCurved: true,
            color: AppColors.primary,
            barWidth: 3,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                radius: 4,
                color: AppColors.primary,
                strokeWidth: 2,
                strokeColor: Colors.white,
              ),
            ),
            belowBarData: BarAreaData(
              show: true,
              color: AppColors.primary.withValues(alpha: 0.1),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                return LineTooltipItem(
                  spot.y.toInt().toString(),
                  const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }
}
