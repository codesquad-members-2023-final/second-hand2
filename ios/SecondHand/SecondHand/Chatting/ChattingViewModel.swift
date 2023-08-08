//
//  ChattingViewModel.swift
//  SecondHand
//
//  Created by 에디 on 2023/08/08.
//

import Foundation

struct ChattingViewModel {
    let sentMessages: [Message]
    let receivedMessages: [Message]
}

struct Message {
    let text: String
}
