//
//  newView.swift
//  gymui
//
//  Created by jack on 08/11/23.
//

import SwiftUI

struct newView: View{
    var body: some View{
        List{
            Text("to be done").font(.headline)
        }.navigationBarTitle(Text("newView"), displayMode: .inline)
    }
}

#Preview {
    newView()
}
