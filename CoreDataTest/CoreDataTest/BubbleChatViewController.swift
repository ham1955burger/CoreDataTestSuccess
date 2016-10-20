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
        
        if !(self.result?[indexPath.row].isReceived)! {
            // 내가 보낸 메시지 일 경우
            let alert = UIAlertController(title: nil, message: "수정 하시겠습니까?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "예", style: .default, handler: { (action) in
                self.updateObject(object: self.result![indexPath.row])
            }))
            alert.addAction(UIAlertAction(title: "아니요", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            let chatObject: NSManagedObject = self.result![indexPath.row]
            
            appDelegate.managedObjectContext?.delete(chatObject)
            self.saveObject()
        }
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
    
    @IBAction func actionDeleteAllMessage(_ sender: AnyObject) {
        // 전체 삭제
        for chatObject: NSManagedObject in self.result! {
            appDelegate.managedObjectContext?.delete(chatObject)
        }
        
        self.saveObject()
    }
}

// MARK: - Functions

extension BubbleChatViewController {
    func save(date: Date, isReceived: Bool, message: String, sender: Int) {
        let chatDescription: NSEntityDescription = NSEntityDescription.entity(forEntityName: "Chat", in: appDelegate.managedObjectContext!)!
        
        /*
        // 직접 접근
        let newChat: NSManagedObject = NSManagedObject.init(entity: chatDescription, insertInto: appDelegate.managedObjectContext)
        newChat.setValue(date, forKey: "date")
        newChat.setValue(isReceived, forKey: "isReceived")
        newChat.setValue(message, forKey: "message")
        newChat.setValue(sender, forKey: "sender")
        newChat.setValue(self.roomObj, forKey: "room")
        */
        
        // ORM으로 접근
        let chatRecord = Chat(entity: chatDescription, insertInto: appDelegate.managedObjectContext)
        
        chatRecord.date = date as NSDate?
        chatRecord.isReceived = isReceived
        chatRecord.message = message
        chatRecord.sender = Int16(sender)
        chatRecord.room = self.roomObj as! Room?
        
        self.saveObject()
        
//        self.roomObj!.setValue(NSSet.init(object: newChat), forKey: "chat")
//        self.roomObj!.setValue(newChat, forKey: "chat")
    }
    
    func saveObject() {
        do {
            try appDelegate.managedObjectContext?.save()
            self.getObjects()
            
        } catch {
            print("Error with request: \(error)")
        }
    }
    
    func getObjects() {
        do {
            //go get the results
            let fetchRequest: NSFetchRequest<Chat> = Chat.fetchRequest()
            
            // SELECT * FROM Chat WHERE room = "self.roomObj"
            // 소문자 주의!!!!!!!!!
            let predicate = NSPredicate(format: "room == %@", self.roomObj!)
            fetchRequest.predicate = predicate
            
            self.result = try appDelegate.managedObjectContext!.fetch(fetchRequest)
            
            self.tableView.reloadData()
        } catch {
            print("Error with request: \(error)")
        }
    }
    
    func updateObject(object: NSManagedObject) {
        object.setValue("보내기 수정 테스트", forKey: "message")
        self.saveObject()
    }
}

class TestTableViewCell: UITableViewCell {
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
}
