//
//  AddTorrentTask.swift
//  Deluge Remote
//
//  Created by Yannis on 07/06/2017.
//  Copyright © 2017 isklikas. All rights reserved.
//

import UIKit

class AddTorrentTask: TaskWithOptions {
    var rTorrent: RemoteTorrent?
    
    override func writeToTaskScript() {
        super.writeToTaskScript()
    }
    
    override func execute() -> Any! {
        return super.execute()
    }
    
    override func cleanUp() {
        super.cleanUp()
    }
    
    func addTorrentTask() -> Bool {
        if (self.rTorrent != nil) {
            switch self.rTorrent!.type {
            case "Array":
                break;
            case "File":
                break;
            default:
                //Magnet Link
                let magnetURL : NSURL = self.rTorrent!.taskObject! as! NSURL
                let magnetString: String = magnetURL.absoluteString!
                self.cmdString = String(format:"magnetlink = \"%@\" \n    client.core.add_torrent_magnet(magnetlink,[ENTER_PYDICT_HERE]).addCallback(on_get_status)",magnetString)
                break;
            }
            self.writeToTaskScript()
            let status: String? = self.execute() as! String?
            self.cleanUp()
            var success: Bool = false
            if (status != nil) {
                success = true;
            }
            return success
        }
        return false
    }
}
