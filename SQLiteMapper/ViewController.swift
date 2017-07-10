//
//  ViewController.swift
//  SQLiteMapper
//
//  Created by Gustavo Leguizamon on 7/10/17.
//  Copyright © 2017 Agencia Lamoderna. All rights reserved.
//

import UIKit
import SQLite
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = "http://nightapp.dev.agenciamoderna.com.py/mobile/json/master.json"
        
        let header: HTTPHeaders = ["Authorization": "Basic ZGV2ZWxvcGVyOl43aEo/dVhmbTNXP1RjTUE="]
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: header)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    
                    do {
                        let path = NSSearchPathForDirectoriesInDomains(
                            .documentDirectory, .userDomainMask, true
                            ).first!
                        
                        let db = try Connection("\(path)/appNight.sqlite3")
                        
                        // Procedemos a la lectura del json
                        for (key, subjson) in json {
                            // Creamos una tabla con cada key del json
                            print("CREATE TABLE: \(key)")
                            
                            if let array = subjson.arrayObject as? [[String: AnyObject]] {
                                // En caso de que este key tenga un array procedemos a la lectura del primer elemento
                                if let data = array.first {
                                    // Obtenemos todos los keys del array
                                    let keys = Array(data.keys)
                                    if keys.isEmpty == false {
                                        // Recorremos el array de keys para crear las columnas de la tabla
                                        keys.forEach({ key in
                                            print("create field: \(key)")
                                            let field = Expression<Any>(key, [])
                                            print(field)
                                        })
                                    }
                                }
                            } else if let dictionary = subjson.dictionaryObject {
                                print(dictionary)
                            } else {
                                print("no sape")
                            }
                        }
                        
//                        let id = Expression<Int64>("id")
//                        let email = Expression<String>("email")
//                        let name = Expression<String?>("name")
//
//                        let users = Table("users")
//
//                        try db.run(users.create { t in     // CREATE TABLE "users" (
//                            t.column(id, primaryKey: true) //     "id" INTEGER PRIMARY KEY NOT NULL,
//                            t.column(email, unique: true)  //     "email" TEXT UNIQUE NOT NULL,
//                            t.column(name)                 //     "name" TEXT
//                        })
                        
                    } catch {
                        print("error")
                    }
                case .failure(let error):
                    print(error)
                }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

