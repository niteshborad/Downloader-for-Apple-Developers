//
//  DownloadProgressTableViewHandler.swift
//  Downloader
//
//  Created by Vineet Choudhary on 17/05/20.
//  Copyright © 2020 Developer Insider. All rights reserved.
//

import Foundation
import Cocoa

class DownloadProgressTableViewHandler: NSObject {
    init(tableView: NSTableView) {
        super.init()
        tableView.delegate = self;
        tableView.dataSource = self;
    }
}

extension DownloadProgressTableViewHandler: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return DownloadProcessManager.shared.downloadProcesses.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let downloadProgress = DownloadProcessManager.shared.downloadProcesses[row].progress else {
            return nil
        }
        if downloadProgress.isFinish {
            let identifierString = String(describing: DownloadProcessCompleteTableCellView.self)
            let identifier = NSUserInterfaceItemIdentifier(rawValue: identifierString)
            if let cell = tableView.makeView(withIdentifier: identifier, owner: nil) as? DownloadProcessCompleteTableCellView {
                cell.config(downloadProgress: downloadProgress)
                return cell
            }
        } else {
            let identifierString = String(describing: DownloadProcessTableCellView.self)
            let identifier = NSUserInterfaceItemIdentifier(rawValue: identifierString)
            if let cell = tableView.makeView(withIdentifier: identifier, owner: nil) as? DownloadProcessTableCellView {
                cell.config(downloadProgress: downloadProgress)
                return cell
            }
        }
        return nil
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        guard let downloadProgress = DownloadProcessManager.shared.downloadProcesses[row].progress else {
            return 88
        }
        return downloadProgress.isFinish ? 62 : 88
    }
}

extension DownloadProgressTableViewHandler: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        if let downloadProgress = DownloadProcessManager.shared.downloadProcesses[row].progress,
            let fileName = downloadProgress.fileName, downloadProgress.isFinish,
            let fileURL = URL(string: "file://\(NSHomeDirectory())/Downloads/\(fileName)") {
            NSWorkspace.shared.activateFileViewerSelecting([fileURL])
        }
        return false
    }
}
