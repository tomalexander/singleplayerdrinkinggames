library view_game;

import 'dart:html';
import 'dart:json';
import 'dart:uri';
import 'nav_bar.dart';
import 'util.dart';
import 'dart:core';

String encodeMap(Map data) {
    return data.keys.map((k) {
        return '${encodeUriComponent(k)}=${encodeUriComponent(data[k])}';
    }).join('&');
}

class view_game_form {
    DivElement content;

    view_game_form() {
        content = new Element.html("<div></div>");
        content.id = "view_game";
        var gameid = get_url_variable("gameid");
        var postdata = {"gameid":gameid};
        String encodedData = encodeMap(postdata);
        get_string("view_game.php", encodedData, (resp) {
            var parsed_resp = parse(resp);
            var gn_div = new Element.html("<div></div>");
            gn_div.text = "Name : ${parsed_resp["game_name"]}";
            content.children.add(gn_div);
            var rest_div = new Element.html("<div></div>");
            rest_div.text = resp;
            content.children.add(gn_div);
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
    query('#game-view').children.add(new view_game_form().content);
}

