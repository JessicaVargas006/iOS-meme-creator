/*
 Customized from Apple's Meme Creator sample.
*/

import SwiftUI

struct MemeCreator: View {
    @EnvironmentObject var fetcher: PandaCollectionFetcher

    @State private var cardTitle = ""
    @State private var cardSubtitle = ""
    @State private var textSize = 38.0
    @State private var textColor = Color.white
    @State private var darkOverlay = true
    @State private var addShadow = true
    @State private var selectedAlignment: CardTextAlignment = .center

    @FocusState private var isEditingTitle: Bool

    private let quickQuotes = [
        "Small steps still move you forward.",
        "Progress over perfection.",
        "You can do hard things.",
        "Discipline creates freedom.",
        "One day at a time.",
        "Stay consistent. Results follow.",
        "Rest is part of the plan.",
        "You are allowed to begin again.",
        "Keep going. Future you will thank you.",
        "Focus on what you can control."
    ]

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                cardPreview
                    .padding(.horizontal)

                editingPanel
                    .padding(.horizontal)

                actionButtons
                    .padding(.horizontal)
            }
            .padding(.vertical, 12)
        }
        .scrollDismissesKeyboard(.interactively)
        .background(Color(.systemGroupedBackground))
        .task {
            fetcher.loadLocalTemplates()
            applySuggestedText(for: fetcher.currentPanda)
        }
        .onChange(of: fetcher.currentPanda.assetName) { _ in
            applySuggestedText(for: fetcher.currentPanda)
        }
        .navigationTitle("Daily Motivation Cards")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Preview Card

    private var cardPreview: some View {
        LoadableImage(imageMetadata: fetcher.currentPanda, applyDarkOverlay: darkOverlay)
            .overlay(alignment: overlayAlignment) {
                VStack(spacing: 6) {
                    Text(cardTitle.isEmpty ? "Your quote here" : cardTitle)
                        .font(.system(size: textSize, weight: .heavy, design: .rounded))
                        .foregroundColor(textColor)
                        .multilineTextAlignment(selectedAlignment.textAlignment)
                        .minimumScaleFactor(0.55)
                        .lineLimit(4)
                        .shadow(color: addShadow ? .black.opacity(0.55) : .clear, radius: 8, x: 0, y: 3)

                    if !cardSubtitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        Text(cardSubtitle)
                            .font(.system(size: max(14, textSize * 0.36), weight: .semibold, design: .rounded))
                            .foregroundColor(textColor.opacity(0.95))
                            .multilineTextAlignment(selectedAlignment.textAlignment)
                            .lineLimit(2)
                            .minimumScaleFactor(0.75)
                            .shadow(color: addShadow ? .black.opacity(0.45) : .clear, radius: 6, x: 0, y: 2)
                    }
                }
                .padding(14)
                .frame(maxWidth: .infinity, alignment: selectedAlignment.frameAlignment)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(Color.black.opacity(darkOverlay ? 0.10 : 0.18))
                )
                .padding(12)
            }
            .frame(height: 245)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .accessibilityLabel("Motivation card preview")
    }

    // MARK: - Editing Panel

    private var editingPanel: some View {
        VStack(spacing: 10) {
            HStack {
                Label("Customize card", systemImage: "wand.and.stars")
                    .font(.headline)
                Spacer()
            }

            VStack(alignment: .leading, spacing: 6) {
                Text("Main quote")
                    .font(.subheadline.weight(.semibold))
                TextField("Type your motivational quote", text: $cardTitle)
                    .textFieldStyle(.roundedBorder)
                    .focused($isEditingTitle)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text("Subtitle / author")
                    .font(.subheadline.weight(.semibold))
                TextField("Example: Keep going • Jessica", text: $cardSubtitle)
                    .textFieldStyle(.roundedBorder)
            }

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text("Quote size")
                        .font(.subheadline.weight(.semibold))
                    Spacer()
                    Text("\(Int(textSize))")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Slider(value: $textSize, in: 24...64, step: 1)
            }

            HStack(spacing: 8) {
                Text("Text color")
                    .font(.subheadline.weight(.semibold))
                Spacer()
                ColorPicker("Text color", selection: $textColor)
                    .labelsHidden()
            }

            VStack(alignment: .leading, spacing: 6) {
                Text("Text alignment")
                    .font(.subheadline.weight(.semibold))

                // Segmented if it fits; menu fallback if width is tight
                ViewThatFits(in: .horizontal) {
                    Picker("Text alignment", selection: $selectedAlignment) {
                        ForEach(CardTextAlignment.allCases) { option in
                            Text(option.label).tag(option)
                        }
                    }
                    .pickerStyle(.segmented)

                    Picker("Text alignment", selection: $selectedAlignment) {
                        ForEach(CardTextAlignment.allCases) { option in
                            Text(option.label).tag(option)
                        }
                    }
                    .pickerStyle(.menu)
                }
            }

            Toggle("Dark overlay for readability", isOn: $darkOverlay)
            Toggle("Text shadow", isOn: $addShadow)
        }
        .controlSize(.small)
        .padding(12)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }

    // MARK: - Action Buttons

    private var actionButtons: some View {
        VStack(spacing: 8) {
            // First row with vertical fallback
            ViewThatFits(in: .horizontal) {
                HStack(spacing: 8) {
                    actionButtonShuffle
                    actionButtonRandomQuote
                }

                VStack(spacing: 8) {
                    actionButtonShuffle
                    actionButtonRandomQuote
                }
            }

            // Second row with vertical fallback
            ViewThatFits(in: .horizontal) {
                HStack(spacing: 8) {
                    actionButtonSuggested
                    actionButtonReset
                }

                VStack(spacing: 8) {
                    actionButtonSuggested
                    actionButtonReset
                }
            }
        }
        .controlSize(.small)
    }

    private var actionButtonShuffle: some View {
        Button {
            fetcher.shuffle()
        } label: {
            Label("Shuffle Background", systemImage: "photo.on.rectangle.angled")
                .lineLimit(1)
                .minimumScaleFactor(0.75)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .tint(.purple)
    }

    private var actionButtonRandomQuote: some View {
        Button {
            applyRandomQuickQuote()
        } label: {
            Label("Random Quote", systemImage: "sparkles")
                .lineLimit(1)
                .minimumScaleFactor(0.75)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.bordered)
    }

    private var actionButtonSuggested: some View {
        Button {
            applySuggestedText(for: fetcher.currentPanda)
        } label: {
            Label("Use Suggested Text", systemImage: "text.quote")
                .lineLimit(1)
                .minimumScaleFactor(0.70)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.bordered)
    }

    private var actionButtonReset: some View {
        Button {
            resetCardStyle()
        } label: {
            Label("Reset Style", systemImage: "arrow.counterclockwise")
                .lineLimit(1)
                .minimumScaleFactor(0.75)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.bordered)
    }

    // MARK: - Tip Card

    private var tipCard: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "lightbulb")
                .foregroundStyle(.yellow)
                .padding(.top, 1)

            VStack(alignment: .leading, spacing: 3) {
                Text("Quick idea for customization")
                    .font(.subheadline.weight(.semibold))

                Text("Create a themed set like gym motivation, school motivation, or affirmations. Change background + quote + color to show you can work with state, layout, and styling in SwiftUI.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 0)
        }
        .padding(10)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }

    // MARK: - Helpers

    private var overlayAlignment: Alignment {
        switch selectedAlignment {
        case .leading: return .bottomLeading
        case .center: return .bottom
        case .trailing: return .bottomTrailing
        }
    }

    private func applySuggestedText(for template: Panda) {
        cardTitle = template.suggestedQuote
        cardSubtitle = template.suggestedSubtitle
    }

    private func applyRandomQuickQuote() {
        cardTitle = quickQuotes.randomElement() ?? "Keep going."
        if cardSubtitle.isEmpty {
            cardSubtitle = "Today is a good day to start."
        }
    }

    private func resetCardStyle() {
        textSize = 38
        textColor = .white
        darkOverlay = true
        addShadow = true
        selectedAlignment = .center
    }
}

enum CardTextAlignment: String, CaseIterable, Identifiable {
    case leading
    case center
    case trailing

    var id: String { rawValue }

    var label: String {
        switch self {
        case .leading: return "Left"
        case .center: return "Center"
        case .trailing: return "Right"
        }
    }

    var textAlignment: TextAlignment {
        switch self {
        case .leading: return .leading
        case .center: return .center
        case .trailing: return .trailing
        }
    }

    var frameAlignment: Alignment {
        switch self {
        case .leading: return .leading
        case .center: return .center
        case .trailing: return .trailing
        }
    }
}
