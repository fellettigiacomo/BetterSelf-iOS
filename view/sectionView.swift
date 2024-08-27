//
//  sectionView.swift
//  gymui
//
//  Created by jack on 08/11/23.
//

import SwiftUI

struct sectionView: View {
    let section: Section
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(section.name).font(.title)
                Text(section.muscleGroup)
            }
        }
    }
}
