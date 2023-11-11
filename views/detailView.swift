//
//  detailView.swift
//  gymui
//
//  Created by jack on 08/11/23.
//

import SwiftUI

struct detailView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var isStarted = false

    let section: Section
    var body: some View {
        List(section.exercises, id: \.name) { exercise in
            VStack(alignment: .leading) {
                Text(exercise.name)
                Text("\(exercise.sets) x \(exercise.reps) - \(Int(exercise.weight))kg").font(.caption)
            }
        }.navigationBarTitle(Text(section.name), displayMode: .inline)
        
        HStack{
            NavigationLink(destination: workoutView(currentSection: section)) {
                Label("Avvia", systemImage: "figure.run")
                    .frame(width: 150, height: 40)
                    .background(colorScheme == .dark ? Color.white : Color.black)
                    .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
                    .cornerRadius(15)
                    .padding()
            }
            NavigationLink(destination: editView(currentSection: section)) {
                Label("Modifica", systemImage: "pencil")
                    .frame(width: 150, height: 40)
                    .background(colorScheme == .dark ? Color.white : Color.black)
                    .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
                    .cornerRadius(15)
                    .padding()
            }
        }.frame(alignment: .bottom)
    }
}
