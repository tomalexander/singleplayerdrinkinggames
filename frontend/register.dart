library register;
import 'dart:html';
import 'nav_bar.dart';
import 'view_game.dart';
import 'util.dart';

class register_form {
    DivElement content;
    /**
     * Creates the form that allows a user to register on the website.
     */
    register_form() {
        content = new Element.html("<div id=\"register-form\"></div>");
        FormElement form = new Element.html("<form action=\"register.php\" method=\"POST\" onsubmit=\"return false;\"></form>");
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
        de.nodes.add(new Element.html("<span class=\"label\">Confirm Password:</span>"));
        InputElement confirm_password = new Element.html("<input type=\"password\" name=\"confirm_password\" class=\"input\" required>");
        de.nodes.add(confirm_password);
        form.nodes.add(de);
        confirm_password.onInput.listen((e) {
                //Checks to see if the passwords match
                if (password.value != confirm_password.value) {
                    confirm_password.setCustomValidity("The passwords do not match");
                } else {
                    confirm_password.setCustomValidity("");
                }
            });
        
        de = new Element.html("<div class=\"row\"></div>");
        de.nodes.add(new Element.html("<span class=\"label\">E-Mail:</span>"));
        InputElement email = new Element.html("<input type=\"email\" name=\"email\" class=\"input\" required>");
        de.nodes.add(email);
        form.nodes.add(de);

        de = new Element.html("<div class=\"row\"></div>");
        SubmitButtonInputElement submit = new Element.html("<input type=\"submit\" value=\"Create Account\" class=\"submit\">");
        de.nodes.add(submit);
        form.nodes.add(de);

        DivElement failures = new Element.html("<div class=\"row\"></div>");
        form.nodes.add(failures);

        form.onSubmit.listen((e) {
                submit.disabled = true;
                Map register_vars = new Map();
                register_vars["username"] = username.value;
                register_vars["password"] = password.value;
                register_vars["confirm_password"] = confirm_password.value;
                register_vars["email"] = email.value;
                String attempted_register = get_string_synchronous("register.php", encodeMap(register_vars));
                if (attempted_register == "PASSWORDS DONT MATCH") {
                    delete_cookie("login_uuid");
                    submit.disabled = false;
                    failures.nodes.add(new Element.html("<p>Passwords Don't Match</p>"));
                } else if (attempted_register == "Username already taken") {
                    delete_cookie("login_uuid");
                    submit.disabled = false;
                    failures.nodes.add(new Element.html("<p>Username already taken</p>"));
                } else {
                    set_cookie("login_uuid", attempted_register, seconds: 3600*24*30);
                    window.location = "https://singleplayerdrinkinggames.com/";
                }
            });
    }
}
