import Quickshell
import Quickshell.Io
import Quickshell.Services.Pam
import QtQuick

ShellRoot {
  PamContext {
    id: pam
    config: "lock"
    user: "clecompt"
    onPamMessage: this.responseRequired && this.respond(password.text)
    onCompleted: result =>
      (desktop.running = result == PamResult.Success) || password.clear()
  }

  Process {
    id: desktop
    command: ["sudo", "chvt", "3"]
    onExited: Qt.quit()
  }

  Process {
    id: steamos
    command: ["sudo", "chvt", "4"]
    onExited: Qt.quit()
  }

  FloatingWindow {
    Rectangle {
      color: "#000000"
      anchors.fill: parent

      TextInput {
        id: password
        focus: true
        color: "#cccccc"

        anchors {
          verticalCenter: parent.verticalCenter
          horizontalCenter: parent.horizontalCenter
        }
        
        font {
          pointSize: 96
          letterSpacing: -24
        }
        echoMode: TextInput.Password
        passwordCharacter: "\u2022"
        leftPadding: font.letterSpacing/2
        rightPadding: -font.letterSpacing/2

        cursorDelegate: Item{}
        enabled: !pam.active
        onAccepted: this.text ? pam.start() : steamos.running = true
      }
    }

    HoverHandler {
      cursorShape: Qt.BlankCursor
    }
  }
}
