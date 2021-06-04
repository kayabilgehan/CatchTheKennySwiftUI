import SwiftUI

struct ContentView: View {
    @State var score = 0
    @State var timeLeft = 10.0
    @State var chosenX = 100.0
    @State var chosenY = 220.0
    
    //position tuples
    let (x1, y1) = (220.0,220.0)
    let (x2, y2) = (100.0,220.0)
    let (x3, y3) = (340.0,220.0)
    
    let (x4, y4) = (220.0,80.0)
    let (x5, y5) = (100.0,80.0)
    let (x6, y6) = (340.0,80.0)
    
    let (x7, y7) = (220.0,360.0)
    let (x8, y8) = (100.0,360.0)
    let (x9, y9) = (340.0,360.0)
    
    @State var tupleArray: [(Double, Double)]?
    
    @State var previousNumber: Int?
    
    @State var showAlert = false
    var counterTimer: Timer{
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.timeLeft -= 1
            print(String(self.timeLeft))
            if timeLeft <= 0 {
                print("girdi")
                self.timer.invalidate()
                self.counterTimer.invalidate()
                self.showAlert = true
            }
        }
    }
    
    var timer: Timer{
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            tupleArray = [(self.x1, self.y1), (self.x2, self.y2), (self.x3, self.y3),
                              (self.x4, self.y4), (self.x5, self.y5), (self.x6, self.y6),
                              (self.x7, self.y7), (self.x8, self.y8), (self.x9, self.y9)]
            
            let selectedTuple = tupleArray![self.randomNumberGenerator()]
            self.chosenX = selectedTuple.0
            self.chosenY = selectedTuple.1
        }
    }
    
    func randomNumberGenerator() -> Int {
        var randomNumber = Int(arc4random_uniform(UInt32(tupleArray!.count - 1)))
        while previousNumber == randomNumber {
            randomNumber = Int(arc4random_uniform(UInt32(tupleArray!.count - 1)))
        }
        previousNumber = randomNumber
        return randomNumber
    }
    
    var body: some View {
        VStack{
            Spacer().frame(height: 100)
            Text("Catch The Kenny").font(.largeTitle)
            HStack{
                Text("Time Left:")
                    .font(.title)
                Text(String(self.timeLeft))
                    .font(.title)
            }
            HStack{
                Text("Score: ")
                    .font(.title)
                Text(String(self.score))
                    .font(.title)
            }
            Spacer()
            Image("kenny")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .position(x: CGFloat(self.chosenX), y: CGFloat(self.chosenY))
                .gesture(TapGesture(count: 1).onEnded({ () in
                    self.score += 1
                }))
                
            
            Spacer()
        }
        .onAppear(perform: {
            _ = self.timer
            _ = self.counterTimer
        })
        .alert(isPresented: $showAlert, content: {
            return Alert(title: Text("Time Over!"), message: Text("Want to play again?"), primaryButton: Alert.Button.default(Text("Yes"), action: {
                self.score = 0
                self.timeLeft = 10
            }), secondaryButton: Alert.Button.cancel())
        })
    }
    
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
