

import UIKit
import SideMenu

class MenuViewController: UIViewController {
    
    @IBOutlet weak private var backButton: UIBarButtonItem!
    @IBOutlet weak private var menuTable: UITableView!
    
    private struct Cell {
        var image:String
        var title:String
        var segue:String
        init(image: String, title: String, segue: String) {
            self.image = image
            self.title = title
            self.segue = segue
        }
    }
    
    private let tableCells:[Cell] = [Cell(image: "person.fill", title: "Авторизация", segue:                               "Authorization"),
                             Cell(image: "calendar", title: "Календарь", segue: "Calendar"),
                             Cell(image: "plus", title: "Добавить", segue: "Addition"),
                             Cell(image: "gearshape.fill", title: "Настройки", segue: "Settings")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction private func tapBackButton(_ sender: Any) {
        dismiss(animated: true)
    }
}

extension MenuViewController: UITableViewDataSource, UITableViewDelegate{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell") as! MenuTableViewCell
        cell.menuTableCellLable.text = tableCells[indexPath.row].title
        cell.menuTableCellImage.image = UIImage(systemName: tableCells[indexPath.row].image)
        
//        let backgroundView = UIView()
//        backgroundView.backgroundColor = UIColor(red: 48.0/255, green: 141.0/255, blue: 127.0/255, alpha: 1.0)
//        cell.selectedBackgroundView = backgroundView
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "FromMenuTo"+tableCells[indexPath.row].segue, sender: self)
    }
}
