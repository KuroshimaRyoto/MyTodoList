//
//  ViewController.swift
//  MyTodoList
//
//  Created by 黒島涼人 on 2019/07/10.
//  Copyright © 2019 kuroshima. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    //Todoを格納する配列
    var todoList = [MyTodo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let userDefaults = UserDefaults.standard
        if let storedTodoList = userDefaults.array(forKey: "todoList") as? Data{
            do{
                if let unarchiveTodoList = try NSKeyedUnarchiver.unarchivedObject(ofClasses:[NSArray.self, MyTodo.self],from:storedTodoList) as? [MyTodo]{
                    todoList.append(contentsOf: unarchiveTodoList)
                }
            }catch {
                //エラー処理なし
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //テーブルの行数を返却する
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }
    
    //テーズルの行ごとのセルを返却する
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"todoCell",for:indexPath)
        //Storyboardで指定したtodoCell識別子を利用して再利用可能なセルを取得する
        //行番号に合ったTodoの情報を取得
        let myTodo = todoList[indexPath.row]
        //セルのラベルにTodoのタイトルをセット
        cell.textLabel?.text = myTodo.todoTitle
        //セルのチェックマーク状態をセット
        if myTodo.todoDone{
            //チェックあり
            cell.accessoryType = UITableViewCell.AccessoryType.checkmark
        }else{
            //チェックなし
            cell.accessoryType = UITableViewCell.AccessoryType.none
        }
        return cell
    }
    
    //セルをタップした時の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let myTodo = todoList[indexPath.row]
        if myTodo.todoDone{
            //完了済みの場合は未完了に変更
            myTodo.todoDone = false
        }else{
            //未完了の場合は完了済みに変更
            myTodo.todoDone = true
        }
    //セルの状態を変更
        tableView.reloadRows(at:[indexPath],with:UITableView.RowAnimation.fade)
        //データ保存。Data型にシリアライズする
        do{
            let data: Data = try NSKeyedArchiver.archivedData(withRootObject: todoList, requiringSecureCoding: true)
            //UserDEfaultsに保存
            let userDefaults = UserDefaults.standard
            userDefaults.set(data,forKey: "todoList")
            userDefaults.synchronize()
        }catch{
            //エラー処理なし
        }
    }
    //セルを削除した時の処理
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    //削除処理かどうか
        if editingStyle == UITableViewCell.EditingStyle.delete{
            //Todoリストから削除
            todoList.remove(at: indexPath.row)
            //セルを削除
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
            //データ保存。Data型にシリアライズする
            do{
                let data: Data = try NSKeyedArchiver.archivedData(withRootObject: todoList, requiringSecureCoding: true)
                let userDefaults = UserDefaults.standard
                userDefaults.set(data, forKey: "todoList")
                userDefaults.synchronize()
            }catch{
                //エラー処理なし
            }
        }
    }
    
    @IBAction func tapAddButton(_ sender: Any) {
    //ボタンを押した時のアクション、ダイアログの表示
        let alertController = UIAlertController(title:"Todo追加",message:"Todoを入力して下さい",preferredStyle:UIAlertController.Style.alert)
    //入力するテキストフィールドの作成
        alertController.addTextField(configurationHandler:nil)
    //OKボタンを作成
        let okAction = UIAlertAction(title:"OK",style: UIAlertAction.Style.default){
            (action: UIAlertAction) in
            //OKボタンが押された時の処理
            if let textField = alertController.textFields?.first{
                //Todoリストの配列に入力値を挿入
                let myTodo = MyTodo()
                myTodo.todoTitle = textField.text!
                self.todoList.insert(myTodo,at:0)
                //テーブルに行を追加されたことをテーブルに通知
                self.tableView.insertRows(at:[IndexPath(row:0,section:0)],with:UITableView.RowAnimation.right)
                
                //todoの保存処理
                let userDefaults = UserDefaults.standard
                //Data型にシリアライズする
                do{
                    let data = try NSKeyedArchiver.archivedData(withRootObject: self.todoList, requiringSecureCoding: true)
                userDefaults.set(data,forKey: "todoList")
                userDefaults.synchronize()
                }catch{
                    //エラー処理なし
                }
            }
        }
        //OKボタンがタップされたときの処理
        alertController.addAction(okAction)
        //CANCELボタンがタップされたときの処理
        let cancelButton = UIAlertAction(title:"CANCEL",style:UIAlertAction.Style.cancel,handler:nil)
        //CANCELを作成
        alertController.addAction(cancelButton)
        //アラートダイアログを表示
        present(alertController,animated: true,completion:nil)
    }
}

class MyTodo:NSObject,NSSecureCoding{
    static var supportsSecureCoding: Bool{
        return true
    }
    
    //Todoのタイトル
    var todoTitle: String?
    //Todoを完了したかどうかを表すフラグ
    var todoDone: Bool = false
    //コンストラクタ
    override init(){
    }
    //NSCordingプロトコルに宣言されているえデシリアライズ処理。デコーダ処理とも言われる
    required init?(coder aDecoder: NSCoder) {
        todoTitle = aDecoder.decodeBool(forKey: "todoTitle") as? String
        todoDone = aDecoder.decodeBool(forKey: "todoDone")
    }

    //NSCordingプロトコルに宣言されているシリアライズ処理。エンコード処理とも呼ばれる
    func encode(with aCoder: NSCoder) {
        aCoder.encode(todoTitle, forKey: "todoTitle")
        aCoder.encode(todoDone, forKey: "todoDone")
    }
}
