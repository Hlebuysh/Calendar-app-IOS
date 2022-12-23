
import UIKit
//import Firebase



class AdditionViewController: UIViewController{
    
    @IBOutlet weak private var buttonStack: UIStackView!
    @IBOutlet weak private var yearButton: UIButton!
    @IBOutlet weak private var monthButton: UIButton!
    @IBOutlet weak private var dayButton: UIButton!
    
    @IBOutlet weak private var startTimePicker: UIPickerView!
    @IBOutlet weak private var endTimePicker: UIPickerView!
    
    @IBOutlet weak private var titleText: UITextField!
    @IBOutlet weak private var descriptionText: UITextView!
    
    @IBOutlet weak var addUserStack: UIStackView!
    @IBOutlet weak private var addUserText: UITextField!
    @IBOutlet weak private var addUserButton: UIButton!
    
    private var stackPosition: CGRect = CGRect()
    @IBOutlet weak var stackTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak private var importanceSwitch: UISwitch!
    
    @IBOutlet weak private var saveButton: UIButton!
    
    private var dropDown: DropDown!
    
    private let months = ["Январь", "Февраль", "Март", "Апрель", "Май", "Июнь", "Июль", "Август", "Сентябрь", "Октябрь", "Ноябрь", "Декабрь"]
    
    
    private var selectedButton = UIButton()
    private var isActiveButton:Bool = false
    
    private var group: [String : Int] = [:]
    private var event = Event()
    
    var tview: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dropDown = DropDown(superVC: self, selection: changeTitle(title:))
        
        tview = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        tview.alpha = 0
        self.view.addSubview(tview)
        
        event.group[currentUserID()] = 1
        
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
        
        stackPosition = addUserStack.frame
    }
    
    @IBAction private func choiceYear(_ sender: Any) {
        selectedButton = yearButton
        isActiveButton = true
        dropDown.updateData(data: getYears())
        dropDown.openTransporentView(
            x: Int(buttonStack.frame.origin.x) + Int(yearButton.frame.origin.x),
            y: Int(buttonStack.frame.origin.y) + Int(yearButton.frame.origin.y) + Int(yearButton.frame.height),
            width: Int(yearButton.frame.width)
        )
    }
    @IBAction private func choiceMonth(_ sender: Any) {
        selectedButton = monthButton
        isActiveButton = true
        dropDown.updateData(data: getMonth(year: yearButton.title(for: .normal)!))
        dropDown.openTransporentView(
            x: Int(buttonStack.frame.origin.x) + Int(monthButton.frame.origin.x),
            y: Int(buttonStack.frame.origin.y) + Int(monthButton.frame.origin.y) + Int(monthButton.frame.height),
            width: Int(monthButton.frame.width)
        )
    }
    @IBAction private func choiceDay(_ sender: Any) {
        selectedButton = dayButton
        isActiveButton = true
        dropDown.updateData(data: getDays(year: yearButton.title(for: .normal)!, month: monthButton.title(for: .normal)!))
        dropDown.openTransporentView(
            x: Int(buttonStack.frame.origin.x) + Int(dayButton.frame.origin.x),
            y: Int(buttonStack.frame.origin.y) + Int(dayButton.frame.origin.y) + Int(dayButton.frame.height),
            width: Int(dayButton.frame.width)
        )
    }
    
    
    @IBAction func searchUser(_ sender: Any) {
        if addUserText.text!.isEmpty{
            showAlert(title: "Заполните поле", message: "Введите имя пользователя")
            return
        }
        if let member = findUser(login: addUserText.text!){
            event.group[member] = 0
            dropDown.closeTransporentView()
        }
        else{
            showAlert(message: "Такого пользователя не существует")
        }
    }
    @IBAction func userChanged(_ sender: Any) {
        if dropDown.isOpen(){
            if addUserText.text! == ""{
                dropDown.updateDataWithReload(
                    data: [],
                    x: Int(addUserStack.frame.origin.x),
                    y: Int(addUserStack.frame.origin.y) + Int(addUserStack.frame.height) + 5,
                    width: Int(addUserText.frame.width))

                return
            }
            var group: [String] = []
            for member in event.group.keys{
                group.append(member)
            }
            dropDown.updateDataWithReload(
                data: getUserBySubstring(substring: addUserText.text!, group: group),
                x: Int(addUserStack.frame.origin.x),
                y: Int(addUserStack.frame.origin.y) + Int(addUserStack.frame.height) + 5,
                width: Int(addUserText.frame.width))
            return
        }
        searchUsers()
    }
    
    @IBAction func touchOnUserField(_ sender: Any) {
        searchUsers()
    }
    
    
    
    @IBAction func addEvent(_ sender: Any) {
        if titleText.text!.isEmpty{
            showAlert(message: "")
            return
        }
        event.creator = currentUserID()
        
        event.date = dayButton.title(for: .normal)!.count == 1 ? "0" : ""
        event.date += dayButton.title(for: .normal)! + "."
        event.date += String(months.firstIndex(of: monthButton.title(for: .normal)!)!+1).count == 1 ? "0" : ""
        event.date += String(months.firstIndex(of: monthButton.title(for: .normal)!)!+1) + "."
        event.date += yearButton.title(for: .normal)!
        
        event.startTime = String(startTimePicker.selectedRow(inComponent: 0)).count == 1 ? "0" : ""
        event.startTime += String(startTimePicker.selectedRow(inComponent: 0)) + ":"
        event.startTime += String(startTimePicker.selectedRow(inComponent: 1)).count == 1 ? "0" : ""
        event.startTime += String(startTimePicker.selectedRow(inComponent: 1))
        
        event.endTime = String(endTimePicker.selectedRow(inComponent: 0)).count == 1 ? "0" : ""
        event.endTime += String(endTimePicker.selectedRow(inComponent: 0))+":"
        event.endTime += String(endTimePicker.selectedRow(inComponent: 1)).count == 1 ? "0" : ""
        event.endTime += String(endTimePicker.selectedRow(inComponent: 1))
        
        if (event.startTime > event.endTime){
            showAlert(message: "Начальное время должно быть меньше конечного")
            return
        }
        
        event.title = titleText.text!
        
        if !(self.descriptionText.textColor == UIColor.lightGray){
            event.description = descriptionText.text ?? ""
        }
        
        event.isImpotant = importanceSwitch.isOn
        
        saveEvent(event: event)
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
        return row < 10 ? ("0" + String(row)) : String(row)
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
    func changeTitle(title: String){
        if (isActiveButton){
            selectedButton.setTitle(title, for: .normal)
            isActiveButton = false
            return
        }
        event.group[findUser(login: title)!] = 0
        addUserText.text = ""
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.view.frame = CGRect(x: self.view.frame.origin.x, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
    }
}


extension AdditionViewController{
    func searchUsers(){
        if addUserText.text! == ""{
            dropDown.updateData(data: [])
        }
        else{
            var gr: [String] = []
            for member in event.group.keys{
                gr.append(member)
            }
            dropDown.updateData(data: getUserBySubstring(substring: addUserText.text!, group: gr))
        }
        dropDown.openTransporentView(
            x: Int(addUserStack.frame.origin.x),
            y: Int(addUserStack.frame.origin.y) + Int(addUserStack.frame.height) + 5,
            width: Int(addUserText.frame.width)
        )
        self.view.bringSubviewToFront(addUserStack)
        
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.view.frame = CGRect(x: self.view.frame.origin.x, y: -CGFloat(self.view.frame.height - 320), width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
    }
}
