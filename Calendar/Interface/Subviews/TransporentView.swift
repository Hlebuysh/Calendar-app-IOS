//
//  TransporentView.swift
//  Calendar
//
//  Created by User on 22.11.2022.
//

import UIKit

class DropDown: UIView{
    private var tableView: UITableView!
    private var tapGesture: UITapGestureRecognizer!
    private var choiceList: [String] = []
    private var selection: (String) -> Void

    init(superVC: UIViewController, selection: @escaping (String) -> Void) {
        self.selection = selection
        super.init(frame: UIApplication.shared.keyWindow?.frame ?? superVC.view.frame)
        self.selection = selection
        self.tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.closeTransporentView(_:)))
        
        superVC.view.addSubview(self)
        self.backgroundColor = UIColor.black
        
        
        self.addGestureRecognizer(tapGesture)
        self.alpha = 0
        
        self.tableView = UITableView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.isScrollEnabled = true
        self.tableView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        superVC.view.addSubview(self.tableView)
        self.tableView.layer.cornerRadius = 5
        
        
        
    }
    
    required init?(coder: NSCoder) {
        self.selection = {str in
            return
        }
        super.init(coder: coder)
        self.tableView = coder.decodeObject(forKey: "tableView") as? UITableView
        self.tapGesture = coder.decodeObject(forKey: "tapGesture") as? UITapGestureRecognizer
        self.choiceList = coder.decodeObject(forKey: "choiceList") as! [String]
        self.selection = coder.decodeObject(forKey: "selection") as! (String) -> Void
    }
    override func encode(with coder: NSCoder) {
        coder.encode(self.tableView, forKey: "tableView")
        coder.encode(self.tapGesture, forKey: "tapGesture")
        coder.encode(self.choiceList, forKey: "choiceList")
        coder.encode(self.selection, forKey: "selection")
    }
}

extension DropDown{
    func updateData(data: [String]){
        self.choiceList = data

    }
}

extension DropDown{
    func updateDataWithReload(data: [String], x: Int, y: Int, width: Int){
        self.choiceList = data
        self.tableView.reloadData()
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.tableView.frame=CGRect(x: x, y: y+5, width: width, height: self.choiceList.count * 40 > 300 ? 300 : self.choiceList.count * 40)

        }, completion: nil)
    }
}

extension DropDown: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.choiceList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = self.choiceList[indexPath.row]
        return cell
    }
    
}
extension DropDown: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        closeTransporentView()
        selection(choiceList[indexPath.row])
    }
}

extension DropDown{
    func openTransporentView(x: Int, y: Int, width: Int){
        
        self.tableView.reloadData()
        self.tableView.frame = CGRect(x: x, y: y+5, width: width, height: 0)
        
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.alpha = 0.5

            self.tableView.frame=CGRect(x: x, y: y+5, width: width, height: self.choiceList.count * 40 > 300 ? 300 : self.choiceList.count * 40)

        }, completion: nil)
    }
    @objc func closeTransporentView(_ sender: UITapGestureRecognizer? = nil){
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.alpha = 0
            

            self.tableView.frame=CGRect(x: self.tableView.frame.origin.x, y: self.tableView.frame.origin.y, width: self.tableView.frame.size.width, height: 0)

        }, completion: nil)
    }
}
    
