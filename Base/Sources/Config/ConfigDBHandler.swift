//
//  ConfigDBHandler.swift
//  Base
//
//  Created by 王青海 on 16/6/9.
//  Copyright © 2016年 王青海. All rights reserved.
//

import UIKit


internal struct ConfigDBSQL {
    
    enum Table: String {
        case Config = "Config"
        
        //key - key - value
        func createTableSQL() -> String {
            switch self {
            case .Config:
                return "CREATE TABLE IF NOT EXISTS \(Table.Config.rawValue) (service text NOT NULL, item text NOT NULL, content blob, primary key (service, item))"
//            case .allContacts:
//                return "CREATE TABLE IF NOT EXISTS \(Table.allContacts.rawValue) (ID text UNIQUE,Name text,Nick text,Avatar text, Department text,DepartID text, Email text,Postion text,Telphone text,Sex integer,updated real,pyname text,signature text)"
//            case .departments:
//                return "CREATE TABLE IF NOT EXISTS \(Table.departments.rawValue) (ID text UNIQUE,parentID text,title text, description text,leader text, status integer,count integer)"
//            case .groups:
//                return "CREATE TABLE IF NOT EXISTS \(Table.groups.rawValue) (ID text UNIQUE,Avatar text, GroupType integer, Name text,CreatID text,Users Text,LastMessage Text,updated real,isshield integer,version integer)"
//            case .session:
//                return "CREATE TABLE IF NOT EXISTS \(Table.session.rawValue) (ID text UNIQUE,avatar text, type integer, name text,updated real,isshield integer,users Text , unreadCount integer, lasMsg text, lastMsgId integer)"
            }
        }
    }
}

internal class ConfigDBHandler: NSObject {

}
