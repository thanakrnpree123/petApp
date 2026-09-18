import 'package:flutter/foundation.dart';

import '../models/care_log.dart';

enum TimelineFilter {
  all,
  vaccination,
  symptomCheck,
  medical,
  deworming,
  ectoparasite,
  grooming,
  heatCycle,
  other,
}

/// Maps stored care categories onto the dashboard's filter groups.
/// Deworming and ectoparasite treatment each get their own chip, matching
/// how vet notebooks keep them on separate pages. Records still carrying
/// the legacy [CareCategory.parasiteControl] stay under Medical, where
/// they have always appeared — they can't be sorted into one of the two
/// new chips without guessing which the user meant, so re-categorizing
/// one (by editing it) is what moves it. The Heat Cycle chip is only
/// rendered for pets where Pet.tracksHeatCycle is true (intact female
/// dogs/cats); for everyone else those records still appear under All.
TimelineFilter filterForCareCategory(CareCategory category) {
  return switch (category) {
    CareCategory.deworming => TimelineFilter.deworming,
    CareCategory.ectoparasite => TimelineFilter.ectoparasite,
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
