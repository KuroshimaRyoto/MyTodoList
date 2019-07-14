//
//  ViewController.swift
//  MyTodoList
//
//  Created by 黒島涼人 on 2019/07/10.
//  Copyright © 2019 kuroshima. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {
    
    //テーブルの行数を返却する
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }
    
    //テーズルの行ごとのセルを返却する
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"todoCell",for:indexPath)
        //Storyboardで指定したtodoCell識別子を利用して再利用可能なセルを取得する
        let todoTitle = todoList[indexPath.row]
        //セルのラベルにTodoのタイトルをセット
        cell.textLabel?.text = todoTitle
        return cell
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    //Todoを格納する配列
    var todoList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func tapAddButton(_ sender: Any) {
    //ボタンを押した時のアクション、ダイアログの表示
        let alertController = UIAlertController(title:"Todo追加",message:"Todoを入力して下さい",preferredStyle:UIAlertController.Style.alert)
    //入力するテキストフィールドの作成
        alertController.addTextField(configurationHandler:nil)
    //OKボタンを作成
        let okAction = UIAlertAction(title:"OK",style: UIAlertController.Style.default){
            (action: UIAlertAction) in
            //OKボタンが押された時の処理
            if let textField = alertController.textFields?.first{
                //Todoリストの配列に入力値を挿入
                self.todoList.insert(textField.text!,at:0)
                //テーブルに行を追加されたことをテーブルに通知
                self.tableView.insertRows(at:[IndexPath(row:0,section:0)],with:UITableView.RowAnimation.right)
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
