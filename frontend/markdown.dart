library view_game;

import 'dart:html';
import 'dart:json';
import 'dart:uri';
import 'util.dart';
import 'dart:core';

class markdown_field {
    DivElement content;

    markdown_field(String inp) {
        this.content = new Element.html("<div></div>");
    }
}

main() {

    try {
        main_wrapped();
    } catch (ex) {
        document.window.alert(ex.toString());
    }
}

main_wrapped() {
    String inp = "A First Level Header\n====================\n\nA Second Level Header\n---------------------\n\nNow is the time for all good men to come to\nthe aid of their country. This is just a\nregular paragraph.\n\nThe quick brown fox jumped over the lazy\ndog's back.\n\n### Header 3\n\n> This is a blockquote.\n> \n> This is the second paragraph in the blockquote.\n>\n> ## This is an H2 in a blockquote";
    query('#main').children.add(new markdown_field(inp).content);
}
