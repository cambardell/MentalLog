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
                LogItem(event: event)
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

struct LogItem: View {
    var event: Event
    var body: some View {
        VStack(alignment: .leading) {
            Text("What happened: \(event.text)")
            Text("The strategy you used was \"\(event.stratUsed)\". You said it \(event.stratWorked ? "worked" : "didn't work").")
            Text("Date of event: \(formatDate(date: event.dateHappened))")
            
            
        }
    }
    
    func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}

// To preview with CoreData
#if DEBUG
struct LogView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return LogView().environment(\.managedObjectContext, context)
    }
}
#endif


