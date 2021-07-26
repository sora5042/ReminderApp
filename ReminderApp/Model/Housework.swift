//
//  Housework.swift
//  ReminderApp
//
//  Created by Sora Oya on 2021/06/10.
//

import Foundation
import GRDB

class Housework: Record, Codable {
    
    override static var databaseTableName: String {
        return "housework"
    }
    
    static func create(_ db: Database) throws {
        try db.create(table: databaseTableName, body: { (t: TableDefinition) in
            t.autoIncrementedPrimaryKey("id")
            t.column("notificationId").notNull()
            t.column("housework", .text).notNull()
            t.column("date", .text).notNull()
            t.column("createdAt", .double).notNull()
            t.column("repeatDay", .integer).notNull()
            t.column("comment", .text).notNull()
            t.column("priority", .integer).notNull()
        })
    }
    
    enum Columns {
        
        static let id = Column("id")
        static let notificationId = Column("notificationId")
        static let housework = Column("housework")
        static let date = Column("date")
        static let createdAt = Column("createdAt")
        static let repeatDay = Column("repeatDay")
        static let comment = Column("comment")
        static let priority = Column("priority")
    }
    
    var id: String?
    var notificationId: String?
    var housework: String?
    var date: String?
    var createdAt: Double?
    var repeatDay: Int?
    var comment: String?
    var priority: Int64?
    
    init(notificationId: String, housework: String, date: String, createdAt: Double, repeatDay: Int, comment: String, priority: Int) {
        super.init()
        
        self.notificationId = notificationId
        self.housework = housework
        self.date = date
        self.createdAt = createdAt
        self.repeatDay = repeatDay
        self.comment = comment
        self.priority = Int64(priority)
        
    }
    
    required init(row: Row) {
        
        self.id = row["id"]
        self.notificationId = row["notificationId"]
        self.housework = row["housework"]
        self.date = row["date"]
        self.createdAt = row["createdAt"]
        self.repeatDay = row["repeatDay"]
        self.comment = row["comment"]
        self.priority = row["priority"]
        super.init(row: row)
    }
    
    override func encode(to container: inout PersistenceContainer) {
        
        container["id"] = self.id
        container["notificationId"] = self.notificationId
        container["housework"] = self.housework
        container["date"] = self.date
        container["createdAt"] = self.createdAt
        container["repeatDay"] = self.repeatDay
        container["comment"] = self.comment
        container["priority"] = self.priority
    }
    
    override func didInsert(with rowID: Int64, for column: String?) {
        self.id = String(rowID)
    }
}
