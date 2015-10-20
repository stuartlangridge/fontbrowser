import QtQuick 2.2
import Ubuntu.Components 1.1
import Ubuntu.Components.ListItems 1.0 as ListItem

/*!
    \brief MainView with a Label and Button elements.
*/

MainView {
    id: mv
    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "mainView"

    // Note! applicationName needs to match the "name" field of the click manifest
    applicationName: "org.kryogenix.fontbrowser"

    /*
     This property enables the application to change orientation
     when the device is rotated. The default is false.
    */
    //automaticOrientation: true

    // Removes the old toolbar and enables new features of the new header.
    useDeprecatedToolbar: false

    width: units.gu(40)
    height: units.gu(71)

    ListModel {
        id: lm
    }

    PiwikEventTracker {
        id: analytics
        siteId: 2
        siteUrl: "http://fontbrowser.apps.kryogenix.org"
        piwikServerUrl: "http://www.kryogenix.org/analytics/"
    }

    Page {
        id: pg
        title: i18n.tr("Font Browser")


        state: "default"
        property string substate: "text"
        states: [
            PageHeadState {
                id: defaultState
                name: "default"
                head: pg.head
                actions: [Action {
                    iconName: "compose"
                    onTriggered: {
                        pg.substate = "text";
                        pg.state = "alter";
                        analytics.trackEvent("switchto/text");
                    }
                }, Action {
                    iconSource: "resize.svg"
                    onTriggered: {
                        pg.substate = "size";
                        pg.state = "alter";
                        analytics.trackEvent("switchto/size");
                    }
                }]
            },
            PageHeadState {
                id: alterState
                name: "alter"
                head: pg.head
                actions: [Action {
                    iconName: "compose"
                    onTriggered: {
                        pg.substate = "text";
                        pg.state = "alter";
                        analytics.trackEvent("switchto/text");
                    }
                }, Action {
                    iconSource: "resize.svg"
                    onTriggered: {
                        pg.substate = "size";
                        pg.state = "alter";
                        analytics.trackEvent("switchto/size");
                    }
                }]
                backAction: Action {
                    text: "back"
                    iconName: "back"
                    onTriggered: {
                        pg.state = "default";
                        analytics.trackEvent("switchto/view");
                    }
                }
                contents: Column {
                    id: alterHeadContents
                    TextField {
                        id: t
                        text: "Sphinx of black quartz, judge my vow"
                        visible: pg.substate == "text"
                        StateSaver.properties: "text"
                    }
                    Slider {
                        id: slidesize
                        minimumValue: 2
                        maximumValue: 8
                        value: 3
                        live: true
                        width: parent.width
                        visible: pg.substate == "size"
                        StateSaver.properties: "value"
                    }
                }
            }
        ]

        Flickable {
            id: flick
            anchors.fill: parent
            contentHeight: col.height
            width: parent.width

            Column {
                id: col
                spacing: units.gu(1)
                anchors {
                    left: parent.left
                    right: parent.right
                    margins: units.gu(2)
                }
                width: parent.width

                Repeater {
                    model: lm
                    width: parent.width
                    Column {
                        width: parent.width
                        Label {
                            text: t.text
                            font.family: model.name
                            width: parent.width
                            height: units.gu(7)
                            font.pixelSize: units.gu(slidesize.value)
                            wrapMode: Text.Wrap
                            clip: true
                        }
                        Label {
                            text: model.name
                            width: parent.width
                            font.pixelSize: units.gu(1)
                            wrapMode: Text.Wrap
                            horizontalAlignment: Text.AlignRight
                        }
                    }
                }
            }
        }
        Scrollbar {
            flickableItem: flick
            align: Qt.AlignTrailing
        }
    }
    Component.onCompleted: {
        var fm = Qt.fontFamilies();
        fm.sort();
        fm.forEach(function(f) {
           lm.append({name: f});
        });
        analytics.trackEvent("startup");
    }
}

