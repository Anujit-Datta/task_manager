class Urls{
  static const String _baseUrl='https://task.teamrabbil.com/api/v1';

  static const String registration='$_baseUrl/registration';
  static const String login='$_baseUrl/login';
  static const String createTask='$_baseUrl/createTask';
  static const String taskStatusCount='$_baseUrl/taskStatusCount';
  static const String profileUpdate='$_baseUrl/profileUpdate';

  static const String newTasks='$_baseUrl/listTaskByStatus/New';
  static const String progressTasks='$_baseUrl/listTaskByStatus/Progress';
  static const String completedTasks='$_baseUrl/listTaskByStatus/Completed';
  static const String cancelledTasks='$_baseUrl/listTaskByStatus/Cancelled';

  static String deleteTask(String id)=>'$_baseUrl/deleteTask/$id';

  static String updateTaskStatus(String id,String status)=>'$_baseUrl/updateTaskStatus/$id/$status';

  static String recoverEmailSend(String email)=>'$_baseUrl/RecoverVerifyEmail/$email';
  static String recoverOTPCheck(String email,String code)=>'$_baseUrl/RecoverVerifyOTP/$email/$code';
  static const String recoverResetPassword='$_baseUrl/RecoverResetPass';
}