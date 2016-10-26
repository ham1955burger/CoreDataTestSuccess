//
//  BubbleChatViewController.swift
//  CoreDataTest
//
//  Created by ouniwang on 10/17/16.
//  Copyright © 2016 ham. All rights reserved.
//

import UIKit
import CoreData
import Chatto
import ChattoAdditions

class BubbleChatViewController: BaseChatViewController {
    var chatInputPresenter: BasicChatInputBarPresenter!
    
    // For Chatto
    var messageSender: FakeMessageSender!
    var dataSource: FakeDataSource! {
        didSet {
            self.chatDataSource = self.dataSource
            self.chatDataSourceDidUpdate(self.dataSource)
        }
    }
    
    lazy private var baseMessageHandler: BaseMessageHandler = {
        return BaseMessageHandler(messageSender: self.messageSender)
    }()
    // ---
    
    var roomObj: Room?
    var result: [Chat]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard roomObj != nil else {
            return
        }
        let image = UIImage(named: "bubble-incoming-tail-border", in: Bundle(for: DemoChatViewController.self), compatibleWith: nil)?.bma_tintWithColor(.blue)
        super.chatItemsDecorator = ChatItemsDemoDecorator()
        let addIncomingMessageButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(BubbleChatViewController.addRandomIncomingMessage))
        self.navigationItem.rightBarButtonItem = addIncomingMessageButton
        
        self.getObjects()
    }
    
    // MARK: Functions for Chatto
    
    @objc
    private func addRandomIncomingMessage() {
        // 받기
        let alert = UIAlertController(title: nil, message: "이미지를 첨부 test?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "예", style: .default, handler: { (action) in
            self.save(date: Date(), isReceived: true, message: "", sender: 2, image: UIImage(named: "apple"))
        }))
        alert.addAction(UIAlertAction(title: "아니요", style: .cancel, handler: { (action) in
            self.save(date: Date(), isReceived: true, message: "미워 미워 미워!!", sender: 2)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    override func createChatInputView() -> UIView {
        let chatInputView = ChatInputBar.loadNib()
        var appearance = ChatInputBarAppearance()
        appearance.sendButtonAppearance.title = NSLocalizedString("Send", comment: "")
        appearance.textInputAppearance.placeholderText = NSLocalizedString("Type a message", comment: "")
        self.chatInputPresenter = BasicChatInputBarPresenter(chatInputBar: chatInputView, chatInputItems: self.createChatInputItems(), chatInputBarAppearance: appearance)
        chatInputView.maxCharactersCount = 1000
        return chatInputView
    }
    
    override func createPresenterBuilders() -> [ChatItemType: [ChatItemPresenterBuilderProtocol]] {
        
        let textMessagePresenter = TextMessagePresenterBuilder(
            viewModelBuilder: DemoTextMessageViewModelBuilder(),
            interactionHandler: DemoTextMessageHandler(baseHandler: self.baseMessageHandler)
        )
        textMessagePresenter.baseMessageStyle = BaseMessageCollectionViewCellAvatarStyle()
        
        let photoMessagePresenter = PhotoMessagePresenterBuilder(
            viewModelBuilder: DemoPhotoMessageViewModelBuilder(),
            interactionHandler: DemoPhotoMessageHandler(baseHandler: self.baseMessageHandler)
        )
        photoMessagePresenter.baseCellStyle = BaseMessageCollectionViewCellAvatarStyle()
        
        return [
            DemoTextMessageModel.chatItemType: [
                textMessagePresenter
            ],
            DemoPhotoMessageModel.chatItemType: [
                photoMessagePresenter
            ],
            SendingStatusModel.chatItemType: [SendingStatusPresenterBuilder()],
            TimeSeparatorModel.chatItemType: [TimeSeparatorPresenterBuilder()]
        ]
    }
    
    func createChatInputItems() -> [ChatInputItemProtocol] {
        var items = [ChatInputItemProtocol]()
        items.append(self.createTextInputItem())
        items.append(self.createPhotoInputItem())
        return items
    }
    
    private func createTextInputItem() -> TextChatInputItem {
        let item = TextChatInputItem()
        item.textInputHandler = { [weak self] text in
//            self?.dataSource.addTextMessage(text)
            self?.save(date: Date(), isReceived: false, message: text, sender: 1)
        }
        return item
    }
    
    private func createPhotoInputItem() -> PhotosChatInputItem {
        let item = PhotosChatInputItem(presentingController: self)
        item.photoInputHandler = { [weak self] image in
            //            self?.dataSource.addPhotoMessage(image)
            self?.save(date: Date(), isReceived: false, message: "", sender: 1, image: image)
        }
        return item
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
        
        if let image = self.result?[indexPath.row].image {
            // 이미지가 있는 message일 경우
            
            cell.messageImage.image = UIImage(data: image as Data)
        }
        
        cell.messageLabel.text = self.result?[indexPath.row].message
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let currentDate: String = dateFormatter.string(from: (self.result?[indexPath.row].sendDate)! as Date)
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


// MARK: - Functions for Chatto

extension BubbleChatViewController {
    
}


// MARK: - Functions for Core Data

extension BubbleChatViewController {
    func save(date: Date, isReceived: Bool, message: String, sender: Int, image: UIImage? = nil) {
        // get Chat entity
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
        
        chatRecord.sendDate = date as NSDate?
        chatRecord.isReceived = isReceived
        chatRecord.message = message
        chatRecord.sender = Int16(sender)
        // Chat과 1:N 관계를 가질 roomObj
        chatRecord.room = self.roomObj
        
        // room object의 udpateDate를 변경(for room sort)
        self.roomObj?.updateDate = chatRecord.sendDate

        if image != nil {
            // image message
            chatRecord.image = NSData(data: UIImagePNGRepresentation(image!)!)
            self.dataSource.addPhotoMessage(chatRecord)
        } else {
            // test message
            self.dataSource.addTextMessage(chatRecord)
        }
        
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
            // get Chat records
            let fetchRequest: NSFetchRequest<Chat> = Chat.fetchRequest()
            
            // SELECT * FROM Chat WHERE room = "self.roomObj"
            // 소문자 주의!!!!!!!!!
            // 해당 roomObj를 ForeignKey로 가지는 Chat들만 조회
            let predicate = NSPredicate(format: "room == %@", self.roomObj!)
            fetchRequest.predicate = predicate
            
            self.result = try appDelegate.managedObjectContext!.fetch(fetchRequest)
            
            /*
             print("-----")
             for record in self.result! as [Chat] {
             print(record.message)
             }
             print("-----")
             */
        } catch {
            print("Error with request: \(error)")
        }
    }
    
    func updateObject(object: Chat) {
        //        object.setValue("보내기 수정 테스트", forKey: "message")
        object.message = "보내기 수정 테스트"
        self.saveObject()
    }
}
