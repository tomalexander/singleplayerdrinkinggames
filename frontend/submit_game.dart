import 'dart:html';
import 'nav_bar.dart';

class submit_game_form {
  DivElement content;
  
  OListElement supplyList;
  OListElement instructionList;
  
  submit_game_form() {
    content = new Element.html("<div></div>");
    FormElement form = new FormElement();
    form.action = "submit_game.php";
    form.method = "POST";
    content.nodes.add(form);
    
    form.nodes.add(new Text("Game Name:"));
    form.nodes.add(new Element.html("<input type=\"text\" name=\"game_name\" required>"));
    form.nodes.add(new Element.html("<br>"));
    
    form.nodes.add(new Text("Short Description:"));
    form.nodes.add(new Element.html("<input type=\"text\" name=\"short_description\" required>"));
    form.nodes.add(new Element.html("<br>"));
    
    form.nodes.add(new Text("Long Description:"));
    form.nodes.add(new Element.html("<input type=\"text\" name=\"long_description\" required>"));
    form.nodes.add(new Element.html("<br>"));
    
    form.nodes.add(new Text("Supplies"));
    
    ButtonElement addButton = new ButtonElement();
    addButton.type = "button";
    addButton.on.click.add(addSupplyItem);
    addButton.text = "+";
    supplyList = new OListElement();
    form.nodes.add(supplyList);
    DivElement de = new Element.html("<div></div>");
    de.nodes.add(new Element.html("<input type=\"text\" name=\"supplies[]\">"));
    de.nodes.add(addButton);
    supplyList.append(de);
    form.nodes.add(new Element.html("<br>"));
    
    form.nodes.add(new Text("Instructions"));
    addButton = new ButtonElement();
    addButton.type = "button";
    addButton.on.click.add(addInstructionItem);
    addButton.text = "+";
    instructionList = new OListElement();
    form.nodes.add(instructionList);
    de = new Element.html("<div></div>");
    de.nodes.add(new Element.html("<input type=\"text\" name=\"instructions[]\">"));
    de.nodes.add(addButton);
    instructionList.append(de);
    
    SubmitButtonInputElement submit = new Element.html("<input type=\"submit\" value=\"Create Game\">");
    form.nodes.add(submit);
    form.on.submit.add((e) {submit.disabled = true;});
  }
  
  void addSupplyItem(Event e) {
    DivElement de = new Element.html("<div></div>");
    Element newBox = new Element.html("<input type=\"text\" name=\"supplies[]\">");
    ButtonElement removeButton = new ButtonElement();
    removeButton.type = "button";
    removeButton.on.click.add((e) => removeButton.parentNode.remove());
    removeButton.text = "-";
    ButtonElement addButton = new ButtonElement();
    addButton.on.click.add(addSupplyItem);
    addButton.type = "button";
    addButton.text = "+";
    
    de.nodes.add(newBox);
    de.nodes.add(addButton);
    de.nodes.add(removeButton);
    supplyList.append(de);
  }
  
  void addInstructionItem(Event e) {
    DivElement de = new Element.html("<div></div>");
    Element newBox = new Element.html("<input type=\"text\" name=\"instructions[]\">");
    ButtonElement removeButton = new ButtonElement();
    removeButton.type = "button";
    removeButton.on.click.add((e) => removeButton.parentNode.remove());
    removeButton.text = "-";
    ButtonElement addButton = new ButtonElement();
    addButton.type = "button";
    addButton.on.click.add(addInstructionItem);
    addButton.text = "+";
    
    de.nodes.add(newBox);
    de.nodes.add(addButton);
    de.nodes.add(removeButton);
    instructionList.append(de);
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
    game_div.id = "game-submission";
    query('#main').children.add(game_div);
    query('#game-submission').children.add(new submit_game_form().content);
}

