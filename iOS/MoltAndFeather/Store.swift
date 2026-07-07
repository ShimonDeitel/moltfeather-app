import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    @Published var entries: [FeatherFind] = []
    @Published var isProUnlocked: Bool = false

    /// Free tier keeps every seeded entry visible without hitting the paywall on first launch.
    static let freeTierLimit = 20

    private let fileURL: URL

    init() {
        let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        let dir = appSupport.appendingPathComponent("MoltAndFeather", isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        fileURL = dir.appendingPathComponent("entries.json")
        load()
    }

    var canAddMore: Bool {
        isProUnlocked || entries.count < Store.freeTierLimit
    }

    func add(_ entry: FeatherFind) {
        guard canAddMore else { return }
        entries.insert(entry, at: 0)
        save()
    }

    func update(_ entry: FeatherFind) {
        guard let idx = entries.firstIndex(where: { $0.id == entry.id }) else { return }
        entries[idx] = entry
        save()
    }

    func delete(at offsets: IndexSet) {
        entries.remove(atOffsets: offsets)
        save()
    }

    func delete(_ entry: FeatherFind) {
        entries.removeAll { $0.id == entry.id }
        save()
    }

    private func load() {
        if let data = try? Data(contentsOf: fileURL),
           let decoded = try? JSONDecoder().decode([FeatherFind].self, from: data) {
            entries = decoded
        } else {
            entries = Store.seedData()
            save()
        }
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(entries) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }

    static func seedData() -> [FeatherFind] {
        [
        FeatherFind(species: "Feather Find 1", location: "Feather Find 1", notes: "Feather Find 1"),
        FeatherFind(species: "Feather Find 2", location: "Feather Find 2", notes: "Feather Find 2"),
        FeatherFind(species: "Feather Find 3", location: "Feather Find 3", notes: "Feather Find 3"),
        FeatherFind(species: "Feather Find 4", location: "Feather Find 4", notes: "Feather Find 4")
        ]
    }
}
