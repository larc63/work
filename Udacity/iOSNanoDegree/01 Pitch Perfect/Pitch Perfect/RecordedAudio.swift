//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Luis Antonio Rodriguez on 7/22/15.
//  Copyright (c) 2015 Luis Antonio Rodriguez. All rights reserved.
//

import Foundation
final class RecordedAudio: NSObject{
    internal var filePathUrl: NSURL!
    private var title: String!
    init(filePathUrl: NSURL, title: String){
        self.filePathUrl = filePathUrl
        self.title = title
    }
}