//
//  ContentView.swift
//  Which Weight?
//
//  Created by Joe on 9/6/21.
//

import SwiftUI

struct ContentView: View {
    
    @State var barWeight = 45
    @State var targetWeight = 200
    
    @State var canUse2_5 = true
    @State var canUse5 = true
    @State var canUse10 = true
    @State var canUse25 = true
    @State var canUse45 = true
    
    
    // Returns a String with the value of weight to put on each side of the barbell
    func eachSide() -> String
    {
        // Calculate the weight on each side of the barbell
        let eachSide = (Double(targetWeight) - Double(barWeight))/2.0
        
        // Get the value after the decimal point
        let decimal = eachSide - floor(eachSide)
        
        // If we have an integer, format with no deicmal
        if decimal == 0
        {
            return String(format: "%.0f", eachSide)
        }
        
        // If we have a decimal, it'll be .5... return string with 1 decimal place
        return String(format: "%.1f", eachSide)
    }
    
    var weightsToUse = ["2.5":0, "5":0, "10":0, "25":0, "45":0]
    
    var body: some View {
        VStack{
            HStack {
                Stepper("The bar is \(barWeight) lbs", value: $barWeight, in: 0...100, step: 5)
                
            }.padding()
            
            HStack {
                Stepper("My target is \(targetWeight) lbs", value: $targetWeight, in: 0...1000, step: 5)
                
            }.padding()
            
            VStack {
                Text("Weights You Can Use:")
                Toggle("2.5 lbs", isOn: $canUse2_5)
                Toggle("5 lbs", isOn: $canUse5)
                Toggle("10 lbs", isOn: $canUse10)
                Toggle("25 lbs", isOn: $canUse25)
                Toggle("45 lbs", isOn: $canUse45)
            }.padding()
            
            VStack{
                Text("Solution:")
                Text("Each Side: \(eachSide()) lbs")
                HStack {
                    Text("Made of:")
                    VStack {
                        Text("Y * XX lbs")
                        Text("Y * XX lbs")
                        Text("Y * XX lbs")
                    }
                }.padding()
            }.padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
