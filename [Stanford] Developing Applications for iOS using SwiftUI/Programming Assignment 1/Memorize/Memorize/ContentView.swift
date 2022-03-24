//
//  ContentView.swift
//  Memorize
//
//  Created by Shin Jae Ung on 2022/03/22.
//

import SwiftUI

struct ContentView: View {
    let minEmojiCount = 8
    @State var emojis = "🐶🐱🐭🐹🐰🦊🐻🐼🐻‍❄️🐨🐯🦁🐮🐷🐽🐸🐵🐔🐧🐦".map { String($0) }.shuffled()
    @State var emojiCount = 20
    @State var screenWidth: CGFloat = UIScreen.main.bounds.size.width
    @State var screenHeight: CGFloat = UIScreen.main.bounds.size.height/2
    
    var body: some View {
        VStack {
            Text("Memorize!")
                .font(.largeTitle)
            ScrollView {
                let cellSize: CGSize = largestCellSizeThatFitsAspectRatio(numberOfCells: emojiCount, CGFloat(31)/CGFloat(44))
                LazyVGrid(columns: [GridItem(.adaptive(minimum: cellSize.width))]) {
                    ForEach(emojis[0..<emojiCount], id: \.self) { emoji in
                        CardView(content: emoji).frame(width: cellSize.width, height: cellSize.height, alignment: .center)
                    }
                }
            }
            .foregroundColor(.red)
            Spacer()
            HStack {
                Spacer()
                animalButton
                Spacer()
                vehicleButton
                Spacer()
                sportsButton
                Spacer()
            }
            .font(.largeTitle)
            .padding(.horizontal)
        }
        .padding(.horizontal)
    }
    
    var animalButton: some View {
        Button {
            self.emojis = "🐶🐱🐭🐹🐰🦊🐻🐼🐻‍❄️🐨🐯🦁🐮🐷🐽🐸🐵🐔🐧🐦".map { String($0) }.shuffled()
            self.emojiCount = Int.random(in: minEmojiCount...emojis.count)
        } label: {
            VStack {
                Image(systemName: "hare")
                Text("Animals").font(.body)
            }
        }
    }
    
    var vehicleButton: some View {
        Button {
            self.emojis = "🚗🚕🚙🚌🚎🏎🚓🚑🚒🚐🛻🚚🚛🚜🛵🚲🛴🦽✈️🚆".map { String($0) }.shuffled()
            self.emojiCount = Int.random(in: minEmojiCount...emojis.count)
        } label: {
            VStack {
                Image(systemName: "car")
                Text("Vehicles").font(.body)
            }
        }
    }
    
    var sportsButton: some View {
        Button {
            self.emojis = "⚽️🏀🏈🏐🎾🥌🛼🏹🥊⛳️🏓🎱🥏🏒⛷🏂🪂🏋️‍♀️🏄‍♂️🚴🏻‍♀️".map { String($0) }.shuffled()
            self.emojiCount = Int.random(in: minEmojiCount...emojis.count)
        } label: {
            VStack {
                Image(systemName: "sportscourt")
                Text("Sports").font(.body)
            }
        }
    }
    
    private func largestCellSizeThatFitsAspectRatio(numberOfCells cellCount: Int, _ aspectRatio: CGFloat) -> CGSize {
        var largestSoFar = CGSize.zero
        for rowCount in 1...cellCount {
            largestSoFar = cellSizeAssuming(rowCount: rowCount, cellCount: cellCount, aspectRatio: aspectRatio, minimumAllowedSize: largestSoFar)
        }
        for columnCount in 1...cellCount {
            largestSoFar = cellSizeAssuming(columnCount: columnCount, cellCount: cellCount, aspectRatio: aspectRatio, minimumAllowedSize: largestSoFar)
        }
        return largestSoFar
    }
    
    private func cellSizeAssuming(rowCount: Int? = nil, columnCount: Int? = nil, cellCount: Int, aspectRatio: CGFloat, minimumAllowedSize: CGSize) -> CGSize {
        var size = CGSize.zero
        if let columnCount = columnCount {
            size.width = screenWidth / CGFloat(columnCount)
            size.height = size.width / aspectRatio
        } else if let rowCount = rowCount {
            size.height = screenHeight / CGFloat(rowCount)
            size.width = size.height * aspectRatio
        }
        if size.area > minimumAllowedSize.area,
           Int(screenWidth / size.width) * Int(screenHeight / size.height) >= cellCount {
            return size
        }
        return minimumAllowedSize
    }
}

private extension CGSize {
    var area: CGFloat { return width * height }
}

struct CardView: View {
    var content: String
    @State var isFaceUp: Bool = true
    
    var body: some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: 20)
            if isFaceUp {
                shape.fill(.white).foregroundColor(.white)
                shape.strokeBorder(lineWidth: 3)
                Text(content).font(.largeTitle)
            } else {
                shape.fill()
            }
        }
        .onTapGesture {
            isFaceUp = !isFaceUp
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.light)
        ContentView()
            .preferredColorScheme(.dark)
    }
}
