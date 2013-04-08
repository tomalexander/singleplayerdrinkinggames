library view_game;

import 'dart:html';
import 'dart:json';
import 'dart:uri';
import 'util.dart';
import 'dart:core';

class markdown_node {
    List<markdown_node> children;
    markdown_node() {
        children = new List<markdown_node>();
    }

    String generate_html() {
        return "ERROR: SHOULD BE OVERRIDDEN";
    }
}

class markdown_headline extends markdown_node {
    int level;
    String content;
    markdown_headline(int _level, String _content) : super() {
        level = _level;
        content = _content;
    }

    String generate_html() {
        return "<h${level}>${content}</h${level}>";
    }
}

class markdown_paragraph extends markdown_node {
    String content;
    markdown_paragraph(String _content) : super() {
        content = _content;
    }

    String generate_html() {
        return "<p>${content}</p>";
    }
}

class markdown_field {
    DivElement content;

    markdown_field(String inp) {
        content = new Element.html("<div></div>");
        content.nodes.add(new Text(new markdown_headline(2, "igloo").generate_html()));
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
