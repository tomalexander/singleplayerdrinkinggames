library register;
import 'dart:html';
import 'nav_bar.dart';

class chat_box
{
    String room;
    DivElement content;
    TextAreaElement chat_window;
    InputElement input_message;
    ButtonElement submit_message;

    chat_box(String _room) {
        room = _room;
        content = new Element.html("<div></div>");
        chat_window = new Element.html("<textarea></textarea>");
        input_message = new Element.html("<input name=\"message\" required>");
        submit_message = new ButtonElement();
        submit_message..text = "send"
            ..onClick.listen((e) => send_message());
        content.nodes.add(chat_window);
        content.nodes.add(input_message);
        content.nodes.add(submit_message);
    }

    void send_message() {
        document.window.alert("send_message");
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
    query('#main').children.add(new chat_box("main").content);
}