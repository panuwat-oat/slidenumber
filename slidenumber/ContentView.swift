import SwiftUI

struct ContentView: View {
    @State private var numbers = (1...15).shuffled() + [0] // 0 represents the empty space
    @State private var movesCount = 0
    
    var body: some View {
        VStack {
            Text("Slide Number Puzzle")
                .font(.largeTitle)
            
            Grid(numbers: $numbers, movesCount: $movesCount)
            
            Button("New Game") {
                numbers = (1...15).shuffled() + [0]
                movesCount = 0
            }
            
            Text("Moves: \(movesCount)")
                .font(.headline)
        }
    }
}

struct Grid: View {
    @Binding var numbers: [Int]
    @Binding var movesCount: Int
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(numbers.indices, id: \.self) { index in
                NumberView(number: numbers[index])
                    .onTapGesture {
                        moveNumber(at: index)
                    }
                    .animation(.linear, value: numbers) // Animate the change in numbers array
                
            }
        }
        .padding()
    }
    
    func moveNumber(at index: Int) {
        let row = index / 4
        let column = index % 4
        let emptyIndex = numbers.firstIndex(of: 0)!
        let emptyRow = emptyIndex / 4
        let emptyColumn = emptyIndex % 4
        
        // Check if the empty space is adjacent to the tapped number
        if (row == emptyRow && abs(column - emptyColumn) == 1) || (column == emptyColumn && abs(row - emptyRow) == 1) {
            numbers.swapAt(index, emptyIndex)
            movesCount += 1
        }
    }
}

struct NumberView: View {
    let number: Int
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(number == 0 ? .clear : .orange)
                .frame(width: 70, height: 70)
                .shadow(radius: number == 0 ? 0 : 5)
            
            if number != 0 {
                Text("\(number)")
                    .font(.largeTitle)
                    .foregroundColor(.white)
            }
        }
    }
}

