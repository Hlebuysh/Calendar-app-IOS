
import UIKit
import Firebase

//class CellOfTable:UITableViewCell{
//
//}

class AdditionViewController: UIViewController{
    
    private struct Event{
        var creator: String
        var date: String
        var startTime: String
        var endTime: String
        var title: String
        var description: String
        var isImpotant: Bool
        var group: [String : Int]
        init(){
            self.creator = ""
            self.date = ""
            self.startTime = ""
            self.endTime = ""
            self.title = ""
            self.description = ""
            self.isImpotant = false
            self.group = [:]
        }
        init(_ creator: String, _ date: String, _ startTime: String, _ endTime: String, _ title: String, _ description: String, _ isImporant: Bool, _ group: [String : Int]){
            self.creator = creator
            self.date = date
            self.startTime = startTime
            self.endTime = endTime
            self.title = title
            self.description = description
            self.isImpotant = isImporant
            self.group = group
        }
    }
    
    @IBOutlet weak private var buttonStack: UIStackView!
    @IBOutlet weak private var yearButton: UIButton!
    @IBOutlet weak private var monthButton: UIButton!
    @IBOutlet weak private var dayButton: UIButton!
    
    @IBOutlet weak private var startTimePicker: UIPickerView!
    @IBOutlet weak private var endTimePicker: UIPickerView!
    
    @IBOutlet weak private var titleText: UITextField!
    @IBOutlet weak private var descriptionText: UITextView!
    
    @IBOutlet weak private var addUserText: UITextField!
    @IBOutlet weak private var addUserButton: UIButton!
    
    @IBOutlet weak private var importanceSwitch: UISwitch!
    
    @IBOutlet weak private var saveButton: UIButton!
    
//    private var dropDown: DropDownView?
    
    private let months = ["Январь", "Февраль", "Март", "Апрель", "Май", "Июнь", "Июль", "Август", "Сентябрь", "Октябрь", "Ноябрь", "Декабрь"]
    
    private let transporentView = UIView()
    private let tableView = UITableView()
    
    
    private var selectedButton = UIButton()
    private var isActiveButton:Bool = false
    
    private var choiceTable = [String]()
    
    private var group: [String : Int] = [:]
    private var event = Event()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        dropDown = DropDownView(superVC: self)
//        dropDown!.tableView.delegate = self
//        dropDown!.tableView.dataSource = self
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.isScrollEnabled = true
        
        event.group[Auth.auth().currentUser!.uid] = 1
        
        yearButton.setTitle(String(Calendar.current.component(.year, from: Date())), for: .normal)
        monthButton.setTitle(months[Calendar.current.component(.month, from: Date()) - 1], for: .normal)
        dayButton.setTitle(String(Calendar.current.component(.day, from: Date())), for: .normal)
        
        descriptionText.layer.borderWidth = 0.5
        descriptionText.layer.borderColor = UIColor.lightGray.cgColor
        descriptionText.layer.cornerRadius = 5
        descriptionText.text = "Описание"
        descriptionText.textColor = UIColor.lightGray
        
        startTimePicker.selectRow(Calendar.current.component(.hour, from: Date()), inComponent: 0, animated: false)
        startTimePicker.selectRow(Calendar.current.component(.minute, from: Date()), inComponent: 1, animated: false)
        
        if(Calendar.current.component(.hour, from: Date())==23){
            endTimePicker.selectRow(23, inComponent: 0, animated: false)
            endTimePicker.selectRow(59, inComponent: 1, animated: false)
        }
        else{
            endTimePicker.selectRow(Calendar.current.component(.hour, from: Date())+1, inComponent: 0, animated: false)
            endTimePicker.selectRow(Calendar.current.component(.minute, from: Date()), inComponent: 1, animated: false)
        }
        
    }
    
    @IBAction private func choiceYear(_ sender: Any) {
//        choiceTable = dropDown!.getYears()
//        selectedButton = yearButton
//        dropDown!.openTransporentView(data: choiceTable, x: Int(buttonStack.frame.origin.x) + Int(yearButton.frame.origin.x), y: Int(buttonStack.frame.origin.y) + Int(yearButton.frame.origin.y) + Int(yearButton.frame.height), width: Int(yearButton.frame.width))
        choiceTable.removeAll()
        for year in Calendar.current.component(.year, from: Date())...(Calendar.current.component(.year, from: Date())+10){
            choiceTable.append(String(year))
        }
        selectedButton = yearButton
        addTransporentView(x: Int(buttonStack.frame.origin.x) + Int(yearButton.frame.origin.x), y: Int(buttonStack.frame.origin.y) + Int(yearButton.frame.origin.y) + Int(yearButton.frame.height), width: Int(yearButton.frame.width))
    }
    @IBAction private func choiceMonth(_ sender: Any) {
//        choiceTable = dropDown!.getMonth(year: yearButton.title(for: .normal)!)
//        selectedButton = monthButton
//        dropDown!.openTransporentView(data: choiceTable, x: Int(buttonStack.frame.origin.x) + Int(monthButton.frame.origin.x), y: Int(buttonStack.frame.origin.y) + Int(monthButton.frame.origin.y) + Int(monthButton.frame.height), width: Int(monthButton.frame.width))
        choiceTable.removeAll()
        if (Int(yearButton.title(for: .normal)!) == Calendar.current.component(.year, from: Date())){
            for month in (Calendar.current.component(.month, from: Date())-1)...11{
                choiceTable.append(months[month])
            }
        }else{
            choiceTable = months
        }
        selectedButton = monthButton
        addTransporentView(x: Int(buttonStack.frame.origin.x) + Int(monthButton.frame.origin.x), y: Int(buttonStack.frame.origin.y) + Int(monthButton.frame.origin.y) + Int(monthButton.frame.height), width: Int(monthButton.frame.width))
    }
    @IBAction private func choiceDay(_ sender: Any) {
//        choiceTable = dropDown!.getDays(year: yearButton.title(for: .normal)!, month: monthButton.title(for: .normal)!)
//        selectedButton = monthButton
//        dropDown!.openTransporentView(data: choiceTable, x: Int(buttonStack.frame.origin.x) + Int(dayButton.frame.origin.x), y: Int(buttonStack.frame.origin.y) + Int(dayButton.frame.origin.y) + Int(dayButton.frame.height), width: Int(dayButton.frame.width))
        choiceTable.removeAll()
        var startDay:Int = 1
        if ((Int(yearButton.title(for: .normal)!) == Calendar.current.component(.year, from: Date()))
            && (months.firstIndex(of: monthButton.title(for: .normal)!)!) + 1 == Calendar.current.component(.month, from: Date())){
            startDay = Calendar.current.component(.day, from: Date())
        }
        for day in startDay...28{
            choiceTable.append(String(day))
        }
        let year:Int = Int(yearButton.title(for: .normal) ?? "") ?? 0
        if (monthButton.title(for: .normal) != "Февраль" || isLeap(year: year)){
            choiceTable.append(String(29))
            if (monthButton.title(for: .normal) != "Февраль"){
                choiceTable.append(String(30))
                if (monthButton.title(for: .normal) == "Январь" || monthButton.title(for: .normal) == "Март" || monthButton.title(for: .normal) == "Май" || monthButton.title(for: .normal) == "Июль" || monthButton.title(for: .normal) == "Август" || monthButton.title(for: .normal) == "Октябрь" || monthButton.title(for: .normal) == "Декабрь"){
                    choiceTable.append(String(31))
                }
            }
        }


        selectedButton = dayButton
        addTransporentView(x: Int(buttonStack.frame.origin.x) + Int(dayButton.frame.origin.x), y: Int(buttonStack.frame.origin.y) + Int(dayButton.frame.origin.y) + Int(dayButton.frame.height), width: Int(dayButton.frame.width))
    }
    
    
    @IBAction func SearchUser(_ sender: Any) {
        let ref = Database.database(url: "https://calendarappforios-default-rtdb.europe-west1.firebasedatabase.app").reference().child("users").queryOrdered(byChild: "login").queryEqual(toValue: addUserText.text).observeSingleEvent(of: .value, with: { result in
    //            if result == nil{
    //                let alert = UIAlertController(title: "Ошибка", message: "Пользователь не найден", preferredStyle: .alert)
    //                alert.addAction(UIAlertAction(title: "OK", style: .default))
    //                self.present(alert, animated: true)
    //
    //            }
    //            else{
            let data = result.value as! [String : Any]
            for (key, value) in data{
                self.event.group[key] = 0
            }
//           self.group[data.] = 0
    //            }
        })
    }
    
    
    @IBAction func AddEvent(_ sender: Any) {
        if titleText.text!.isEmpty{
            
            return
        }
        event.creator = Auth.auth().currentUser!.uid
        event.date = dayButton.title(for: .normal)!+"."
        event.date += String(months.firstIndex(of: monthButton.title(for: .normal)!)!+1)+"."
        event.date += yearButton.title(for: .normal)!
        event.startTime = String(startTimePicker.selectedRow(inComponent: 0))+":"+String(startTimePicker.selectedRow(inComponent: 1))
        event.endTime = String(endTimePicker.selectedRow(inComponent: 0))+":"+String(endTimePicker.selectedRow(inComponent: 1))
        event.title = titleText.text!
        event.description = descriptionText.text ?? ""
        event.isImpotant = importanceSwitch.isOn
        Database.database(url: "https://calendarappforios-default-rtdb.europe-west1.firebasedatabase.app").reference().child("events").childByAutoId().updateChildValues(["creator":event.creator, "date":event.date, "start_time":event.startTime, "end_time":event.endTime, "title":event.title, "description":event.description, "is_important":event.isImpotant, "group":event.group])
    }
    
    
}

extension AdditionViewController:UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (component==0){
            return 24
        }
        else{
            return 60
        }
    }
}

extension AdditionViewController:UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        return String(row)
    }
}

extension AdditionViewController:UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if descriptionText.textColor == UIColor.lightGray {
            descriptionText.text = nil
            descriptionText.textColor = UIColor.black
        }
    }
}

extension AdditionViewController{
    private func addTransporentView(x:Int, y:Int, width:Int){
        let window = UIApplication.shared.keyWindow
        transporentView.frame = window?.frame ?? self.view.frame
        self.view.addSubview(transporentView)

        tableView.frame = CGRect(x: x, y: y, width: width, height: 0)
        self.view.addSubview(tableView)
        tableView.layer.cornerRadius = 5

        isActiveButton = true

        transporentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        tableView.reloadData()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(removeTransporentView))
        transporentView.addGestureRecognizer(tapGesture)
        transporentView.alpha = 0
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transporentView.alpha = 0.5

            self.tableView.frame=CGRect(x: x, y: y+5, width: width, height: self.choiceTable.count * 40 > 300 ? 300 : self.choiceTable.count * 40)

        }, completion: nil)
    }
    @objc private func removeTransporentView(){
        let frames = selectedButton.frame
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transporentView.alpha = 0

            self.tableView.frame=CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)

        }, completion: nil)
        isActiveButton = false
    }
}


extension AdditionViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = choiceTable[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return choiceTable.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedButton.setTitle(choiceTable[indexPath.row], for: .normal)
//        dropDown!.closeTransporentView(self)
        removeTransporentView()
    }
}

extension AdditionViewController{
    private func isLeap(year:Int)->Bool{
        if (year%400 == 0 || (year%100 != 0 && year%4 == 0)){
            return true
        }
        return false
    }
}
