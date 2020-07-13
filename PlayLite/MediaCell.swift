//
//  MediaCell.swift
//  PlayLite
//
//  Created by Samuel Défago on 13.07.20.
//

import SRGAppearance
import SwiftUI

struct MediaCell: View {
    var body: some View {
        HStack {
            Image(systemName: "film")
            VStack {
                Text("Title")
                    .font(.headline)
                Text("Date")
                    .font(.subheadline)
            }
        }
    }
}

struct MediaCell_Previews: PreviewProvider {
    static var previews: some View {
        MediaCell()
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
