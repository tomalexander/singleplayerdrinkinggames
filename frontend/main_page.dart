library main_page;
import 'dart:html';
import 'sidebar.dart';

class main_page {
    DivElement content;

    main_page() {
        content = new DivElement();
        content.text = "Main page";
        content.classes.add('main_page');
        content.children.add(new sidebar().content);
    }
}



