//
//  ContentView.swift
//  gymui
//
//  Created by jack on 04/11/23.
//

import SwiftUI

struct MainView: View {
    @State private var sections: [Section] = []
    @State private var showingDeleteAlert = false
    @State private var deleteIndexSet: IndexSet?
    @EnvironmentObject var shared: Shared

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text("BetterSelf")
                            .font(.title).bold()
                        Text("My workouts")
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
                    // load data from web service
                    getWorkoutData(token: shared.token!) { result in
                      switch result {
                      case .success(let sections2):
                      sections = sections2
                      case .failure(let error):
                        print("error getting workouts: \(error)")
                      }
                    }
                }
            }
            .alert(isPresented: $showingDeleteAlert) {
                Alert(title: Text("Delete section"),
                      message: Text("Are you sure that you want to delete this section?"),
                      primaryButton: .destructive(Text("Delete")) {
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
        MainView()
    }
}
