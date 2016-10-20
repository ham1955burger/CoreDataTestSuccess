//
//  ViewController.swift
//  CoreDataTest
//
//  Created by ouniwang on 10/17/16.
//  Copyright © 2016 ham. All rights reserved.
//

import UIKit
import CoreData

let appDelegate = UIApplication.shared.delegate as! AppDelegate

class ChatRoomsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var result: [Room]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.getObjects()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - TableViewDelegate, TableViewDataSource
extension ChatRoomsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard self.result != nil || self.result?.count != 0 else {
            return 0
        }
        return self.result!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatRoomsTableViewCell") as! ChatRoomsTableViewCell
        
        cell.nameLabel.text = self.result![indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "BubbleChatViewController") as! BubbleChatViewController
        
        let cell = tableView.cellForRow(at: indexPath) as! ChatRoomsTableViewCell
        vc.title = cell.nameLabel.text
        
        let roomObject: NSManagedObject = self.result![indexPath.row]
//        vc.roomObj2 = self.result![indexPath.row]
        vc.roomObj = roomObject
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            let roomObject: NSManagedObject = self.result![indexPath.row]
            
            appDelegate.managedObjectContext?.delete(roomObject)
            
            self.saveObject(object: roomObject)
        }
    }
}


// MARK: - Actions
extension ChatRoomsViewController {
    @IBAction func actionAddRoom(_ sender: AnyObject) {
        let roomDescription: NSEntityDescription = NSEntityDescription.entity(forEntityName: "Room", in: appDelegate.managedObjectContext!)!
        
        /*
        // 직접 접근
        let newRoom: NSManagedObject = NSManagedObject.init(entity: roomDescription, insertInto: appDelegate.managedObjectContext)
        newRoom.setValue("\(self.result!.count + 1)번 방", forKey: "name")
        self.saveObject(object: newRoom)
        */
        
        // ORM으로 접근
        let roomRecord = Room(entity: roomDescription, insertInto: appDelegate.managedObjectContext)
        roomRecord.name = "\(self.result!.count + 1)번 방"
        self.saveObject(object: roomRecord)
    }
}

// MARK: - Funtions
extension ChatRoomsViewController {
    func saveObject(object: NSManagedObject) {
        do {
            try object.managedObjectContext?.save()
            self.getObjects()
            
        } catch {
            print("Error with request: \(error)")
        }
    }
    
    func getObjects() {
        do {
            //go get the results
            self.result = try appDelegate.managedObjectContext!.fetch(Room.fetchRequest())
            self.tableView.reloadData()
            
            /*
             //I like to check the size of the returned results!
             print ("num of results = \(searchResults.count)")
             
             //You need to convert to NSManagedObject to use 'for' loops
             for trans in searchResults as [NSManagedObject] {
             //get the Key Value pairs (although there may be a better way to do that...
             print("\(trans.value(forKey: "message"))")
             }
             */
        } catch {
            print("Error with request: \(error)")
        }
    }
}

class ChatRoomsTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
}
