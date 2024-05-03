import Foundation
import Foundation
import UIKit

class SavedData {
    private init() {}

    static var shared = SavedData()

    var spaces = [SavedSpaceModel]()


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
}
