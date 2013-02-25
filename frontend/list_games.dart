import 'dart:html';
import 'dart:json';
import 'nav_bar.dart';
import 'util.dart';

class show_game_form {
    DivElement content;

    show_game_form() {
        content = new Element.html("<div></div>");
        content.id = "view_game";
        get_string("list_games.php", "", (resp) {
            List games = parse(resp);
            games.forEach( (Map game) {
                DivElement InfoDiv = new DivElement();
                InfoDiv.text = game["game_name"];
                InfoDiv.classes.add('game_name');
                content.children.add(InfoDiv);
            });
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

