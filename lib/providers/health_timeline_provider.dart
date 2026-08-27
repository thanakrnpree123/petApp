import 'package:flutter/foundation.dart';

import '../models/care_log.dart';

enum TimelineFilter { all, vaccination, medical, grooming, heatCycle, other }

/// Maps stored care categories onto the dashboard's filter groups.
/// Parasite control is preventive medicine. The Heat Cycle chip is only
/// rendered for pets where Pet.tracksHeatCycle is true (intact female
/// dogs/cats); for everyone else those records still appear under All.
TimelineFilter filterForCareCategory(CareCategory category) {
  return switch (category) {
    CareCategory.parasiteControl ||
    CareCategory.medicalSurgery => TimelineFilter.medical,
    CareCategory.grooming => TimelineFilter.grooming,
    CareCategory.heatCycle => TimelineFilter.heatCycle,
    CareCategory.other => TimelineFilter.other,
  };
}

class HealthTimelineProvider extends ChangeNotifier {
  TimelineFilter _filter = TimelineFilter.all;

  TimelineFilter get filter => _filter;

  void setFilter(TimelineFilter filter) {
    if (filter == _filter) return;
    _filter = filter;
    notifyListeners();
  }

  bool matches(TimelineFilter kind) =>
      _filter == TimelineFilter.all || _filter == kind;
}
