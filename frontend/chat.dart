library chat;
import 'dart:html';
import 'dart:async';
import 'dart:uri';
import 'dart:json';
import 'nav_bar.dart';
import 'util.dart';

class chat_box
{
    String room;
    int last_id;
    DivElement content;
    TextAreaElement chat_window;
    InputElement input_message;
    ButtonElement submit_message;
    Timer refresh;

    chat_box(String _room) {
        room = _room;
        last_id = 0;
        content = new Element.html("<div class=\"chat_window\"></div>");
        chat_window = new Element.html("<textarea cols=60 rows=20 readonly></textarea>");
        input_message = new Element.html("<input name=\"message\" class=\"chat_input\" required>");
        input_message.onKeyPress.listen((e) {
                if (e.keyCode == 13)
                {
                    send_message();
                }
            });
        submit_message = new ButtonElement();
        submit_message..text = "send"
            ..onClick.listen((e) => send_message())
            ..classes.add("chat_submit");
        DivElement bottom_bar = new Element.html("<div></div>");
        content.nodes.add(chat_window);
        content.nodes.add(bottom_bar);
        
        bottom_bar.nodes.add(input_message);
        bottom_bar.nodes.add(submit_message);
        content.nodes.add(new Element.html("<div class=\"spacer\"></div>"));
        refresh = new Timer.periodic(const Duration(seconds:2), (Timer timer) {
                update_box();
            });
        update_box();
    }

    void send_message() {
        if (input_message.value == "")
            return;
        String message = encodeUriComponent(input_message.value);
        input_message.value = "";
        String uuid = get_cookie("login_uuid");
        get_string("chat.php", "action=send&room=${encodeUriComponent(room)}&uuid=${uuid}&message=${message}", (String response) {update_box();});
    }

    void update_box() {
        String messages = get_string_synchronous("chat.php", "action=get&room=${encodeUriComponent(room)}&last_id=${last_id}");
        List message_list = parse(messages);
        for (Map message in message_list) {
            last_id = message["id"];
            chat_window.text = "${chat_window.text}${message['username']}: ${message['message']}\n";
        }
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