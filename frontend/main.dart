import 'dart:html';
import 'nav_bar.dart';
import 'register.dart';
import 'login.dart';

void display_register() {
    window.history.pushState(null, "Register an Account", "${window.location.pathname}#register");
    query("#content").children.clear();
    query("#content").children.add(new register_form().content);
}

void display_login() {
    window.history.pushState(null, "Log In", "${window.location.pathname}#login");
    query("#content").children.clear();
    query("#content").children.add(new login_form().content);
}

void handle_history() {
    window.onPopState.listen((event) {
            String page_name = window.location.hash.replaceFirst('#', '');
            switch (page_name) {
            case "login":
                display_login();
                break;
            case "register":
                display_register();
                break;
            default:
                break;
            }
        });
}

main() {

    try {
        main_wrapped();
    } catch (ex) {
        document.window.alert(ex.toString());
    }
}

main_wrapped() {
  query('#main').children.add(new nav_bar().content);
  DivElement content = new Element.html("<div id=\"content\">content goes here</div>");
  query('#main').children.add(content);
  handle_history();
}
