import 'dart:html';
import 'nav_bar.dart';
import 'register.dart';
import 'login.dart';

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

String get_url_variable(String name)
{
    String hash_string = window.location.hash.replaceFirst('#', '');
    List<String> variables = hash_string.split(";");
    for (int i = 0; i < variables.length; ++i) {
        List<String> split = variables[i].split("=");
        if (split[0].trim() == name.trim()) {
            return split[1].trim();
        }
    }
    return null;
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
