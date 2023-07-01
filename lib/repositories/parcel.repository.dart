import 'package:http/http.dart' as http;

class ParcelRepository {
  AddNewParcel(String ParcelName, double area) async {
    final url = Uri.parse("http://localhost:80/api/new/parcel/farm/1");
    //Parcel
    final parcel = {"parcelName": ParcelName, "area": "$area"};
    //Headers
    final headers = {
      'Authorization':
          'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJpYXQiOjE2ODc4NzY2NTQsImV4cCI6MTY4Nzg4NzQ1NCwicm9sZXMiOlsiUk9MRV9VU0VSIl0sInVzZXJuYW1lIjoiZmFybWVyMy5mb29AZ21haWwuY29tIn0.jqchiMe1a-qMemb8O-E3Ks1vvbp-NCunsQCt8nwdnnGtt8ZCx9ntES3kAKOqnoBzN7a-xzYo0OJoJd-LwNguO3ffRsrY0Rna9SDmxXkyCVoZCZZt8t6Alw9KxJ589QE3GDP5JCeaqnQz835r-0xINX6N5x2-iIn24IbJ3vK5UC_Q1CO5l3BO_M_ztnsPl6Rta3DjKQLK8LUGieed9AIikJHqKMsAf78c50koie62CubiLtXGdnra6oqYwho-eJdQ515U08QQ43b1NZfr0C_6oOMFjbCf58tmFlVyYfkvapRSuyCuKStNeywXb6swMJ8Fl9HoigKNZrWglxqzfKkGTg'
    };

    http.post(url, headers: headers, body: parcel).then((response) {
      if (response.statusCode == 200) {
        // Request successful, print the response
        print('hello');
        return parcel;
      } else {
        // Request failed, print the error message
        print('=======================Request failed==================');
        return throw ("Request failed");
      }
    }).catchError((error) {
      // An error occurred while sending the request
      return throw ("An error occurred while sending the request");
    });
  }
}
