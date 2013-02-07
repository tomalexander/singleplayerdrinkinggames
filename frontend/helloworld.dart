import 'dart:html';

main() {

    try {
        main_wrapped();
    } on Exception
    catch (ex) {
        document.window.alert(ex.toString());
    }
}

main_wrapped() {
  var button = new ButtonElement();
  button..id = 'confirm'
        ..text = 'Click to Confirm'
        ..classes.add('important')
        ..on.click.add((e) => window.alert('Confirmed!'));
  query('#registration').children.add(button);
}
