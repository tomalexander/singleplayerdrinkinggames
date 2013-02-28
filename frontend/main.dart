import 'dart:html';
import 'nav_bar.dart';
import 'register.dart';
import 'login.dart';
import 'submit_game.dart';

void display_register() {
    query("#content").children.clear();
    query("#content").children.add(new register_form().content);
}

void display_login() {
    query("#content").children.clear();
    query("#content").children.add(new login_form().content);
}

void display_main_page() {
    query("#content").children.clear();
    query("#content").children.add(new Text("Main Page"));
}

void display_game_submission() {
    query("#content").children.clear();
    query("#content").children.add(new submit_game_form().content);
}

void handle_history() {
    window.onPopState.listen((event) {
            String page_name = get_url_variable("page");
            if (page_name == null)
            {
                display_main_page();
                return;
            }
            switch (page_name) {
            case "login":
                display_login();
                break;
            case "register":
                display_register();
                break;
            case "game_submission":
                display_game_submission();
                break;
            case "index":
            default:
                display_main_page();
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
