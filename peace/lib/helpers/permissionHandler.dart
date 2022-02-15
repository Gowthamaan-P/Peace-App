import "package:permission_handler/permission_handler.dart";

class PermissionHandler {

  ///Private Function to Request User Permission
  Future<bool> _requestPermissions() async {
    var request = PermissionStatus.denied;
    await Permission.contacts.request().then((value) {
      request = PermissionStatus.granted;
    });

    ///If Permissions verification
    if (request==PermissionStatus.granted){
      return true;
    }
    return false;
  }

  ///Request Call Handler
  Future<bool> requestUserPermission({Function? onPermissionDenied}) async {
    var granted = await _requestPermissions();
    if (!granted) {
      onPermissionDenied!();
    }
    return granted;
  }

  ///Verify a particular Permission status
  Future<bool> hasPermission(Permission permission) async {
    var permissionStatus = await permission.status;
    return permissionStatus == PermissionStatus.granted;
  }
}
