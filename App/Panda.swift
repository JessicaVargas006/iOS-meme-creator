import SwiftUI

struct Panda {
    var description: String
    var assetName: String
    var suggestedQuote: String
    var suggestedSubtitle: String

    static let defaultPanda = Panda(
        description: "Sunrise Glow",
        assetName: "sunriseGlow",
        suggestedQuote: "Start where you are. Use what you have. Do what you can.",
        suggestedSubtitle: "Today still counts."
    )

    static let localTemplates: [Panda] = [
        Panda(description: "Sunrise Glow",
              assetName: "sunriseGlow",
              suggestedQuote: "Start where you are. Use what you have. Do what you can.",
              suggestedSubtitle: "Today still counts."),
        Panda(description: "Ocean Calm",
              assetName: "oceanCalm",
              suggestedQuote: "Breathe. Reset. Keep moving.",
              suggestedSubtitle: "Calm is a superpower."),
        Panda(description: "Lavender Dream",
              assetName: "lavenderDream",
              suggestedQuote: "Protect your peace and your progress.",
              suggestedSubtitle: "Softness and strength can coexist."),
        Panda(description: "Forest Zen",
              assetName: "forestZen",
              suggestedQuote: "Consistency beats intensity when you’re building a life.",
              suggestedSubtitle: "Little by little."),
        Panda(description: "Midnight Focus",
              assetName: "midnightFocus",
              suggestedQuote: "Discipline will take you places motivation can’t.",
              suggestedSubtitle: "Lock in."),
        Panda(description: "Peach Sky",
              assetName: "peachSky",
              suggestedQuote: "You are allowed to begin again.",
              suggestedSubtitle: "No guilt. Just growth."),
        Panda(description: "Amber Flow",
              assetName: "amberFlow",
              suggestedQuote: "Be proud of how hard you’re trying.",
              suggestedSubtitle: "It matters."),
        Panda(description: "Mint Wave",
              assetName: "mintWave",
              suggestedQuote: "Small steps still move you forward.",
              suggestedSubtitle: "Momentum > perfection."),
        Panda(description: "Blue Horizon",
              assetName: "blueHorizon",
              suggestedQuote: "Stay focused on the next right step.",
              suggestedSubtitle: "One decision at a time."),
        Panda(description: "Rose Energy",
              assetName: "roseEnergy",
              suggestedQuote: "Show up for the life you said you wanted.",
              suggestedSubtitle: "You got this.")
    ]
}

struct PandaCollection {
    var sample: [Panda]
}
