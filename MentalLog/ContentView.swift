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
                            .border(LinearGradient(gradient: Gradient(colors: [.primaryColor, .secondaryColor]), startPoint: .top, endPoint: .bottom))
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: StrategyView().environment(\.managedObjectContext, self.managedObjectContext)) {
                        Text("View and create strategies")
                            .foregroundColor(Color.black)
                            .frame(width: geometry.size.width - 20, height: geometry.size.height / 3.5)
                            .border(LinearGradient(gradient: Gradient(colors: [.secondaryColor, .primaryColor]), startPoint: .top, endPoint: .bottom))
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: LogView().environment(\.managedObjectContext, self.managedObjectContext)) {
                        Text("View my log")
                            .foregroundColor(Color.black)
                            .frame(width: geometry.size.width - 20, height: geometry.size.height / 3.5)
                            .cornerRadius(10)
                            .border(LinearGradient(gradient: Gradient(colors: [.primaryColor, .secondaryColor]), startPoint: .top, endPoint: .bottom))
                    }.onAppear(perform: self.addFirstStrat)
                    
                    Spacer()
                    
                }
            }.navigationBarTitle("What's going on?")
        }
    }
    
    func addFirstStrat() {
        if strategies.isEmpty {
            let strat = Strategy(context: self.managedObjectContext)
             strat.text = "No strategy tried"
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

// To preview with CoreData
#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return ContentView().environment(\.managedObjectContext, context)
    }
}
#endif
