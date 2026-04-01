import SwiftUI

@MainActor
class PandaCollectionFetcher: ObservableObject {
    @Published var imageData = PandaCollection(sample: Panda.localTemplates)
    @Published var currentPanda = Panda.defaultPanda

    func fetchData() async throws {
        loadLocalTemplates()
    }

    func loadLocalTemplates() {
        imageData = PandaCollection(sample: Panda.localTemplates)
        if !imageData.sample.contains(where: { $0.assetName == currentPanda.assetName }) {
            currentPanda = imageData.sample.first ?? Panda.defaultPanda
        }
    }

    func shuffle() {
        let options = imageData.sample.filter { $0.assetName != currentPanda.assetName }
        currentPanda = options.randomElement() ?? currentPanda
    }
}
