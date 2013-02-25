import 'dart:html';
import 'dart:json';
import 'dart:uri';
import 'nav_bar.dart';
import 'util.dart';

String encodeMap(Map data) {
    return data.keys.map((k) {
        return '${encodeUriComponent(k)}=${encodeUriComponent(data[k])}';
    }).join('&');
}

class show_game_form {
    DivElement content;

    show_game_form() {
        content = new Element.html("<div></div>");
        content.id = "view_game";
        var hash = window.location.hash.slice(1);
        var postdata = {"gameid":hash};
        String encodedData = encodeMap(postdata);
        get_string("view_game.php", encodedData, (resp) {
            content.text = resp;
        });
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
    query('#main').children.add(new nav_bar().content);
    var game_div = new DivElement();
    game_div.id = "game-view";
    query('#main').children.add(game_div);
    query('#game-view').children.add(new show_game_form().content);
}

