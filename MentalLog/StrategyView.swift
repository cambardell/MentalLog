//
//  StrategyView.swift
//  MentalLog
//
//  Created by Cameron Bardell on 2019-12-19.
//  Copyright © 2019 Cameron Bardell. All rights reserved.
//

import SwiftUI

struct StrategyView: View {
    
    @State var stratText = ""
    
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
        GeometryReader { geometry in 
            VStack {
                HStack {
                    TextField("Enter a new strategy", text: self.$stratText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button(action: {
                        self.addStrat()
                    }) {
                        Text("Save")
                            .foregroundColor(Color.black)
                            .frame(width: 100, height: 35)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
                
                List {
                    ForEach(self.strategies, id: \.self) { strategy in
                        HStack {
                            Text(strategy.text)
                            Spacer()
                            VStack(alignment: .trailing) {
                                Text("Successful uses: \(strategy.worked)")
                                Text("Total uses: \(strategy.worked + strategy.notWorked)")
                            }
                        }.padding()
                    }.onDelete(perform: self.removeStrat)
                }
                
            }.padding()
        }
    }
    func addStrat() {
        let strat = Strategy(context: self.managedObjectContext)
        strat.text = self.stratText
        strat.notWorked = 0
        strat.worked = 0
       
        do {
            try self.managedObjectContext.save()
        } catch {
            // handle the Core Data error
        }
        self.stratText = ""
      
    }
    
    func removeStrat(at offsets: IndexSet) {
        for index in offsets {
            let strat = strategies[index]
            managedObjectContext.delete(strat)
        }
        do {
            try managedObjectContext.save()
        } catch {
            // handle the Core Data error
        }
    }
}

// To preview with CoreData
#if DEBUG
struct StrategyView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return StrategyView().environment(\.managedObjectContext, context)
    }
}
#endif
