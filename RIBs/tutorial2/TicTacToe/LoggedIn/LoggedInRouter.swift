//
//  LoggedInRouter.swift
//  TicTacToe
//
//  Created by Shin Jae Ung on 2022/10/06.
//  Copyright © 2022 Uber. All rights reserved.
//

import RIBs

protocol LoggedInInteractable: Interactable, OffGameListener, TicTacToeListener {
    var router: LoggedInRouting? { get set }
    var listener: LoggedInListener? { get set }
}

protocol LoggedInViewControllable: ViewControllable {
    func present(viewController: ViewControllable)
    func dismiss(viewController: ViewControllable)
}

final class LoggedInRouter: Router<LoggedInInteractable>, LoggedInRouting {
    // TODO: Constructor inject child builder protocols to allow building children.
    init(interactor: LoggedInInteractable,
         viewController: LoggedInViewControllable,
         offGameBuilder: OffGameBuildable,
         tictactoeBuilder: TicTacToeBuilder) {
        self.viewController = viewController
        self.offGameBuilder = offGameBuilder
        self.tictactoeBuilder = tictactoeBuilder
        super.init(interactor: interactor)
        interactor.router = self
    }

    func cleanupViews() {
        if let currentChild = currentChild {
            viewController.dismiss(viewController: currentChild.viewControllable)
        }
    }
    
    func routeToTicTacToe() {
        if let offGame = self.currentChild {
            detachChild(offGame)
            viewController.dismiss(viewController: offGame.viewControllable)
            self.currentChild = nil
        }
        
        let tictactoe = tictactoeBuilder.build(withListener: interactor)
        currentChild = tictactoe
        attachChild(tictactoe)
        viewController.present(viewController: tictactoe.viewControllable)
    }
    
    func routeToOffGame() {
        detachCurrentChild()
        attachOffGame()
    }
    
    override func didLoad() {
        super.didLoad()
        attachOffGame()
    }

    // MARK: - Private

    private let viewController: LoggedInViewControllable
    private let offGameBuilder: OffGameBuildable
    private let tictactoeBuilder: TicTacToeBuilder
    
    private var currentChild: ViewableRouting?
    
    private func attachOffGame() {
        let offGame = offGameBuilder.build(withListener: interactor)
        self.currentChild = offGame
        attachChild(offGame)
        viewController.present(viewController: offGame.viewControllable)
    }
    
    private func detachCurrentChild() {
        if let currentChild = currentChild {
            detachChild(currentChild)
            viewController.dismiss(viewController: currentChild.viewControllable)
        }
    }
}
