import 'dart:html';
import 'dart:json';

class tree
{
    DivElement content;
    String name;

    /** 
     * Construct a tree
     *
     * @param _name The name of the return value in the form
     * @param data A list of lists. Each sub-element contains the fields (id, parentid, text)
     */
    tree(String _name, List data) {
        content = new Element.tag("div");
        name = _name;
        InputElement hidden_element = new Element.html("<input type=\"hidden\" name=\"${name}\">");
        content.nodes.add(hidden_element);
        Map<int, tree_element> hierarchy = new Map<int, tree_element>();
        for (int i = 0; i < data.length; ++i)
        {
            tree_element parent = null;
            if (data[i][0] != data[i][1]) {
                parent = hierarchy[data[i][1]];
            }
            tree_element new_element = new tree_element(data[i][0], parent, data[i][2], hidden_element);
            hierarchy[data[i][0]] = new_element;
            
            if (parent == null) {
                content.nodes.add(new_element.content);
            } else {
                parent.children.nodes.add(new_element.content);
            }
        }
    }
}

class tree_element
{
    DivElement content;
    DivElement children;
    ButtonElement button;
    int id;
    tree_element parent;
    String text;
    InputElement target;
    tree_element(int _id, tree_element _parent, String _text, InputElement _target) {
        text = _text;
        id = _id;
        parent = _parent;
        target = _target;
        content = new Element.html("<div></div>");
        button = new ButtonElement();
        button..id = 'expand${id}'
            ..text = '+'
            ..onClick.listen((e) => toggle_children());
        content.nodes.add(button);
        DivElement clickable = new Element.html("<div style=\"display: inline-block;\">${text}</div>");
        content.nodes.add(clickable);
        clickable.onClick.listen((e) {target.value = "${id}";
                document.window.alert("Clicked ${id}");});
        children = new Element.html("<div>children</div>");
        content.nodes.add(children);
        hide_children();
    }

    void toggle_children() {
        if (children.hidden) {
            show_children();
        } else {
            hide_children();
        }
    }
    
    void show_children() {
        children.hidden = false;
        button.text = '-';
    }

    void hide_children() {
        children.hidden = true;
        button.text = '+';
    }
}

main() {
    try {
        main_wrapped();
    } on Exception catch (ex) {
        document.window.alert(ex.toString());
    }
}

main_wrapped() {
    String json_data = "[[1,1,\"Candy\"],[2,1,\"igloo\"],[3,2,\"sloth\"],[4,2,\"tree\"]]";
    query('#tree').children.add(new tree("submit_name", parse(json_data)).content);
}
