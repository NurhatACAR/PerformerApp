import 'package:users_app/models/active_nearby_available_performers.dart';

class GeoFireAssistant {
  static List<ActiveNearbyAvailablePerformers>
      activeNearbyAvailablePerformersList = [];

  static void deleteOfflinePerformerFromList(String performersId) {
    int indexNumber = activeNearbyAvailablePerformersList
        .indexWhere((element) => element.performersId == performersId);
    activeNearbyAvailablePerformersList.removeAt(indexNumber);
  }

  static void updateActiveNearbyAvailablePerformersLocation(
      ActiveNearbyAvailablePerformers performerWhoMove) {
    int indexNumber = activeNearbyAvailablePerformersList.indexWhere(
        (element) => element.performersId == performerWhoMove.performersId);

    activeNearbyAvailablePerformersList[indexNumber].locationLatitude =
        performerWhoMove.locationLatitude;
    activeNearbyAvailablePerformersList[indexNumber].locationLongitude =
        performerWhoMove.locationLongitude;
  }
}
