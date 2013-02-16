import 'dart:html';
import 'nav_bar.dart';

class register_form
{
    DivElement content;
    register_form() {
        content = new Element.html("<div></div>");
        FormElement form = new Element.html("<form action=\"register.php\" method=\"POST\"></form>");
        content.nodes.add(form);
        form.nodes.add(new Text("Username:"));
        form.nodes.add(new Element.html("<input type=\"text\" name=\"username\" required>"));
        form.nodes.add(new Element.html("<br>"));
        form.nodes.add(new Text("Password:"));
        InputElement password = new Element.html("<input type=\"password\" name=\"password\" required>");
        form.nodes.add(password);
        form.nodes.add(new Element.html("<br>"));
        form.nodes.add(new Text("Confirm Password:"));
        InputElement confirm_password = new Element.html("<input type=\"password\" name=\"confirm_password\" required>");
        form.nodes.add(confirm_password);
        confirm_password.on.input.add((e) {
                if (password.value != confirm_password.value) {
                    confirm_password.setCustomValidity("The passwords do not match");
                } else {
                    confirm_password.setCustomValidity("");
                }
            });
        form.nodes.add(new Element.html("<br>"));
        form.nodes.add(new Text("E-Mail:"));
        form.nodes.add(new Element.html("<input type=\"email\" name=\"email\" required>"));
        form.nodes.add(new Element.html("<br>"));
        SubmitButtonInputElement submit = new Element.html("<input type=\"submit\" value=\"Create Account\">");
        form.nodes.add(submit);
        form.on.submit.add((e) {submit.disabled = true;});
    }
}

main() {
    try {
        main_wrapped();
    } on Exception catch (ex) {
        document.window.alert(ex.toString());
    }
}

main_wrapped() {
    query('#main').children.add(new nav_bar().content);
    var reg_div = new DivElement();
    reg_div.id = "registration";
    query('#main').children.add(reg_div);
    query('#registration').children.add(new register_form().content);
}
