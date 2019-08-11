//
//  ViewController.swift
//  Flash Chat
//
//  Created by Angela Yu on 29/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import Firebase
import ChameleonFramework


class ChatViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    
    // Declare instance variables here
    var msgArray: [Message] = [Message]()//bind array to get the data from firebase arrya of msg objects

    
    // We've pre-linked the IBOutlets
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet var messageTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageTableView.dataSource = self
        messageTableView.delegate = self
        messageTextfield.delegate = self
//
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
//        messageTableView.addGestureRecognizer(tapGesture)
//
        
        
        //TODO: Set yourself as the delegate of the text field here:
        func tableViewTapped(){
            messageTextfield.endEditing(true)
        }
        
        //TODO: Set the tapGesture here:
        

        //TODO: Register your MessageCell.xib file here:
        
      messageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
        configureTableView()
///////////todo-very importent
            retrieveMsgs()
        messageTableView.separatorStyle = .none

    }

    ///////////////////////////////////////////
    
    //MARK: - TableView DataSource Methods
    
    
    //TODO: Declare cellForRowAtIndexPath here:
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
       
        cell.messageBody!.text = msgArray[indexPath.row].messges
        cell.senderUsername.text = msgArray[indexPath.row].sender
        cell.avatarImageView.image = UIImage(named: "egg")
        
        if cell.senderUsername.text == Auth.auth().currentUser?.email as String!{
            cell.avatarImageView.backgroundColor = UIColor.flatMint()
            cell.messageBackground.backgroundColor = UIColor.flatSkyBlue()
            
        }else{
            cell.avatarImageView.backgroundColor = UIColor.flatWatermelon()
            cell.messageBackground.backgroundColor = UIColor.flatGray()
        }
        
       // let msgArray = ["hivxcvxcvxcv","mxvxcvxcvxcve","mexvxcvcvxcve"]
      //  cell.myView.backgroundColor = self.colors[indexPath.row]
     //   cell.messageBody?.text = msgArray[indexPath.row]

        
       // cell.messageBody!.text = "mkkmlkmkmkmkm"
        return cell
    }
    
    
    //TODO: Declare numberOfRowsInSection here:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return msgArray.count
        
    }
    
    //selctord-sometime we need to call an object we dont know about until the func is calling tuntime so we use selector-target-current vc and the action takes a selecotr-just difftent way to call a method
    //TODO: Declare tableViewTapped here:
    
    
    
    //TODO: Declare configureTableView here:
    func configureTableView(){
        messageTableView.rowHeight = UITableView.automaticDimension
        messageTableView.estimatedRowHeight = 120.0
    }//do configuration by nessray- size of the s,s
    
    
    
    ///////////////////////////////////////////
    
    //MARK:- TextField Delegate Methods
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            //coulsre
            //trailing cloure
            //self- method in our own app
            self.heightConstraint.constant = 308
            self.view.layoutIfNeeded()//if constain has change-redraw all again
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        UIView.animate(withDuration: 0.5) {
            self.heightConstraint.constant = 50
            self.view.layoutIfNeeded()
        }
    }
    
    //TODO: Declare textFieldDidBeginEditing here:
    
    
    
    
    //TODO: Declare textFieldDidEndEditing here:
    

    
    ///////////////////////////////////////////
    
    
    //MARK: - Send & Recieve from Firebase
    
    
    
    
    
    @IBAction func sendPressed(_ sender: AnyObject) {
        //send msg to firebase
        messageTextfield.endEditing(true)
      //  dispable tf and send btn-time cinsuming tap btn
        
        messageTextfield.isEnabled = false
        sendButton.isEnabled = false
        
        //db for
        
        let messagesDB = Database.database().reference().child("Messages")
        //save user msg as dic
        
        let messageDic = ["Sender":Auth.auth().currentUser?.email,
                          "MessageBody":messageTextfield.text]
        
        messagesDB.childByAutoId().setValue(messageDic){
            (error, reference) in
            
            if error != nil{
                print(error)
            }else{
                print("message saved sussfully")
                self.messageTextfield.isEnabled = true
                self.sendButton.isEnabled = true
                self.messageTextfield.text = ""
                
            }
            
        }
        
        
        //create a custom random key for messages
        
        
        //TODO: Send the message to Firebase and save it in our database
        
        
    }
    
    //TODO: Create the retrieveMessages method here:
    //p- ptoprtires
    //m= methods
    
    func retrieveMsgs(){
        let msgDB = Database.database().reference().child("Messages")//db mane-messages
        //onserve to child added and not constanlly retrieveing results
        
        msgDB.observe(.childAdded) { (snapshot) in
            let snapshopValue = snapshot.value as? Dictionary<String,String> //contian all values that instad DB
            let text = snapshopValue?["MessageBody"]!
            let sender = snapshopValue!["Sender"]!
            
            let message = Message()
            message.messges = text ?? ""
            message.sender = sender
            
            self.msgArray.append(message)
            self.configureTableView()
            self.messageTableView.reloadData() //puting a new data so we need to reformat the table view
        }
        //ANY -we must cast into a none dv
        //represnt the
    }
    

    
    
    
    @IBAction func logOutPressed(_ sender: AnyObject) {
        
        //TODO: Log out the user and send them back to WelcomeViewController
        do{
           try Auth.auth().signOut() //this is the line that potentilly will have a prblem
            
        }
        catch{
            print(error)
            
        }
        guard (navigationController?.popToRootViewController(animated: true)) != nil
        else{
            print("no VIEWcontriller to pop off")
            return
            }
        
            
        }
        
    }
    



