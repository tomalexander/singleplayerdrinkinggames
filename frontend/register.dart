library register;
import 'dart:html';
import 'nav_bar.dart';

class register_form
{
    DivElement content;
    register_form() {
      /*
       * Creates the form that allows a user to register on the website.
       */
        content = new Element.html("<div id=\"register-form\"></div>");
        FormElement form = new Element.html("<form action=\"register.php\" method=\"POST\"></form>");
        content.nodes.add(form);

        DivElement de = new Element.html("<div class=\"row\"></div>");
        de.nodes.add(new Element.html("<span style=\"label\">Username:</span>"));
        de.nodes.add(new Element.html("<input type=\"text\" name=\"username\" class=\"input\" required>"));
        form.nodes.add(de);

        de = new Element.html("<div class=\"row\"></div>");
        de.nodes.add(new Element.html("<span style=\"label\">Password:</span>"));
        InputElement password = new Element.html("<input type=\"password\" name=\"password\" class=\"input\" required>");
        de.nodes.add(password);
        form.nodes.add(de);

        de = new Element.html("<div class=\"row\"></div>");
        de.nodes.add(new Element.html("<span style=\"label\">Confirm Password:</span>"));
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
        de.nodes.add(new Element.html("<span style=\"label\">E-Mail:</span>"));
        de.nodes.add(new Element.html("<input type=\"email\" name=\"email\" class=\"input\" required>"));
        form.nodes.add(de);

        de = new Element.html("<div class=\"row\"></div>");
        SubmitButtonInputElement submit = new Element.html("<input type=\"submit\" value=\"Create Account\" class=\"submit\">");
        de.nodes.add(submit);
        form.nodes.add(de);
        form.onSubmit.listen((e) {submit.disabled = true;});
    }
}
