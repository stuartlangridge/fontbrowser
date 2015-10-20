import QtQuick 2.0

Item {
    id: tracker

    property int siteId
    property string siteUrl
    property string piwikServerUrl
    property string userId: ""


    property bool busy: false
    property var outstanding: []

    function _toQueryString(eventname) {
        var data = {
            idsite: tracker.siteId,
            rec: 1,
            url: siteUrl,
            action_name: eventname,
            apiv: 1
        }
        if (tracker.userId && tracker.userId.length > 0) { data._id = tracker.userId; }
        var qs = [];
        for (var k in data) {
            qs.push(k + "=" + encodeURIComponent(data[k]));
        }
        return "?" + qs.join("&");
    }

    function _doRequest() {
        if (tracker.busy) { return; }
        if (tracker.outstanding.length == 0) { return; }
        tracker.busy = true;
        var tosend = tracker.outstanding.concat([]);
        tracker.outstanding = [];
        var body = JSON.stringify({requests: tosend.map(tracker._toQueryString)});
        var xhr = new XMLHttpRequest();
        xhr.open("POST", tracker.piwikServerUrl + "/piwik.php", true);
        xhr.onreadystatechange = function() {
            if (xhr.readyState == 4) {
                tracker.busy = false;
                console.log("request completed", xhr.responseText, xhr.status);
            }
        }
        xhr.send(body);
        console.log("Sent events", body);
    }

    function trackEvent(ev) {
        outstanding.push(ev);
        if (!busy) {
            _doRequest();
        }
    }
}
