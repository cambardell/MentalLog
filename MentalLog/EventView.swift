//
//  EventView.swift
//  MentalLog
//
//  Created by Cameron Bardell on 2019-12-19.
//  Copyright © 2019 Cameron Bardell. All rights reserved.
//

import SwiftUI

struct EventView: View {
    
    @State var whatHappened = ""
    @State var whatYouDid = ""
    @State var stratWorked = false
    @State var selectedStrat = 0
    
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
                    Text("What happened?")
                    Button(action: {
                        UIApplication.shared.endEditing()
                    }) {
                        Image(systemName: "keyboard.chevron.compact.down")
                    }
                   
                }
                TextView(text: self.$whatHappened)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    .border(LinearGradient(gradient: Gradient(colors: [.primaryColor, .secondaryColor]), startPoint: .top, endPoint: .bottom))
                Text("What strategy did you use?")
                
                Picker(selection: self.$selectedStrat, label: Text("")) {
                    ForEach(0 ..< self.strategies.count) {
                        Text(self.strategies[$0].text)
                    }
                }.border(LinearGradient(gradient: Gradient(colors: [.primaryColor, .secondaryColor]), startPoint: .top, endPoint: .bottom))
                
                Text("Did it work?").padding(.bottom)
                
                HStack {
                    Text("Yes")
                        .frame(width: geometry.size.width/2 - 20, height: 50)
                        .background(LinearGradient(gradient: Gradient(colors: self.stratWorked ? [.primaryColor, .secondaryColor] : [.white, .white]), startPoint: .top, endPoint: .bottom))
                        .border(LinearGradient(gradient: Gradient(colors: [.primaryColor, .secondaryColor]), startPoint: .top, endPoint: .bottom))
                        .onTapGesture {
                            self.stratWorked = true
                    }
                    Text("No")
                        .frame(width: geometry.size.width/2 - 20, height: 50)
                        .background(LinearGradient(gradient: Gradient(colors: self.stratWorked ? [.white, .white] : [.primaryColor, .secondaryColor]), startPoint: .top, endPoint: .bottom))
                        .border(LinearGradient(gradient: Gradient(colors: [.primaryColor, .secondaryColor]), startPoint: .top, endPoint: .bottom))
                        .onTapGesture {
                            self.stratWorked = false
                    }
                }.padding(.bottom)
                
                
                Spacer()
                Button(action: {
                    self.addEvent()
                }) {
                    Text("Log it")
                        .foregroundColor(Color.black)
                        .frame(width: 100, height: 50)
                        .background(LinearGradient(gradient: Gradient(colors: [.primaryColor, .secondaryColor]), startPoint: .top, endPoint: .bottom))
                        .cornerRadius(10)
                }
                
                Spacer()
            }.padding()
        }
    }
    
    func addEvent() {
        let event = Event(context: self.managedObjectContext)
        event.text = self.whatHappened
        event.stratUsed = self.strategies[selectedStrat].text
        event.stratWorked = stratWorked
        event.dateHappened = Date()
        if stratWorked {
            strategies[selectedStrat].worked += 1
        } else {
            strategies[selectedStrat].notWorked += 1
        }
        
        do {
            try self.managedObjectContext.save()
        } catch {
            // handle the Core Data error
        }
        self.selectedStrat = 0
        self.whatHappened = ""
        self.stratWorked = false
    }
}

struct TextView: UIViewRepresentable {
    @Binding var text: String
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> UITextView {
        
        let myTextView = UITextView()
        myTextView.delegate = context.coordinator
        
        myTextView.font = UIFont(name: "HelveticaNeue", size: 15)
        myTextView.isScrollEnabled = true
        myTextView.isEditable = true
        myTextView.isUserInteractionEnabled = true
        myTextView.backgroundColor = UIColor(white: 0.0, alpha: 0.05)
        
        return myTextView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }
    
    class Coordinator : NSObject, UITextViewDelegate {
        
        var parent: TextView
        
        init(_ uiTextView: TextView) {
            self.parent = uiTextView
        }
        
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            return true
        }
        
        func textViewDidChange(_ textView: UITextView) {
            print("text now: \(String(describing: textView.text!))")
            self.parent.text = textView.text
        }
    }
}

// To preview with CoreData
#if DEBUG
struct EventView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return EventView().environment(\.managedObjectContext, context)
    }
}
#endif
