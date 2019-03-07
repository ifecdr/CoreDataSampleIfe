

import UIKit
import CoreData

class GameViewController: UIViewController {

    @IBOutlet var nameLabel: UITextField!
    @IBOutlet var colorLabel: UITextField!
    @IBOutlet var sizeLabel: UITextField!
    
    var service: CoreDataService!
    var myGame: Games!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadGames()
    }
    
    func loadGames() {
        if let game = myGame {
            nameLabel.text = game.name
            colorLabel.text = game.color
            sizeLabel.text = String(game.size)
        }
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
        
        guard let name = nameLabel.text else { return }
        guard let color = colorLabel.text else { return }
        guard let sizeStr = sizeLabel.text, let size = Int16(sizeStr) else { return }
        
        updateOrCreateGame(name, color, size)
    }
    
    func updateOrCreateGame(_ name: String, _ color: String, _ size: Int16) {
        // get the context
        let context = service.context
        
        if myGame == nil {
            myGame = NSEntityDescription.insertNewObject(forEntityName: "Games", into: context) as? Games
        }
        myGame.name = name
        myGame.color = color
        myGame.size = size
        
        // save (the Game in) the context
        service.saveContext()
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deleteButtonAction(_ sender: Any) {
        service.deleteGame(myGame)
        
        nameLabel.text = nil
        colorLabel.text = nil
        sizeLabel.text = nil
        
        navigationController?.popViewController(animated: true)
    }
}



