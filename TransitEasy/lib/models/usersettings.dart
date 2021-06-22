//Represents the user's app settings
class UserSettings {
  final int searchRadiusKm;
  final int busAlertTrigger;
  final int busLocationInterval;

  UserSettings(
      this.searchRadiusKm, this.busAlertTrigger, this.busLocationInterval);
}