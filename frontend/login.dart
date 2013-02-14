library login;

import 'dart:html';
import 'dart:json';
import 'util.dart';

/** 
 * Get the login details for the current user
 *
 *
 * @return A map with keys "id" "username" and "email" for the current logged in user, or null if the user is not logged in
 */
Map get_login_details()
{
  String uuid = get_cookie("login_uuid");
  String response = get_string_synchronous("get_login_details.php", 'uuid=${uuid}');
  try {
    Map ret = JSON.parse(response);
    if (ret.containsKey("id"))
      {
        return ret;
      } else {
      return null;
    }
  } catch (err) {
    return null;
  }
}

class login_form
{
  DivElement content;
  login_form()
  {
    content = new Element.html("<div>Loading Login Form</div>");
    Map user_data = get_login_details();
    if (user_data == null)
      {
        //User not logged in
        content.nodes.clear();
        content.nodes.add(new Text("Not Logged In"));
      } else {
      content.nodes.clear();
      content.nodes.add(new Text("Logged in as: ${user_data['username']}"));
    }
  }
  
  void create_form(String response)
  {
    
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