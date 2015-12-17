window.addEventListener("load", function () {
    var status = document.getElementById("status");
    console.log("opened");
    status.textContent = "Opened";
    var applicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr";
    var APIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY";
    var request = new XMLHttpRequest();
    request.open("GET", "https://api.parse.com/1/classes/StudentLocation?limit=100&order=-updatedAt", false);
    request.setRequestHeader("X-Parse-Application-Id", applicationID);
    request.setRequestHeader("X-Parse-REST-API-Key", APIKey);
    status.textContent = "Request sent";
    request.send();
    status.textContent = "Request received, parsing";
    status.textContent = request.responseText;
    var o = JSON.parse(request.responseText);
    o = o["results"];
    var s = "<table>";
    
    for (var i = 0; i < o.length; i++) {
        s += "<tr>"
        s += "<td>" + o[i].firstName + " " + o[i].lastName + "</td>";
        s += "<td>" + o[i].latitude + "</td>";
        s += "<td>" + o[i].longitude + "</td>";
        s += "</tr>"
    }
    s += "</table>";
    status.innerHTML = s;
});