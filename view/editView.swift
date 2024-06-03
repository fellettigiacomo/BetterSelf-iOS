//
//  editView.swift
//  gymui
//
//  Created by jack on 08/11/23.
//
import SwiftUI

struct editView: View {
    var currentSection: Section
    @State private var countdown = 3
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack {
            if countdown > 0 {
                Text("\(countdown)")
                    .font(.largeTitle)
                    .onReceive(timer) { _ in
                        if countdown > 0 {
                            countdown -= 1
                        }
                    }
            } else {
                List {
                    Text(currentSection.name).font(.headline)
                }.navigationBarTitle(Text("WorkoutView TBD"), displayMode: .inline)
            }
        }
        .onAppear {
            countdown = 3
        }
    }
}
