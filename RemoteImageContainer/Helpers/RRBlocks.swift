//
//  RRBlocks.swift
//  RemoteImageContainer
//
//  Created by Rameez Raja on 28/07/2021.
//

import Foundation

public typealias FileExistsCompletion = (_ fileURL: URL?) -> ()
public typealias DownloadStartCompletion = (_ error: RRError?) -> ()
public typealias DownloadsCancelledCompletion = (() -> ())?
