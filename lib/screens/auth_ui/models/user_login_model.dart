class UserLoggedInDataModel {
  UserLoggedInDataModel({
    this.userId,
    this.userName,
    this.emailId,
    this.accounts,
  });

  UserLoggedInDataModel.fromJson(Map<String, dynamic> json) {
    userId = json['id'];
    userName = json['name'];
    emailId = json['email'];
    if (json['accounts'] != null) {
      accounts = <AccountsUsersDataList>[];
      for (final ele in json['accounts'] as List) {
        accounts!.add(AccountsUsersDataList.fromJson(ele));
      }
    }
  }
  String? userId;
  String? userName;
  String? emailId;
  List<AccountsUsersDataList>? accounts;
}

class AccountsUsersDataList {
  AccountsUsersDataList({this.id, this.name, this.privileges});

  AccountsUsersDataList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['privileges'] != null) {
      privileges = <String>[];
      for (final ele in json['privileges'] as List) {
        privileges!.add(ele);
      }
    }
  }
  String? id;
  String? name;
  List<String>? privileges;
}

// "id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
// "name": "string",
// "email": "user@example.com",
// "accounts": [
//   {
//     "id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
//     "name": "string"
//   }
// ]
