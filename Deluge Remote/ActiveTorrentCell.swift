//
//  ActiveTorrentCell.swift
//  Deluge Remote
//
//  Created by Yannis on 13/06/2017.
//  Copyright © 2017 isklikas. All rights reserved.
//

import UIKit

class ActiveTorrentCell: UITableViewCell {
    var torrentID: String?
    var cellProperties: NSDictionary? {
        didSet {
            self.setUpView()
        }
    }
    
    var remoteManager: RemoteManager?
    @IBOutlet weak var arrowView: ArrowView!
    @IBOutlet weak var progressView: LinearProgressView!
    @IBOutlet weak var torrentNameLabel: UILabel!
    @IBOutlet weak var uploadedBytesLabel: UILabel!
    @IBOutlet weak var downloadBytesLabel: UILabel!
    @IBOutlet weak var totalSizeLabel: UILabel!
    
    @objc func setUpView() {
        let torrentProperties = self.cellProperties
        if (torrentProperties != nil) {
            let torrentName: String = torrentProperties!["name"] as! String
            let totalSize: Int = torrentProperties!["total_size"] as! Int
            let downloadedBytes: Int  = torrentProperties!["all_time_download"] as! Int
            let progress: Int  = torrentProperties!["progress"] as! Int
            let uploadedBytes: Int  = torrentProperties!["total_uploaded"] as! Int
            let state: String = torrentProperties!["state"] as! String
            self.torrentNameLabel.text = torrentName
            self.totalSizeLabel.text = self.getLargestByteMeasure(size: totalSize)
            self.uploadedBytesLabel.text = self.getLargestByteMeasure(size: uploadedBytes)
            self.downloadBytesLabel.text = self.getLargestByteMeasure(size: downloadedBytes)
            let isSeeding: Bool = (state == "Seeding")
            self.arrowView.isDownloading = !isSeeding
            self.arrowView.setNeedsDisplay()
            self.progressView.progressValue = CGFloat(progress)
            self.progressView.barColor = !isSeeding ? UIColor(red: 23/255, green: 231/255, blue: 84/255, alpha: 1) : UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
        }
    }
    
    func getLargestByteMeasure(size: Int) -> String {
        var result = Float()
        var i: Int = 0
        var k: Float = Float(size)
        while k >= 1 {
            k /= 1024
            if (k >= 1) {
                i += 1
                result = k
            }
        }
        var unitOfMeasure = String()
        switch i {
        case 1:
            unitOfMeasure = "KB"
            break;
        case 2:
            unitOfMeasure = "MB"
            break;
        case 3:
            unitOfMeasure = "GB"
            break;
        case 4:
            unitOfMeasure = "TB"
            break
        default:
            break;
        }
        let description = String(format: "%0.2f %@", result, unitOfMeasure)
        return description
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
