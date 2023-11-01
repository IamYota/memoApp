//
//  MemoDetailViewController.swift
//  MyColorMemoApp
//
//  Created by Yota Yamashita on 2023/10/07.
//

//ココでメモデータを画面に表示させる

import UIKit
import RealmSwift //Realmのものを使うためのimport

class MemoDetailViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    //ここでプロパティを追加
//    var text: String = ""
//    var recordDate: Date = Date()↓に書き換え
    var memoData = MemoDataModel()
    
    //ココで使っているのはコンピューティッドプロパティ
    var dateFormat: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy年MM月dd日"
        return dateFormatter
    }
    
    //viewDidLoad→画面表示される際に呼び出されるメソッド
    override func viewDidLoad() {
        super.viewDidLoad()
        displayData()
        setDoneButton()
        textView.delegate = self //UITextViewDelegateを準拠させた際→自身のクラスを代入する。文字列が書き換わるたびに文字列が保存される
    }
    
    //メモデータを渡すためのメソッド
    func configure(memo: MemoDataModel) {
        memoData.text = memo.text
        memoData.recordDate = memo.recordDate
    }
    
    //ココで表示させたいものを書いていく
    func displayData() {
        textView.text = memoData.text
        navigationItem.title = dateFormat.string(from: memoData.recordDate)
    }
    
    
    //現在表示されているキーボードを閉じる
    @objc func tapDoneButton() {
        view.endEditing(true)
    }
    
    
    //キーボードに閉じるボタンを追加するためのメソッド
    func setDoneButton() {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        //ここのUIToolbarはキーボードの上にボタンを配置するためのツールバークラス
        //インスタンス化するときに幅や高さを設定する
        
        //キーボードを閉じるためのボタンの作成
        let commitButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(tapDoneButton))
        
        //toolBarに以上２つを代入。複数のボタンを代入できるので配列にしておいている
        toolBar.items = [commitButton]
        
        //UITextbarクラスのinputAccessoryViewに代入
        textView.inputAccessoryView = toolBar
    }
    
    //ココでデータを保存するためのメソッドを追加。Realmをimport完了後
    func saveData(with text: String) {
        let realm = try! Realm()
        try! realm.write {
            memoData.text = text
            memoData.recordDate = Date()
            realm.add(memoData)
        }
        print("text: \(memoData.text), recordDate: \(memoData.recordDate)")
    }
}

//UITextViewの文字列が変更されるたびにデータを上書き
//UITableViewの文字列が変更される際に処理をしたい場合→UITextViewDelegateというprotocolを使用する↓
extension MemoDetailViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) { //ココのtextViewDidChangeが文字列変更時に実行されるもの
        
        //以下でデータ保存のメソッドを実行させる
        let updatedText = textView.text ?? ""
        saveData(with: updatedText)
    }
}
