import 'dart:html';
import 'dart:json';

void get_string(String address, String url_data, callback)
{
  HttpRequest request = new HttpRequest();
  
  request.on.load.add((Event event) {
    callback(request.responseText);
  });
  
  // POST the data to the server
  request.open("POST", address, true);
  request.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
  request.send(url_data); // perform the async POST
}

String get_cookie(String name)
{
  List<String> cookies = document.cookie.split(":");
  for (int i = 0; i < cookies.length; ++i)
    {
      List<String> split = cookies[i].split("=");
      if (split[0] == name)
        {
          return split[1];
        }
    }
  return null;
}

class login_form
{
  DivElement content;
  login_form()
  {
    content = new Element.html("<div>Loading Login Form</div>");
    String uuid = get_cookie("login_uuid");
    if (uuid == null)
      {
        create_form(null);
      } else {
      get_string("get_login_details.php", 'uuid=${uuid}', create_form);
    }
  }
  
  void create_form(String response)
  {
    document.window.alert(response);
    Map parsed_user_details;
    try {
      parsed_user_details = JSON.parse(response);
    } catch(err) {
      document.window.alert(err.toString());
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