//
//  LoggedInActionableItem.swift
//  TicTacToe
//
//  Created by Shin Jae Ung on 2022/11/08.
//  Copyright © 2022 Uber. All rights reserved.
//

import RxSwift

public protocol LoggedInActionableItem: AnyObject {
    func launchGame(with id: String?) -> Observable<(LoggedInActionableItem, ())>
}
