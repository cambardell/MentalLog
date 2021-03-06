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
    
    let exampleStrats: [String] = [
        "Meditate",
        "Listen to music",
        "Exercise",
        "Breathing exercises",
        "Reach out to a friend",
        "Reach out to a family member",
        "Write in a journal",
        "Take a walk outside",
        "Use a mindfulness app",
        "Use a meditation app",
        "Contact a professional",
        "Do a puzzle"
    ]
    
    @State var exampleStrat = ""
    
    var body: some View {
        GeometryReader { geometry in 
            VStack(alignment: .leading) {
                HStack {
                    TextField("Enter a new strategy", text: self.$stratText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button(action: {
                        self.addStrat()
                    }) {
                        Text("Save")
                            .foregroundColor(Color.black)
                            .frame(width: 100, height: 35)
                            .background(Color.tertiaryColor)
                            .cornerRadius(10)
                    }
                }.onAppear(perform: self.setExampleStrat)
                    .padding([.leading, .trailing])
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Example strategy: ")
                        Text(self.exampleStrat)
                    }
                    Spacer()
                    Button(action: {
                        self.saveExampleStrat()
                    }) {
                        Image(systemName: "plus")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(Color.tertiaryColor)
                    }
                    
                    
                }.padding([.leading, .trailing])
                
                Text("Your most successful strategy by average score is \(self.bestStrat().text), with a score of \(calculateSucces(strategy: self.bestStrat())) out of 5.").padding([.leading, .trailing])
                    
                List {
                    ForEach(self.strategies, id: \.self) { strategy in
                        StrategyItem(strategy: strategy)
                    }.onDelete(perform: self.removeStrat)
                }
                
            }
        }
    }
    
    func saveExampleStrat() {
        let strat = Strategy(context: self.managedObjectContext)
        strat.text = exampleStrat
        strat.totalUsed = 0
        strat.worked = 0
        do {
            try self.managedObjectContext.save()
        } catch {
            // handle the Core Data error
        }
        self.exampleStrat = self.exampleStrats.randomElement()!
    }
    
    func setExampleStrat() {
        self.exampleStrat = self.exampleStrats.randomElement()!
    }
    
    func addStrat() {
        let strat = Strategy(context: self.managedObjectContext)
        strat.text = self.stratText
        strat.totalUsed = 0
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
    
    func bestStrat() -> Strategy {
        var topStrat = strategies[0]
        for strategy in strategies {
            if calculateSucces(strategy: strategy) > calculateSucces(strategy: topStrat) {
                topStrat = strategy
            }
            
        }
        
        return topStrat
    }
}

struct StrategyItem: View {
    var strategy: Strategy
    var body: some View {
        VStack(alignment: .leading) {
            Text(strategy.text).font(.title)
            Text("You have used this strategy \(strategy.totalUsed) times, and given it an average score of \(calculateSucces(strategy: strategy)) out of 5.")
        }
        
    }
}

func calculateSucces(strategy: Strategy) -> Int {
    if strategy.totalUsed > 0 {
        return Int(strategy.worked / strategy.totalUsed)
    } else {
        return 0
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


