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
                let fileArray: NSArray = self.rTorrent!.taskObject as! NSArray
                let mutableArray = NSMutableArray(array: fileArray) as Array
                var output = "["
                for i in 0 ..< mutableArray.count {
                    let fileURL = mutableArray[i] as! NSURL
                    let filename : String = fileURL.path!.components(separatedBy: "/").last!
                    var filedump: Data = Data()
                    do {
                        filedump = try Data(contentsOf: fileURL as URL)
                    }
                    catch {
                    }
                    let b64encoded: String = filedump.base64EncodedString()
                    let currentTuple = String(format:"(\"%@\",\"%@\",[ENTER_PYDICT_HERE])", filename, b64encoded)
                    output += currentTuple
                    
                    if i < (mutableArray.count-1) {
                        output += ","
                    }
                }
                output += "]"
                self.cmdString = String(format:"tup = \"%@\" \n    client.core.add_torrent_files(tup).addCallback(on_get_status)",output)
                break;
            case "File":
                let fileURL : NSURL = self.rTorrent!.taskObject as! NSURL
                let filename : String = fileURL.path!.components(separatedBy: "/").last!
                var filedump: Data = Data()
                do {
                    filedump = try Data(contentsOf: fileURL as URL)
                }
                catch {
                }
                let b64encoded: String = filedump.base64EncodedString()
                self.cmdString = String(format:"filename = \"%@\" \n    filedump = \"%@\" \n    client.core.add_torrent_file(filename, filedump, [ENTER_PYDICT_HERE]).addCallback(on_get_status)",filename,b64encoded)
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
