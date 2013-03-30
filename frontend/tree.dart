import 'dart:html';
import 'dart:json';

class tree
{
    DivElement content;
    String name;
    List<tree_element> elements;

    /** 
     * Construct a tree
     *
     * @param _name The name of the return value in the form
     * @param data A list of lists. Each sub-element contains the fields (id, parentid, text)
     */
    tree(String _name, List data) {
        elements = new List<tree_element>();
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
            tree_element new_element = new tree_element(data[i][0], parent, data[i][2], hidden_element, elements);
            hierarchy[data[i][0]] = new_element;
            elements.add(new_element);
            
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
    DivElement clickable;
    ButtonElement button;
    int id;
    tree_element parent;
    String text;
    InputElement target;
    List<tree_element> elements;
    tree_element(int _id, tree_element _parent, String _text, InputElement _target, List<tree_element> _elements) {
        text = _text;
        id = _id;
        parent = _parent;
        target = _target;
        elements = _elements;
        content = new Element.html("<div></div>");
        button = new ButtonElement();
        button..id = 'expand${id}'
            ..text = '+'
            ..onClick.listen((e) => toggle_children());
        content.nodes.add(button);
        clickable = new Element.html("<div class=\"tree_element\">${text}</div>");
        content.nodes.add(clickable);
        children = new Element.html("<div class=\"tree_children\"></div>");
        clickable.onClick.listen((e) {target.value = "${id}";
                for (tree_element elem in elements) {
                    elem.clickable.classes.remove("tree_element_selected");
                }
                clickable.classes.add("tree_element_selected");
            });
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
