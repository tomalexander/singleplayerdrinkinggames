library markdown_help;
import 'dart:html';
import 'markdown.dart';

class markdown_help {
    DivElement content;
    Element show;
    Element hide;
    FieldSetElement input_side;
    FieldSetElement output_side;

    markdown_help() {
        content = new Element.html("<div id=\"markdown-help\"></div>");
        show = new Element.html("<a href=\"javascript:void(0)\">Show Markdown Help</a>");
        hide = new Element.html("<a href=\"javascript:void(0)\">Hide Markdown Help</a>");
        input_side = new Element.html("<fieldset style=\"width:45%; margin:0% 1%; float: left;\"></fieldset>");
        output_side = new Element.html("<fieldset style=\"width:45%; margin:0% 1%; float: right;\"></fieldset>");
        input_side.nodes.add(new Element.html("<legend style=\"color:black;font-weight:bold;\">Markdown Input</legend>"));
        output_side.nodes.add(new Element.html("<legend style=\"color:black;font-weight:bold;\">Markdown Output</legend>"));
        TextAreaElement help_markdown = new Element.html("<textarea style=\"width: 99%;\" rows=\"40\">");
        help_markdown.value = "Headlines can be written like this\n==================================\n\nOr they can be written like this\n--------------------------------\n\n# You can also put hashtags at the start of the line for headline levels\n###### All the way down to 6 levels\n## Links\nLinks are in the following format: [Go search on google](http://google.com/)\n## Images\nImages are similar to links but require the exclamation mark in the front and can have a title next to the URL\n\n![Cat being dragged](http://static.paphus.com/gifs/6KAiUQl.gif Cat being dragged title)\n## Block Quotes\nIf you are quoting someone, prepend the lines with \"> \"\n> This is an example of a block quote\n> ## This is a headline in a block quote\n> Still in the block quote\n## Code Blocks\nCode blocks start lines with 4 spaces. This creates monospaced font\n    this is in a code block\n    notice how the i character is equal in width to the c character\n    here is the    c character below the i\n## Lists\nLists can be either numbered or bulleted. The number you put in the input does not correspond to the number on the output\n1. First item\n8. Second item\n3. Third item\n- First item\n- Second item\n- Third item\n## Emphasis\nYou can make p*ortion*s of words or *multiple words* emphasized _using_ one or __two__ of the **asterisk** and underscore characters";
        input_side.nodes.add(help_markdown);
        DivElement help_output = new Element.html("<div></div>");
        help_markdown.onInput.listen((e) {
                help_output.innerHtml = markdown_to_html(help_markdown.value);
            });
        help_output.innerHtml = markdown_to_html(help_markdown.value);
        output_side.nodes.add(help_output);
        show.onClick.listen((e) => show_help());
        hide.onClick.listen((e) => hide_help());
        hide_help();
    }
    
    void show_help() {
        content.nodes.clear();
        DivElement row = new Element.html("<div class=\"row\"></div>");
        row.nodes.add(hide);
        content.nodes.add(row);
        content.nodes.add(input_side);
        content.nodes.add(output_side);
    }

    void hide_help() {
        content.nodes.clear();
        DivElement row = new Element.html("<div class=\"row\"></div>");
        row.nodes.add(show);
        content.nodes.add(row);
    }
}