import Foundation
import Foundation
import UIKit
import Firebase

class SavedData {
    private init() {}

    static var shared = SavedData()

    var spaces = [
        SavedSpaceModel(
            name: "space",
            sources: [SoundViewModel(file: .clap, volume: 55, isActive: true, pitch: 123)],
            date: "04.05.2024 15:55")
    ]
    //[SavedSpaceModel]()


    static func saveData(){
        do
        {
            UserDefaults.standard.set(try PropertyListEncoder().encode(SavedData.shared.spaces), forKey: "spaces")
            UserDefaults.standard.synchronize()
        }
        catch
        {
            print(error.localizedDescription)
        }
    }

    static func loadData(){
        if let storedObject: Data = UserDefaults.standard.data(forKey: "spaces")
        {
            do
            {
                let favs = try PropertyListDecoder().decode([SavedSpaceModel].self, from: storedObject)
                SavedData.shared.spaces = favs
            }
            catch
            {
                print(error.localizedDescription)
            }
        }

    }

    static func encodeData(_ space: SavedSpaceModel) -> [String: Any] {
        var encodedSources = [[String: Any]]()

        for source in space.sources {
            let encodedSource = [
                "volume": source.volume,
                "pitch": source.pitch,
                "isActive": source.isActive ? 1 : 0,
                "file": source.file.name
            ] as [String : Any]
            encodedSources.append(encodedSource)
        }
        return ["name": space.name, "date": space.date, "sources": encodedSources]
    }


    static func parseData(_ data: [String: Any]) -> SavedSpaceModel{
        let name = data["name"] as? String ?? ""
        let date = data["date"] as? String ?? ""
        let sources = data["sources"] as? [[String: Any]] ?? [[:]]
        var models = [SoundViewModel]()
        for source in sources {
            let volume = source["volume"] as? Int ?? 0
            let pitch = source["pitch"] as? Int ?? 0
            let isActive = source["isActive"] as? Int ?? 0
            let file = getFile(source["file"] as? String ?? "")
            let model = SoundViewModel(file: file, volume: volume, isActive: isActive == 1, pitch: pitch)
            models.append(model)
        }
        return SavedSpaceModel(name: name, sources: models, date: date)
    }
}
