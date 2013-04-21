library login;

import 'dart:html';
import 'dart:json';
import 'util.dart';
import 'view_game.dart';

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
        Map ret = parse(response);
        if (ret.containsKey("id")) {
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
    login_form() {
      /*
       * Structure for the login box.
       */
        content = new Element.html("<div id=\"login-form\">Loading Login Form</div>");
        Map user_data = get_login_details();
        if (user_data == null) {
            //User not logged in
            create_form();
        } else {
            content.nodes.clear();
            content.nodes.add(new Text("Logged in as: ${user_data['username']}"));
            content.nodes.add(new Element.html("<br>"));
            content.nodes.add(new Element.html("<a href=\"logout.php\">Log Out</a>"));
        }
    }
  
    void create_form() {
      /*
       * Generates the form.
       */
        content.nodes.clear();
        FormElement form = new Element.html("<form action=\"login.php\" method=\"POST\" onsubmit=\"return false;\"></form>");
        content.nodes.add(form);

        DivElement de = new Element.html("<div class=\"row\"></div>");
        de.nodes.add(new Element.html("<span class=\"label\">Username:</span>"));
        InputElement username = new Element.html("<input type=\"text\" name=\"username\" class=\"input\" required>");
        de.nodes.add(username);
        form.nodes.add(de);

        de = new Element.html("<div class=\"row\"></div>");
        de.nodes.add(new Element.html("<span class=\"label\">Password:</span>"));
        InputElement password = new Element.html("<input type=\"password\" name=\"password\" class=\"input\" required>");
        de.nodes.add(password);
        form.nodes.add(de);

        de = new Element.html("<div class=\"row\"></div>");
        SubmitButtonInputElement submit = new Element.html("<input type=\"submit\" value=\"Log In\" class=\"submit\">");
        de.nodes.add(submit);
        form.nodes.add(de);

        DivElement failures = new Element.html("<div class=\"row\"></div>");
        form.nodes.add(failures);

        form.onSubmit.listen((e) {
                submit.disabled = true;
                Map login_vars = new Map();
                login_vars["username"] = username.value;
                login_vars["password"] = password.value;
                String attempted_login = get_string_synchronous("login.php", encodeMap(login_vars));
                if (attempted_login == "Log In Failed") {
                    delete_cookie("login_uuid");
                    submit.disabled = false;
                    failures.nodes.add(new Element.html("<p>Incorrect Username or Password</p>"));
                } else {
                    set_cookie("login_uuid", attempted_login, seconds: 3600*24*30);
                    window.location = "https://singleplayerdrinkinggames.com/";
                }
            });
    }
}
