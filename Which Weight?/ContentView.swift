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
    
    @State var barWeight = 45
    @State var targetWeight = 200
    
    /*@State var canUse2_5 = true
    @State var canUse5 = true
    @State var canUse10 = true
    @State var canUse25 = true
    @State var canUse45 = true*/
    
    @State var weightsToUse = [2.5:0, 5.0:0, 10.0:0, 25.0:0, 45.0:0]
    
    @State var eachSide = 0.0
    
    let weights = [2.5, 5.0, 10.0, 25.0, 45.0]
    
    // Calculates how much weight to put on each side
    func updateEachSide()
    {
        eachSide = Double(targetWeight - barWeight) / 2.0
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
    
    /*// Returns array with booleans telling program which weights are good to use or not
    func getPossibleWeightsArray() -> [Bool]
    {
        return [canUse2_5, canUse5, canUse10, canUse25, canUse45]
    }*/
    
    var body: some View
    {
        VStack{
            HStack {
                Stepper("The bar is \(barWeight) lbs", value: $barWeight, in: 0...100, step: 5)
                
            }.padding()
            
            HStack {
                Stepper("My target is \(targetWeight) lbs", value: $targetWeight, in: 0...1000, step: 5)
                
            }.padding()
            
            /*VStack {
                Text("Weights You Have Access To:")
                Toggle("2.5 lbs", isOn: $canUse2_5)
                Toggle("5 lbs", isOn: $canUse5)
                Toggle("10 lbs", isOn: $canUse10)
                Toggle("25 lbs", isOn: $canUse25)
                Toggle("45 lbs", isOn: $canUse45)
            }.padding()*/
            
            VStack{
                Button("Show Weights") {updateEachSide(); calculateWeights(); showingSheet.toggle()}
                    .sheet(isPresented: $showingSheet) { SheetView(eachSide: eachSide, weights: weights, weightsToUse: weightsToUse) }
            }.padding()
        }
    }
}

struct SheetView: View
{
    let eachSide: Double
    let weights: [Double]
    let weightsToUse: [Double:Int]
    
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
        Text("Each Side: \(formatWeightDouble(eachSide)) lbs")
        HStack {
            Text("Made of:")
            VStack {
                ForEach(weights, id: \.self)
                {
                    if weightsToUse[$0] != 0
                    {
                        Text("\(weightsToUse[$0]!) * \(formatWeightDouble($0)) lbs")
                    }
                }
            }
        }.padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
