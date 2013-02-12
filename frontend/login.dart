import 'dart:html';
import 'dart:json';

class login_form
{
  DivElement content;
  login_form()
  {
    content = new Element.html("<div>Loading Login Form</div>");
    String uuid = "";
    // for (int i = 0; i < HttpRequest.cookies.length; ++i)
    //   {
    //     Cookie current = HttpRequest.cookies[i];
    //     if (current.name != "uuid")
    //       continue;
    //     uuid = current.value;
    //   }
    if (uuid == "")
      {
        create_form(null);
      } else {
      HttpRequest.request("get_login_details.php?uuid=${uuid}").then(create_form);
    }
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

main()
{
  try
    {
      query("#login").children.add(new login_form().content);
    }
  catch (ex)
    {
      document.window.alert(ex.toString());
    }
}