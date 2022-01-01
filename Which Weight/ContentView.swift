//
//  ContentView.swift
//  Which Weight?
//
//  Created by Joe on 9/6/21.
//

import SwiftUI

struct ContentView: View
{
    @State private var showingSheet = false
    @State private var twoSides = true
    
    @State var barWeight = 45
    @State var targetWeight = 45
    
    /*@State var canUse2_5 = true
    @State var canUse5 = true
    @State var canUse10 = true
    @State var canUse25 = true
    @State var canUse45 = true*/
    
    @State var weightsToUse = [2.5:0, 5.0:0, 10.0:0, 25.0:0, 45.0:0]
    @State var eachSide: Double = 0.0
    
    let weights = [2.5, 5.0, 10.0, 25.0, 45.0]
    
    // Calculates how much weight to put on each side
    func updateEachSide()
    {
        print("Updating eachSide. twoSides is \(twoSides). eachSide is (before) \(eachSide)")
        eachSide = Double(targetWeight - barWeight) / (twoSides ? 2.0 : 1.0)
        print("eachSide is (after) \(eachSide)")
        return
    }
    
    // Calculates the weights needed for each level of disk weight available and stores it in self.weightsToUse[]
    func calculateWeights()
    {
        weightsToUse = [2.5:0, 5.0:0, 10.0:0, 25.0:0, 45.0:0]
        
        var weightLeftToAllocate = eachSide
       
        for weight in weights.reversed()
        {
            if weightLeftToAllocate <= 0
            {
                break
            }
            if weightLeftToAllocate >= weight
            {
                let howMany = Int(weightLeftToAllocate / weight)
                weightLeftToAllocate -= weight * Double(howMany)
                weightsToUse[weight] = howMany
            }
        }
        
        return
    }
    
    // Formats a Double to be nice to read... cuts off extraneous 0's after the decimal
    func formatWeightDouble(_ weight: Double) -> String
    {
        // Get the value after the decimal point
        let decimal = weight - floor(weight)
        
        // If we have an integer, format with no deicmal
        if decimal == 0
        {
            return String(format: "%.0f", weight)
        }
        
        // If we have a decimal, it'll be .5... return string with 1 decimal place
        return String(format: "%.1f", weight)
    }

    
    /*// Future feature - Returns array with booleans telling program which weights are good to use or not.
    func getPossibleWeightsArray() -> [Bool]
    {
        return [canUse2_5, canUse5, canUse10, canUse25, canUse45]
    }*/
    
    var body: some View
    {
        ZStack
        {
            bgGradient()
            VStack{
                Text("Calculate which plates to use during your workout:")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding()
                
                VStack{
                    Toggle(isOn: $twoSides){
                        Text("Are we dividing the weight into one side or two? (e.g. a sled or a barbell)")
                        .onChange(of: twoSides)
                        {_ in
                            updateEachSide();
                            calculateWeights();
                        }
                        .foregroundColor(Color.white)
                    }
                
                    if twoSides
                    {
                        Text("Two Sides")
                            .foregroundColor(Color.white)
                    } else {
                        Text("One Side")
                            .foregroundColor(Color.white)
                    }
                }
                .padding()
                
                HStack {
                    Stepper("The bar/sled is \(barWeight) lbs", value: $barWeight, in: 0...100, step: 5, onEditingChanged:
                            {_ in
                                updateEachSide();
                                calculateWeights();
                            })
                        .foregroundColor(.white)
                    
                }.padding()
                
                HStack {
                    Stepper("My target is \(targetWeight) lbs", value: $targetWeight, in: 0...1000, step: 5, onEditingChanged:
                            {_ in
                                updateEachSide();
                                calculateWeights();
                            })
                        .foregroundColor(.white)
                    
                }.padding()
                
                // Future feature
                /*VStack {
                    Text("Weights You Have Access To:")
                    Toggle("2.5 lbs", isOn: $canUse2_5)
                    Toggle("5 lbs", isOn: $canUse5)
                    Toggle("10 lbs", isOn: $canUse10)
                    Toggle("25 lbs", isOn: $canUse25)
                    Toggle("45 lbs", isOn: $canUse45)
                }.padding()*/
                
                Spacer()
                
                
                button(text: "Show plates to use") {updateEachSide();
                    calculateWeights();
                    showingSheet.toggle();
                    print("About to present sheet! eachSide: \(eachSide)");}
                .sheet(isPresented: $showingSheet) {
                        SheetView(eachSide: eachSide, weights: weights, weightsToUse: weightsToUse, twoSides: twoSides)
                    }
                .padding()
                
            }
        }
    }
}


// View that pops up with the solution
struct SheetView: View
{
    let eachSide: Double
    let weights: [Double]
    let weightsToUse: [Double:Int]
    let twoSides: Bool
    
    // Formats a Double to be nice to read... cuts off extraneous 0's after the decimal
    func formatWeightDouble(_ weight: Double) -> String
    {
        // Get the value after the decimal point
        let decimal = weight - floor(weight)
        
        // If we have an integer, format with no deicmal
        if decimal == 0
        {
            return String(format: "%.0f", weight)
        }
        
        // If we have a decimal, it'll be .5... return string with 1 decimal place
        return String(format: "%.1f", weight)
    }
    
    var body: some View
    {
        if twoSides
        {
            Text("Each Side: \(formatWeightDouble(eachSide)) lbs")
        } else {
            Text("Weight in addition to the bar/sled: \(formatWeightDouble(eachSide)) lbs")
        }
        HStack {
            Text("Made of:")
                .font(.title)
            
            VStack {
                ForEach(weights, id: \.self)
                {
                    if weightsToUse[$0] != 0
                    {
                        Text("\(weightsToUse[$0]!) * \(formatWeightDouble($0)) lbs")
                            .font(.title)
                    }
                }
            }
        }.padding()
        Text("Swipe down to dismiss.")
    }
}

// Nice looking button
fileprivate func button(text: String, width widthInt: Int = 280, _ action: @escaping ()->() = {}) -> some View
{
    let width = CGFloat(widthInt)
    
    return Button
    {
        action()
    } label: {
        Text(text)
            .frame(width: width, height: 40, alignment: .center)
            .background(.white)
            .cornerRadius(30)
            .foregroundColor(.black)
    }
}

// Nice looking background gradient
fileprivate func bgGradient(_ color1: Color = .gray, _ color2: Color = .black) -> some View
{
    return LinearGradient(colors: [color1, color2], startPoint: .topTrailing, endPoint: .bottomLeading)
    .ignoresSafeArea()
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
