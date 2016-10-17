//
//  BubbleChatViewController.swift
//  CoreDataTest
//
//  Created by ouniwang on 10/17/16.
//  Copyright © 2016 ham. All rights reserved.
//

import UIKit
import CoreData

class BubbleChatViewController: UIViewController {
    
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var roomObj: NSManagedObject?
//    var roomObj2: Room?
    
    var result: [Chat]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard roomObj != nil else {
            return
        }
        
        self.getObjects()
    }
}

extension BubbleChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard self.result!.count != 0 else {
//            tableView.isHidden = true
//            self.emptyLabel.isHidden = false
            return 0
        }
        
//        tableView.isHidden = false
//        self.emptyLabel.isHidden = true
        
        return self.result!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TestTableViewCell") as! TestTableViewCell
        
        cell.messageLabel.text = self.result?[indexPath.row].message
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let currentDate: String = dateFormatter.string(from: (self.result?[indexPath.row].date)! as Date)
        cell.dateLabel.text = currentDate
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
//        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//        /*
//         if !(self.result?[indexPath.row].isReceived)! {
//         alert.addAction(UIAlertAction(title: "수정 하기", style: .default, handler: { (action) in
//         self.modifyObj(objectIndex: indexPath.row)
//         }))
//         }
//         */
//        
//        alert.addAction(UIAlertAction(title: "삭제 하기", style: .default, handler: { (action) in
//            self.deleteObj(objectIndex: indexPath.row)
//            
//        }))
//        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
//        
//        self.present(alert, animated: true, completion: nil)
    }
}


// MARK: - Actions

extension BubbleChatViewController {
    @IBAction func actionReceive(_ sender: AnyObject) {
        // 받기
        self.save(date: Date(), isReceived: true, message: "받기 테스트", sender: 2)
//        self.storeTranscription(date: Date(), isReceived: true, message: "받기 테스트", room: 1, sender: 2)
    }
    
    @IBAction func actionSend(_ sender: AnyObject) {
        // 보내기
        self.save(date: Date(), isReceived: false, message: "보내기 테스트", sender: 1)
//        self.storeTranscription(date: Date(), isReceived: false, message: "보내기 테스트", room: 1, sender: 1)
    }
    
    @IBAction func actionSort(_ sender: AnyObject) {
        // 정렬
//        self.sortState = !self.sortState
//        self.getTranscriptions()
    }
    
    @IBAction func actionSearch(_ sender: AnyObject) {
        // 검색
    }
    
    @IBAction func deleteAllObject(_ sender: AnyObject) {
        // 전체 삭제
//        appDelegate.deleteAllData(entity: "BubbleTest") { (error) in
//            if error == nil {
//                self.getTranscriptions()
//            } else {
//                print("\(error)")
//            }
//        }
        
    }
}

// MARK: - Functions

extension BubbleChatViewController {
    func save(date: Date, isReceived: Bool, message: String, sender: Int) {
        let entityDescription: NSEntityDescription = NSEntityDescription.entity(forEntityName: "Chat", in: appDelegate.managedObjectContext!)!
        let newChat: NSManagedObject = NSManagedObject.init(entity: entityDescription, insertInto: appDelegate.managedObjectContext)
        
        newChat.setValue(date, forKey: "date")
        newChat.setValue(isReceived, forKey: "isReceived")
        newChat.setValue(message, forKey: "message")
        newChat.setValue(sender, forKey: "sender")
        newChat.setValue(self.roomObj, forKey: "room")
        
        self.saveObject(object: newChat)
        
//        self.roomObj!.setValue(NSSet.init(object: newChat), forKey: "chat")
//        self.roomObj!.setValue(newChat, forKey: "chat")
    }
    
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
            let fetchRequest: NSFetchRequest<Chat> = Chat.fetchRequest()
            let predicate = NSPredicate(format: "room == %@", self.roomObj!)
            fetchRequest.predicate = predicate
            
            self.result = try appDelegate.managedObjectContext!.fetch(fetchRequest)
            
            self.tableView.reloadData()
        } catch {
            print("Error with request: \(error)")
        }
    }
    
    func deleteObj(objectIndex: Int) {
//        let context = appDelegate.managedObjectContext
//        
//        context?.delete(self.result![objectIndex])
//        appDelegate.saveContext { (error) in
//            if error == nil {
//                self.getTranscriptions()
//            } else {
//                print(error)
//            }
//        }
//        self.getTranscriptions()
    }
    
    func modifyObj(objectIndex: Int) {
//        let obj = self.result?[objectIndex]
//        
//        obj?.setValue("보내기 수정 테스트", forKey: "message")
//        
//        appDelegate.saveContext { (error) in
//            if error == nil {
//                self.getTranscriptions()
//            } else {
//                print(error)
//            }
//        }
//        self.getTranscriptions()
    }
}

class TestTableViewCell: UITableViewCell {
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
}
