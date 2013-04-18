library chat;
import 'dart:html';
import 'dart:async';
import 'dart:uri';
import 'dart:json';
import 'nav_bar.dart';
import 'util.dart';

class chat_box
{
  /*
   * A HTML element that lets the user chat with other users that are also logged in.
   */
    String room;
    int last_id;
    DivElement content;
    TextAreaElement chat_window;
    InputElement input_message;
    ButtonElement submit_message;
    Timer refresh;
    String original_hash;

    chat_box(String _room) {
      /*
       * Sets up the chatbox for a specific room, and adds the proper listeners.
       * 
       * @param _room: Room number for the chatbox.
       */
        room = _room;
        original_hash = window.location.hash;
        last_id = 0;
        content = new Element.html("<div class=\"chat_window\"></div>");
        chat_window = new Element.html("<textarea cols=60 rows=20 readonly></textarea>");
        input_message = new Element.html("<input name=\"message\" class=\"chat_input\" required>");

        //Listener for sending messages via "enter" key.
        input_message.onKeyPress.listen((e) {
                if (e.keyCode == 13)
                {
                    send_message();
                }
            });
        
        //Button for sending messages.
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
        
        //Automaticallly refresh the chat room.
        refresh = new Timer.periodic(const Duration(seconds:2), (Timer timer) {
                if (window.location.hash != original_hash)
                    refresh.cancel();
                update_box();
            });
        update_box();
    }

    void send_message() {
      /*
       * Sends a message to the chat room.
       */
        if (input_message.value == "")
            return;
        String message = encodeUriComponent(input_message.value);
        input_message.value = "";
        String uuid = get_cookie("login_uuid");
        get_string("chat.php", "action=send&room=${encodeUriComponent(room)}&uuid=${uuid}&message=${message}", (String response) {update_box();});
    }

    void update_box() {
      /*
       * Updates the message box.
       */
        String messages = get_string_synchronous("chat.php", "action=get&room=${encodeUriComponent(room)}&last_id=${last_id}");
        List message_list = parse(messages);
        for (Map message in message_list) {
            last_id = message["id"];
            chat_window.text = "${chat_window.text}${message['username']}: ${message['message']}\n";
        }
    }
}
