//
//  TodoItem.swift
//  Todo
//
//  Created by Sakai Aoi on 2021/02/16.
//
import RealmSwift

class TodoItem : Object {
    @objc dynamic var id: ObjectId = ObjectId.generate()
    @objc dynamic var order: Int = 0
    @objc dynamic var title: String = ""
    @objc dynamic var deadline: Date!
    
    convenience init(title: String, deadline: Date) {
        self.init()
        self.title = title
        self.deadline = deadline
    }
    
}
