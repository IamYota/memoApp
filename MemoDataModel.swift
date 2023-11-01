//
//  MemoDataModel.swift
//  MyColorMemoApp
//
//  Created by Yota Yamashita on 2023/10/05.
//

//メモのデータ構造を表現するためのもの→structを使用

import Foundation
import RealmSwift

class MemoDataModel: Object {
    @objc dynamic var id: String = UUID().uuidString //データを一貫に識別するための識別子
    @objc dynamic var text: String = ""
    @objc dynamic var recordDate: Date = Date()
}
