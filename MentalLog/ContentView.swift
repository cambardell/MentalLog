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
            NSSortDescriptor(keyPath: \Strategy.totalUsed, ascending: false)
        ]
    ) var strategies: FetchedResults<Strategy>
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    
                    NavigationLink(destination: EventView().environment(\.managedObjectContext, self.managedObjectContext)) {
                        Text("Log an event")
                            .foregroundColor(Color.black)
                            .frame(width: geometry.size.width - 100, height: geometry.size.height / 6)
                            .background(Color.primaryColor)
                            .cornerRadius(10)
                    }.padding()
                    
                    NavigationLink(destination: StrategyView().environment(\.managedObjectContext, self.managedObjectContext)) {
                        Text("View and create strategies")
                            .foregroundColor(Color.black)
                            .frame(width: geometry.size.width - 100, height: geometry.size.height / 6)
                            .background(Color.tertiaryColor)
                            .cornerRadius(10)
                    }.padding()

                    
                    NavigationLink(destination: LogView().environment(\.managedObjectContext, self.managedObjectContext)) {
                        Text("View my log")
                            .foregroundColor(Color.black)
                            .frame(width: geometry.size.width - 100, height: geometry.size.height / 6)
                            .background(Color.secondaryColor)
                            .cornerRadius(10)
                    }.padding()
                    .onAppear(perform: self.addFirstStrat)
                    
                    
                    VStack {
                        if !self.strategies.isEmpty {
                            Text("The strategy you have used most is \"\(self.strategies[0].text)\". You've used it \(self.strategies[0].totalUsed) times. \nYou don't use \"\(self.strategies.last!.text)\" much. Maybe try it next time.").foregroundColor(Color.white).padding()
                        }
                    }.background(Color.fourthColor)
                    .cornerRadius(10)
                    .padding()
                    
                }
            }.navigationBarTitle("What's going on?")
            
        }.accentColor(Color.secondaryColor)
    }
    
    func addFirstStrat() {
        if strategies.isEmpty {
            let strat = Strategy(context: self.managedObjectContext)
             strat.text = "Other"
             strat.totalUsed = 0
             strat.worked = 0
            let strat2 = Strategy(context: self.managedObjectContext)
            strat2.text = "None"
            strat2.totalUsed = 0
            strat2.worked = 0
            
             do {
                 try self.managedObjectContext.save()
             } catch {
                 // handle the Core Data error
             }
        }
    }
}

// To preview with CoreData
#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return ContentView().environment(\.managedObjectContext, context)
    }
}
#endif
