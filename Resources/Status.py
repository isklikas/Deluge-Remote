# A really hacked down version of http://dev.deluge-torrent.org/wiki/Development/1.3/UIClient
# Writen to hook in to a different, syncro, script
from deluge.ui.client import client
import json
import PasswordManager
 
# Import reactor for our mainloop
from twisted.internet import reactor
from deluge.log import setupLogger
setupLogger()
password = PasswordManager.password()
 
d = client.connect(host='127.0.0.1',port=58846,username='localclient',password=password)
 
def on_connect_success(result):
    def on_get_status(value):
        print json.dumps(value)
 
        # Disconnect from the daemon once we've got what we needed
        client.disconnect()
        # Stop the twisted main loop and exit
        reactor.stop()
    # uses some python magic
    # list of commands available at https://deluge.readthedocs.org/en/develop/core/rpc.html#remote-api
    # list of statuses available at http://www.rasterbar.com/products/libtorrent/manual.html#status
    client.core.get_session_status(["payload_upload_rate", "payload_download_rate"]).addCallback(on_get_status)
 
d.addCallback(on_connect_success)
 
reactor.run()
