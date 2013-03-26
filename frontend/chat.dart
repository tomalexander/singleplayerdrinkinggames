library register;
import 'dart:html';
import 'nav_bar.dart';

class chat_box
{
    String room;
    DivElement content;
    TextAreaElement chat_window;

    chat_box(String _room) {
        room = _room;
        content = new Element.html("<div></div>");
        FormElement form = new Element.html("<form action=\"chat.php\" method=\"POST\"></form>");
        content.nodes.add(form);
        chat_window = new Element.html("<textarea></textarea>");
        content.nodes.add(chat_window);
    }
}

void main() {
    try {
        main_wrapped();
    } on Exception
    catch (ex) {
        document.window.alert(ex.toString());
    }
}

void main_wrapped() {
    query('#main').children.add(new chat_box().content);
}