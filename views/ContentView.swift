//
//  ContentView.swift
//  gymui
//
//  Created by jack on 04/11/23.
//

import SwiftUI

struct ContentView: View {
    @State private var sections: [Section] = []
    @State private var showingDeleteAlert = false
    @State private var deleteIndexSet: IndexSet?

    var body: some View {
        NavigationView {
            VStack {
                // La tua "toolbar" personalizzata
                HStack {
                    VStack(alignment: .leading) {
                        Text("BetterSelf")
                            .font(.title).bold()
                        Text("I miei workout")
                    }
                    Spacer()
                    NavigationLink(destination: newView()) {
                        Image(systemName: "doc.badge.plus")
                    }
                }
                .padding()

                List {
                    ForEach(sections, id: \.name) { section in
                        NavigationLink(destination: detailView(section: section)) {
                            sectionView(section: section)
                        }
                    }
                    .onDelete(perform: deleteSectionPopUp)
                }
                .onAppear {
                    let flMgr = WorkoutParser()
                    sections = flMgr.parseXML()
                }
            }
            .alert(isPresented: $showingDeleteAlert) {
                Alert(title: Text("Conferma eliminazione"),
                      message: Text("Sei sicuro di voler eliminare questa sezione?"),
                      primaryButton: .destructive(Text("Elimina")) {
                          deleteSection()
                      },
                      secondaryButton: .cancel())
            }
        }
    }

    private func deleteSectionPopUp(at offsets: IndexSet) {
        deleteIndexSet = offsets
        showingDeleteAlert = true
    }

    private func deleteSection() {
        if let set = deleteIndexSet {
            sections.remove(atOffsets: set)
        }
        deleteIndexSet = nil
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
