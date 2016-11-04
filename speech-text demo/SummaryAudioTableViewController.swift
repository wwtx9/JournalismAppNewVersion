//
//  SummaryAudioTableViewController.swift
//  speech-text demo
//
//  Created by Wang Weihan on 10/16/16.
//  Copyright © 2016 Wang Weihan. All rights reserved.
//

import UIKit
import CoreData

class SummaryAudioTableViewController: UITableViewController {
    var records = [Record]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Transcript Summary"
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setToolbarHidden(false, animated: false)
        records = getNotes()
        tableView.reloadData()
    }
    func getNotes() -> [Record]{
        let fetchRequest  = NSFetchRequest<Record>(entityName: "Record")
        do {
            let foundNotes = try getContext().fetch(fetchRequest)
            return foundNotes
        } catch {
            print("Error with request: \(error)")
        }
        
        return [Record]()
    }
    
    func deleteNote(indexPath: IndexPath) {
        let row = indexPath.row
        
        if (row < records.count) {
            let note = records[row]
            
            // remove from array of notes
            records.remove(at: row)
            // delete managed not object from context
            getContext().delete(note)
            do {
                try getContext().save()
            } catch let error as NSError {
                print("Could not save \(error), \(error.userInfo)")
            }
        }
        
        // the following needs to be done AFTER the note is removed from the array of notes
        // Why? Because whent he row is deleted tableView numberOfRowsInSection will get called
        // to find out how many rows there are.  If the notes array hasn't been updated the count
        // of notes won't match the number of rows in the table and an error will occur.
        tableView.deleteRows(at: [indexPath], with: .fade)
    }

    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return records.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "audioCell", for: indexPath)
        cell.textLabel?.text = records[indexPath.row].tile
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source and the tableView
            deleteNote(indexPath: indexPath)
        }
    }
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "sendTrans", let destination = segue.destination as? EditRecordViewController,  let indexPath = tableView.indexPathForSelectedRow {
            /*destination.titleSummary = records[indexPath.row].tile!
            destination.transcript = records[indexPath.row].transcript!
            destination.durationTime = records[indexPath.row].recordTime!
            destination.saveDate = records[indexPath.row].date! as Date*/
            destination.record = records[indexPath.row]
            destination.selectIndex = indexPath.row
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
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
