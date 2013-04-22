library util;

import 'dart:html';
import 'dart:uri';

/** 
 * Asynchronously call the server and pass the string of the output to the callback function
 *
 * @param address The address to call
 * @param url_data url encoded variables
 * @param callback The function to pass the string to when the data is returned
 */
void get_string(String address, String url_data, callback) {
    HttpRequest request = new HttpRequest();
  
    request.onLoad.listen((Event event) {
            callback(request.responseText);
        });
  
    // POST the data to the server
    request.open("POST", address, async: true);
    request.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    request.send(url_data); // perform the async POST
}

/** 
 * Synchronously call the server and return the string from the output
 *
 * @param address The address to call
 * @param url_data url encoded variables
 *
 * @return The output from the call to the server
 */
String get_string_synchronous(String address, String url_data) {
    HttpRequest request = new HttpRequest();
  
    // POST the data to the server
    request.open("POST", address, async: false);
    request.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    request.send(url_data); // perform the sync POST
    return request.responseText;
}

/** 
 * Retrieve the string value of a cookie with the corresponding name
 *
 * @param name The name of the cookie
 *
 * @return The string value of the cookie, or null if not found
 */
String get_cookie(String name) {
    List<String> cookies = document.cookie.split(";");
    for (int i = 0; i < cookies.length; ++i) {
        List<String> split = cookies[i].split("=");
        if (split[0].trim() == name.trim()) {
            return split[1].trim();
        }
    }
    return null;
}

/** 
 * Get a variable from the url after the hash. Format #var1=val1;var2=val2....
 *
 * @param name The name of the variable which is the left side of the equals sign
 *
 * @return The value of the variable or null if not found
 */
String get_url_variable(String name) {
    String hash_string = window.location.hash.replaceFirst('#', '');
    List<String> variables = hash_string.split(";");
    for (int i = 0; i < variables.length; ++i) {
        List<String> split = variables[i].split("=");
        if (split[0].trim() == name.trim()) {
            return split[1].trim();
        }
    }
    return null;
}

/** 
 * Generate the date time string for cookies
 *
 * @param local_time The DateTime in local time
 *
 * @return The formatted string in UTC
 */
String generate_expires_string(DateTime local_time) {
    DateTime time = local_time.toUtc();
    String ret = "";
    if (time.weekday == DateTime.MONDAY) {
        ret = "${ret}Mon, ";
    } else if (time.weekday == DateTime.TUESDAY) {
        ret = "${ret}Tue, ";
    } else if (time.weekday == DateTime.WEDNESDAY) {
        ret = "${ret}Wed, ";
    } else if (time.weekday == DateTime.THURSDAY) {
        ret = "${ret}Thu, ";
    } else if (time.weekday == DateTime.FRIDAY) {
        ret = "${ret}Fri, ";
    } else if (time.weekday == DateTime.SATURDAY) {
        ret = "${ret}Sat, ";
    } else if (time.weekday == DateTime.SUNDAY) {
        ret = "${ret}Sun, ";
    }
    ret = "${ret}${time.day} ";
    if (time.month == DateTime.JANUARY) {
        ret = "${ret}Jan ";
    } else if (time.month == DateTime.FEBRUARY) {
        ret = "${ret}Feb ";
    } else if (time.month == DateTime.MARCH) {
        ret = "${ret}Mar ";
    } else if (time.month == DateTime.APRIL) {
        ret = "${ret}Apr ";
    } else if (time.month == DateTime.MAY) {
        ret = "${ret}May ";
    } else if (time.month == DateTime.JUNE) {
        ret = "${ret}Jun ";
    } else if (time.month == DateTime.JULY) {
        ret = "${ret}Jul ";
    } else if (time.month == DateTime.AUGUST) {
        ret = "${ret}Aug ";
    } else if (time.month == DateTime.SEPTEMBER) {
        ret = "${ret}Sep ";
    } else if (time.month == DateTime.OCTOBER) {
        ret = "${ret}Oct ";
    } else if (time.month == DateTime.NOVEMBER) {
        ret = "${ret}Nov ";
    } else if (time.month == DateTime.DECEMBER) {
        ret = "${ret}Dec ";
    }
    ret = "${ret}${time.year} ${time.hour}:${time.minute}:${time.second} GMT";
    return ret;
}

/** 
 * Create a new cookie
 *
 * @param name The cookie's name
 * @param value The value to assign to the cookie
 * @param seconds The number of seconds the cookie should exist, pass null to never expire cookie
 */
void set_cookie(String name, String value, {int seconds: null}) {
    if (seconds != null) {
        DateTime now = new DateTime.now();
        DateTime expires = now.add(new Duration(seconds: seconds));
        document.cookie = "${name}=${value}; expires=${generate_expires_string(expires)}";
    } else {
        document.cookie = "${name}=${value};";
    }
}

/** 
 * Delete the named cookie
 *
 * @param name The name of the cookie
 */
void delete_cookie(String name) {
    document.cookie = "${name}=; expires=Thu, 01 Jan 1970 00:00:01 GMT";
}

/**
 * Takes a map, and encodes that into a URI format.
 * This is done to make varaibles easier to pass into the server.
 * 
 * @param data: Data to be encoded.
 * 
 * @return String: The data encoded into URI format.
 */
String encode_map(Map data) {
    return data.keys.map((k) {
            return '${encodeUriComponent(k)}=${encodeUriComponent(data[k])}';
        }).join('&');
}
