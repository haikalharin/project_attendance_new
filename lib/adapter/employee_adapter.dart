
abstract class IEmployeeRepository {

  Future getListEmployee();
  Future updateEmployee(Map<String, dynamic> body);
  Future deleteEmployee(String id);

}
