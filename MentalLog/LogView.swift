//
//  LogView.swift
//  MentalLog
//
//  Created by Cameron Bardell on 2019-12-19.
//  Copyright © 2019 Cameron Bardell. All rights reserved.
//

import SwiftUI

struct LogView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(
        entity: Event.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Event.text, ascending: false)
        ]
    ) var events: FetchedResults<Event>
    var body: some View {
        List {
            ForEach(self.events, id: \.self) { event in
                VStack {
                    Text("What happend: \(event.text)")
                    Text("Strategy used: \(event.stratUsed)")
                    Text("Strategy worked: \(event.stratWorked ? "yes" : "no")")
                }
            }.onDelete(perform: self.removeLog)
        }
    }
    
    func removeLog(at offsets: IndexSet) {
        for index in offsets {
            let event = events[index]
            managedObjectContext.delete(event)
        }
        do {
            try managedObjectContext.save()
        } catch {
            // handle the Core Data error
        }
    }
}

struct LogView_Previews: PreviewProvider {
    static var previews: some View {
        LogView()
    }
}
