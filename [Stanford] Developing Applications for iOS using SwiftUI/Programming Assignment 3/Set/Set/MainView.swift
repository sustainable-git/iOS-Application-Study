//
//  MainView.swift
//  Set
//
//  Created by Shin Jae Ung on 2022/04/20.
//

import SwiftUI

class MainViewModel: ObservableObject {
    typealias Card = SetGame.Card

    @Published var set = SetGame(numberOfInitialCards: 12)
    @Published var showHint = false
    var showingCards: [Card] { self.set.showingCards }
    var selectedCards: [Card] { self.set.selectedCards }
    var hintCards: [Card] { self.set.hint }
    var score: Int {
        return self.set.score
    }
    var isGameOver: Bool {
        return self.set.isGameOver
    }
    
    var result: String {
        if self.set.isMatched {
            return "Matched"
        } else if self.selectedCards.count == 3 && !self.set.isMatched {
            return "Mismatched"
        } else {
            return ""
        }
    }
    
    func select(card: Card) {
        guard isGameOver == false else { return }
        self.set.select(card: card)
        self.showHint = false
    }
    
    func dealThreeMoreButtonTouched() {
        self.showHint = false
        
        if self.set.isMatched {
            self.set.clearIfMatched()
        } else {
            for _ in 0..<3 {
                self.set.drawCard()
            }
        }
    }
    
    func newGameButtonTouched() {
        self.set.reset()
    }
}

struct MainView: View {
    @StateObject private var viewModel = MainViewModel()
    
    var body: some View {
        VStack {
            ZStack {
                VStack {
                    ZStack {
                        HStack {
                            Text("Score: \(self.viewModel.score)")
                            Spacer()
                            Button {
                                self.viewModel.showHint = true
                            } label: {
                                Text("💡")
                                    .padding(.all, 5)
                                    .background { RoundedRectangle(cornerRadius: 5).stroke() }
                                    .foregroundColor(.red)
                            }
                        }
                        Text(viewModel.result)
                    }
                    
                    AspectVGrid(items: viewModel.showingCards, aspectRatio: 44/31) { card in
                        let isSelected = self.viewModel.selectedCards.contains(card)
                        let hint: Bool = self.viewModel.showHint && self.viewModel.hintCards.contains(card)
                        CardView(card, isSelected: isSelected, hint: hint)
                            .padding(4)
                            .onTapGesture {
                                self.viewModel.select(card: card)
                            }
                    }
                }
                if self.viewModel.isGameOver {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(.green)
                            .opacity(0.9)
                        VStack {
                            Text("Congratulations")
                            Text("Score: \(self.viewModel.score)")
                        }
                        .font(.title)
                        .foregroundColor(Color(uiColor: .systemBackground))
                    }
                }
            }
            
            HStack {
                Spacer()
                Button("New Game") {
                    self.viewModel.newGameButtonTouched()
                }
                .buttonStyle(.bordered)
                Spacer()
                Button("Deal 3 More") {
                    self.viewModel.dealThreeMoreButtonTouched()
                }
                .buttonStyle(.bordered)
                Spacer()
            }
        }
        .padding()
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
        MainView()
            .previewInterfaceOrientation(.landscapeLeft)
            .preferredColorScheme(.dark)
    }
}
