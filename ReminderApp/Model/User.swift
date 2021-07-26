//
//  User.swift
//  ReminderApp
//
//  Created by Sora Oya on 2021/06/11.
//

import Foundation
import GRDB

class User: Record {
    
    let dbQueue = try? DatabaseQueue(path: "/path/to/database.sqlite")
    
    override static var databaseTableName: String {
           return "userList"
       }

    static func create(_ db: Database) throws {
           try db.create(table: databaseTableName, body: { (t: TableDefinition) in
               t.column("id", .integer).primaryKey(onConflict: .replace, autoincrement: true)
               t.column("name", .text).notNull().unique() // 重複を許さないのなら.unique()をつける
           })
       }
    
    var name: String?
    var id: String?
    
    init(dic: [String: Any]) {
        super.init()
        
        self.name = dic["name"] as? String ?? ""
        self.id = dic["id"] as? String ?? ""
    }
    
    required init(row: Row) {
        fatalError("init(row:) has not been implemented")
    }
}
