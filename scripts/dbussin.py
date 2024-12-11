import dbus
import dbus.mainloop.glib
from gi.repository import GLib
import os

PLAYER_NAME = 'rhythmbox'
PLAYER_PATH = f'org.mpris.MediaPlayer2.{PLAYER_NAME}'
# add skipped songs to properly tag them later
FILE_OF_SHAME = os.path.expanduser("~/.local/state/music-cringelist")

def add_title(title, metadata):
    album = metadata.get('xesam:album')
    location = metadata.get('xesam:url')
    loc = location.replace("%20", " ")
    info = f"{title} - {album} @ {loc[7:]}"
    print(info)
    with open(FILE_OF_SHAME, "a") as list:
        list.write(info + "\n")

def skip_track():
    session_bus = dbus.SessionBus()
    player_object = session_bus.get_object(PLAYER_PATH, '/org/mpris/MediaPlayer2')
    player_interface = dbus.Interface(player_object, dbus_interface='org.mpris.MediaPlayer2.Player')
    try:
        player_interface.Next()
        print("Skipped track")
    except dbus.DBusException as e:
        print(f"Failed to skip track: {e}")

def on_properties_changed(interface, changed, invalidated):
    if 'Metadata' in changed:
        metadata = changed['Metadata']
        artist = ', '.join(metadata.get('xesam:artist', []))
        title = metadata.get('xesam:title', 'Unknown')
        if artist == "Unknown":
            print("yikes, tag your music properly")
            add_title(title, metadata)
            skip_track()
        else:
            print(f"Now Playing: {title} by {artist}")


def main():
    # Init the D-Bus main loop
    dbus.mainloop.glib.DBusGMainLoop(set_as_default=True)

    # Connect to the session bus
    session_bus = dbus.SessionBus()
    player_object = session_bus.get_object(PLAYER_PATH, '/org/mpris/MediaPlayer2')

    # Add a signal receiver for PropertiesChanged
    session_bus.add_signal_receiver(
        on_properties_changed,
        signal_name="PropertiesChanged",
        dbus_interface="org.freedesktop.DBus.Properties",
        bus_name=PLAYER_PATH,
        path='/org/mpris/MediaPlayer2'
    )

    # Run the main loop
    print(f"Listening for track changes on {PLAYER_PATH}...")
    GLib.MainLoop().run()

if __name__ == "__main__":
    main()
