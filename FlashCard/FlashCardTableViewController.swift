//
//  FlashCardTableViewController.swift
//  FlashCard
//
//  Created by Yi Feng Ye on 8/28/17.
//  Copyright © 2017 Yi Feng Ye. All rights reserved.
//

import UIKit
import os.log

class FlashCardTableViewController: UITableViewController {

    //MARK: Properties
    var flashCards = [FlashCardData]()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = editButtonItem
        
        if let savedFlashCards = loadFlashCards() {
            flashCards += savedFlashCards
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flashCards.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CardTableViewCell", for: indexPath) as? CardTableViewCell else {
            fatalError("The dequeued cell is not an instance of CardTableViewCell.")
        }

        let cardData = flashCards[indexPath.row]
        
        cell.setFlashCardData(data: cardData)

        return cell
    }

    @IBAction func unwindToFlashCardList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? DetailViewController, let cardData = sourceViewController.cardData {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                flashCards[selectedIndexPath.row] = cardData
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                let indexPath = IndexPath(row: flashCards.count, section: 0)
                flashCards.append(cardData)
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
            saveFlashCards()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
        case "AddItem":
            os_log("Adding a new card", log: OSLog.default, type: .debug)
        case "ShowDetail":
            guard let detailViewController = segue.destination as? DetailViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedCell = sender as? CardTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedCard = flashCards[indexPath.row]
            detailViewController.cardData = selectedCard
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            flashCards.remove(at: indexPath.row)
            saveFlashCards()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    private func saveFlashCards() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(flashCards, toFile: FlashCardData.ArchiveURL.path)
        
        if isSuccessfulSave {
            os_log("FlashCards successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save FlashCards...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadFlashCards() -> [FlashCardData]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: FlashCardData.ArchiveURL.path) as? [FlashCardData]
    }

    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
