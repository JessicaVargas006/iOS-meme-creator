/*
 Local asset image loader for motivation card backgrounds.
*/

import SwiftUI
import UIKit

struct LoadableImage: View {
    var imageMetadata: Panda
    var applyDarkOverlay: Bool = true

    var body: some View {
        ZStack {
            if UIImage(named: imageMetadata.assetName) != nil {
                Image(imageMetadata.assetName)
                    .resizable()
                    .scaledToFill()
            } else {
                Image("motivationplaceholder")
                    .resizable()
                    .scaledToFill()
            }

            if applyDarkOverlay {
                LinearGradient(
                    colors: [
                        .black.opacity(0.05),
                        .black.opacity(0.10),
                        .black.opacity(0.28),
                        .black.opacity(0.42)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
        }
        .frame(maxWidth: .infinity)
        .clipped()
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text(imageMetadata.description))
    }
}

struct LoadableImage_Previews: PreviewProvider {
    static var previews: some View {
        LoadableImage(imageMetadata: Panda.defaultPanda)
            .padding()
    }
}
