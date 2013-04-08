library sidebar;
import 'dart:html';
import 'dart:json';
import 'login.dart';
import 'util.dart';

class sidebar {
  DivElement content;

  sidebar() {
    content = new DivElement();
    content.classes.add('sidebar');
    get_string("sidebar_games.php", "", (resp) {
        List games = parse(resp);
        games.forEach( (Map game) {
            DivElement InfoDiv = new DivElement();
            InfoDiv.classes.add('game_name');
            var gamename = game["game_name"];
            var gameid = game["game_id"];
            var link = new Element.html("<a href=/#page=view_ga    me;gameid=${gameid}>${gamename}</a>");
            InfoDiv.children.add(link);
            content.children.add(InfoDiv);
        });
    });
  }
}



