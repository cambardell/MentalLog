//
//  ContentView.swift
//  MentalLog
//
//  Created by Cameron Bardell on 2019-12-19.
//  Copyright © 2019 Cameron Bardell. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(
        entity: Event.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Event.text, ascending: false)
        ]
    ) var events: FetchedResults<Event>
    
    @FetchRequest(
        entity: Strategy.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Strategy.worked, ascending: false)
        ]
    ) var strategies: FetchedResults<Strategy>
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    
                    Spacer()
                    
                    NavigationLink(destination: EventView().environment(\.managedObjectContext, self.managedObjectContext)) {
                        Text("Log an event")
                            .foregroundColor(Color.black)
                            .frame(width: geometry.size.width - 20, height: geometry.size.height / 3.5)
                            .background(LinearGradient(gradient: Gradient(colors: [.white, .blue]), startPoint: .top, endPoint: .bottom))
                            .cornerRadius(10)
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: StrategyView().environment(\.managedObjectContext, self.managedObjectContext)) {
                        Text("View and create strategies")
                            .foregroundColor(Color.black)
                            .frame(width: geometry.size.width - 20, height: geometry.size.height / 3.5)
                            .background(LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .top, endPoint: .bottom))
                            .cornerRadius(10)
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: LogView().environment(\.managedObjectContext, self.managedObjectContext)) {
                        Text("View my log")
                            .foregroundColor(Color.black)
                            .frame(width: geometry.size.width - 20, height: geometry.size.height / 3.5)
                            .background(LinearGradient(gradient: Gradient(colors: [.purple, .white]), startPoint: .top, endPoint: .bottom))
                            .cornerRadius(10)
                    }.onAppear(perform: self.addFirstStrat)
                    
                    Spacer()
                    
                }
            }.navigationBarTitle("What's going on?")
        }
        
    }
    func addFirstStrat() {
        if strategies.isEmpty {
            let strat = Strategy(context: self.managedObjectContext)
             strat.text = "Example strategy"
             strat.notWorked = 0
             strat.worked = 0
            
             do {
                 try self.managedObjectContext.save()
             } catch {
                 // handle the Core Data error
             }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
