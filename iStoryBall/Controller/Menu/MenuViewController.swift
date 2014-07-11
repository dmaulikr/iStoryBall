//
//  MenuViewController.swift
//  iStoryBall
//
//  Created by Jesse on 2014. 7. 9..
//  Copyright (c) 2014년 Daum communications. All rights reserved.
//

class MenuViewController : SBViewController, UITableViewDelegate, UITableViewDataSource
{
    var tableView: UITableView?
    var doc: TFHpple?
    var menus: [TFHppleElement]?
    var refinedMenu: [TFHppleElement]?
    let exceptiveMenuUrl = ["/story/pop", "/episode/hit", "/story/list"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestMenuData()
        //initView()
        //self.view.adds
        
    }
    
    func isValidMenu(url: String) -> Bool {
        var isValid = true;
        for exceptiveUrl in exceptiveMenuUrl {
            if url == exceptiveUrl {
                isValid = false
                break
            }
        }
        return isValid
    }
    
    func refineMenus(menus: [TFHppleElement]?) -> [TFHppleElement] {
        var refined = [TFHppleElement]()
        var count = menus!.count
        
        for i in 0..<count {
            var menu = menus![i]
            var url = menu.attributes["href"] as NSString
            if isValidMenu(url) {
                refined.append(menu)
            }
        }
        
        return refined
    }
    
    func requestMenuData() {
        NetClient.instance.get("/", success: {
            (html: String) in
            
            self.doc = html.htmlDocument()
            self.menus = self.refineMenus(self.doc!.itemsWithQuery(".link_menu"))
            
            println(self.menus!.count)
            println("\n")
            self.initView()
            })
    }
    
    func initView() {
        tableView = UITableView(frame: self.view.frame, style: .Grouped)
        tableView!.delegate = self
        tableView!.dataSource = self
        self.view.addSubview(tableView)
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return self.menus!.count
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let identifier = "identifier"
        var cell: UITableViewCell = UITableViewCell(style: .Default, reuseIdentifier: identifier)
        var row = indexPath.row
        var menu = self.menus![row]
        var name = menu.text()
        var link = menu.attributes["href"]
        
        if !menu.firstChild.isTextNode() {
            var textnode = menu.firstChildWithClassName("txt_menu")
            name = textnode.text()
        }
        
        cell.textLabel.text = name
        
        return cell
    }
    
}
