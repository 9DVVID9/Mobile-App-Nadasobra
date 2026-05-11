import '../models/impact_stats.dart';
import '../data/mock_data.dart';

class ImpactService {
  static final ImpactService _instance = ImpactService._();
  factory ImpactService() => _instance;
  ImpactService._();

  ImpactStats getStats() => MockData.impactStats;
}
