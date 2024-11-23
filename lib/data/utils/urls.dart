class Urls {
  Urls._();

  static const String _baseUrl = 'http://35.73.30.144:2005/api/v1';
  static String registration = '$_baseUrl/registration';
  static String login = '$_baseUrl/login';
  static String createTask = '$_baseUrl/createTask';
  static String taskStatusCount = '$_baseUrl/taskStatusCount';
  static String newTask = '$_baseUrl/listTaskByStatus/New';
  static String inProgressTask = '$_baseUrl/listTaskByStatus/Progress';
  static String profileUpdate = '$_baseUrl/ProfileUpdate';

  static String deleteTask(String id) => '$_baseUrl/deleteTask/$id';

  static String updateTask(String id, String status) =>
      '$_baseUrl/updateTaskStatus/$id/$status';

  static String sentOtp(String email) => '$_baseUrl/RecoverVerifyEmail/$email';
  static String otpVerify(String email,String otp) => '$_baseUrl/RecoverVerifyOtp/$email/$otp';
  static String resetPassword = '$_baseUrl/RecoverResetPassword';

}
