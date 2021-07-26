//
//  DatabaseHelper.swift
//  ReminderApp
//
//  Created by Sora Oya on 2021/06/11.
//

import Foundation
import GRDB

class DatabaseHelper {
    
    private struct Const {
        static let dbFileName = NSTemporaryDirectory() + "database.db"
    }
    
    init() {
        self.creatDatabase()
    }
    
    func inDatabase(_ block: (Database) throws -> Void) -> Bool {
        do {
            let dbQueue = try DatabaseQueue(path: Const.dbFileName)
            try dbQueue.inDatabase(block)
        } catch _ {
            
            return false
        }
        return true
    }
    
    private func creatDatabase() {
        if FileManager.default.fileExists(atPath: Const.dbFileName) {
            return
        }
        let result = inDatabase {(db) in
            try Housework.create(db)
        }
        
        if !result {
            do {try FileManager.default.removeItem(atPath: Const.dbFileName)} catch {}
        }
    }
}
