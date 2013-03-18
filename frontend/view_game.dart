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

    display_div(content) {
        var new_div = new Element.html("<div></div>");
        new_div.text = content;
        this.content.children.add(new_div);
    }

    view_game_form() {
        this.content = new Element.html("<div></div>");
        this.content.id = "view_game";
        var gameid = get_url_variable("gameid");
        var postdata = {"gameid":gameid};
        String encodedData = encodeMap(postdata);
        get_string("view_game.php", encodedData, (resp) {
            var parsed_resp = parse(resp);
            this.display_div("Name : ${parsed_resp["game_name"]}");
            this.display_div("Description : ${parsed_resp["short_description"]}");
            this.display_div("Description : ${parsed_resp["long_description"]}");
            this.display_div(resp);
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

