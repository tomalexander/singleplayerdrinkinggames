import 'dart:html';

class login_form
{
  DivElement content;
  login_form()
  {
    content = new Element.html("<div>Loading Login Form</div>");
    String uuid = "";
    for (int i = 0; i < HttpRequest.cookies.length; ++i)
      {
        Cookie current = HttpRequest.cookies[i];
        if (current.name != "uuid")
          continue;
        uuid = current.value;
      }
    var request = new HttpRequest.get("get_login_details.php?uuid=${uuid}", create_form);
  }
  
  void create_form(HttpRequest req)
  {
    Map parsed_user_details;
    try {
      parsed_user_details = JSON.parse(req.responseText);
    } on Exception catch (ex) {
      document.window.alert(ex.toString());
    }
  }
}
