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
                            .border(LinearGradient(gradient: Gradient(colors: [.primaryColor, .secondaryColor]), startPoint: .top, endPoint: .bottom), width: 6)
                    }.padding()
                    
                    NavigationLink(destination: StrategyView().environment(\.managedObjectContext, self.managedObjectContext)) {
                        Text("View and create strategies")
                            .foregroundColor(Color.black)
                            .frame(width: geometry.size.width - 100, height: geometry.size.height / 6)
                            .border(LinearGradient(gradient: Gradient(colors: [.primaryColor, .secondaryColor]), startPoint: .top, endPoint: .bottom), width: 6)
                    }.padding()
                    
                
                    
                    NavigationLink(destination: LogView().environment(\.managedObjectContext, self.managedObjectContext)) {
                        Text("View my log")
                            .foregroundColor(Color.black)
                            .frame(width: geometry.size.width - 100, height: geometry.size.height / 6)
                            .cornerRadius(10)
                            .border(LinearGradient(gradient: Gradient(colors: [.primaryColor, .secondaryColor]), startPoint: .top, endPoint: .bottom), width: 6)
                    }.padding()
                    .onAppear(perform: self.addFirstStrat)
                    
                    Spacer()
                    VStack {
                        Text("The strategy you have used most is \"\(self.strategies[0].text)\". You've used it \(self.strategies[0].totalUsed) times.").padding()
                        Text("You don't use \"\(self.strategies.last!.text)\" much. Maybe try it next time.").padding()
                    }.padding(.bottom)
              
                    
                }
            }.navigationBarTitle("What's going on?")
            
        }
    }
    
    func addFirstStrat() {
        if strategies.isEmpty {
            let strat = Strategy(context: self.managedObjectContext)
             strat.text = "Other"
             strat.totalUsed = 0
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
