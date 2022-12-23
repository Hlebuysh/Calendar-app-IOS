//
//  Events.swift
//  Calendar
//
//  Created by User on 14.12.2022.
//

import Firebase

struct Event{
    var id: String
    var creator: String
    var date: String
    var startTime: String
    var endTime: String
    var title: String
    var description: String
    var isImpotant: Bool
    var group: [String : Int]
    init(){
        self.id = ""
        self.creator = ""
        self.date = ""
        self.startTime = ""
        self.endTime = ""
        self.title = ""
        self.description = ""
        self.isImpotant = false
        self.group = [:]
        
    }
    init(data: DataSnapshot){
        self.id = data.key
        print("Data:")
        print(data)
        let value = data.value as! [String:Any]
        self.creator = value["creator"] as! String
        self.date = value["date"] as! String
        self.startTime = value["start_time"] as! String
        self.endTime = value["end_time"] as! String
        self.title = value["title"] as! String
        self.description = value["description"] as! String
        self.isImpotant = value["is_important"] as! Bool
        self.group = value["group"] as! [String:Int]
    }
    init(_ id: String, _ creator: String, _ date: String, _ startTime: String, _ endTime: String, _ title: String, _ description: String, _ isImporant: Bool, _ group: [String : Int]){
        self.id = id
        self.creator = creator
        self.date = date
        self.startTime = startTime
        self.endTime = endTime
        self.title = title
        self.description = description
        self.isImpotant = isImporant
        self.group = group
    }
//    static func < (left: Event, right: Event) -> Bool{
//        return (left.date < right.date) || ((left.date == right.date) && (left.startTime < right.startTime)) || ((left.date == right.date) && (left.startTime == right.startTime) && (left.endTime < right.endTime))
//    }
}

fileprivate var events: [Event] = []
fileprivate var eventRequests: [Event] = []

func getEvents(updateProgress: @escaping (Float) -> Void, complition: @escaping () -> Void){
    if (users[currentUserID()]!["events"] as? [String:Bool] == nil){
        updateProgress(1)
        complition()
        return
    }
    for (key, stat) in (users[currentUserID()]!["events"] as! [String:Bool]){
        Database.database(url: "https://calendarappforios-default-rtdb.europe-west1.firebasedatabase.app").reference().child("events").child(key).observeSingleEvent(of: .value) { snapshot in
            if stat == true{
                events.append(Event(data: snapshot))
//                events.sort()
                events.sort { lEvent, rEvent in
                    return (lEvent.date < rEvent.date) || ((lEvent.date == rEvent.date) && (lEvent.startTime < rEvent.startTime)) || ((lEvent.date == rEvent.date) && (lEvent.startTime == rEvent.startTime) && (lEvent.endTime < rEvent.endTime))
                }
            }
                
            else{
                eventRequests.append(Event(data: snapshot))
//                eventRequests.sort()
                eventRequests.sort { lEvent, rEvent in
                    return (lEvent.date > rEvent.date) || ((lEvent.date == rEvent.date) && (lEvent.startTime > rEvent.startTime)) || ((lEvent.date == rEvent.date) && (lEvent.startTime == rEvent.startTime) && (lEvent.endTime > rEvent.endTime))
                }
            }
            updateProgress(Float(events.count + eventRequests.count)/Float((users[currentUserID()]!["events"] as! [String:Bool]).count))
            if  Float(events.count + eventRequests.count)/Float((users[currentUserID()]!["events"] as! [String:Bool]).count) == 1{
                complition()
            }
            
        }
    }
}

func getEventsByDate(date: Date) -> [Event]{
    var result: [Event] = []
    let dateformat = DateFormatter()
    dateformat.dateFormat = "dd.MM.YYYY"
    let strDate = dateformat.string(from: date)
    if var i = events.firstIndex(where: { event in
        event.date == strDate
    }) {
        while (i < events.count && events[i].date == strDate){
            result.append(events[i])
            i += 1
        }
    }
    
    return result
}
func getEventRequests() -> [Event]{
    return eventRequests
}
func requestsForming() -> [[Event]]{
    var requests: [[Event]] = [[]]
    if eventRequests.count == 0 { return [] }
    var day = eventRequests[0].date
    requests[0].append(eventRequests[0])
    if eventRequests.count == 1{
        return requests
    }
    for i in 1...(eventRequests.count - 1){
        if day != eventRequests[i].date{
            day = eventRequests[i].date
            requests.append([])
        }
        requests[requests.count - 1].append(eventRequests[i])
    }
    return requests
}

func saveEvent(event: Event){
    let ref = Database.database(url: "https://calendarappforios-default-rtdb.europe-west1.firebasedatabase.app").reference()
    let event_id = ref.child("events").childByAutoId()
    event_id.updateChildValues(["creator":event.creator, "date":event.date, "start_time":event.startTime, "end_time":event.endTime, "title":event.title, "description":event.description, "is_important":event.isImpotant, "group":event.group])
    for member in event.group.keys{
        ref.child("users").child(member).child("events").child(event_id.key!).setValue(false)
    }
    ref.child("users").child(Auth.auth().currentUser!.uid).child("events").child(event_id.key!).setValue(true)
    events.append(event)
    events.sort(by: { lEvent, rEvent in
        return (lEvent.date < rEvent.date) || ((lEvent.date == rEvent.date) && (lEvent.startTime < rEvent.startTime)) || ((lEvent.date == rEvent.date) && (lEvent.startTime == rEvent.startTime) && (lEvent.endTime < rEvent.endTime))
    })
    UIViewController.currentViewController().showAlert(title: "Готово", message: "Событие добавлено")
    
}

func refuseFromEvent(eventID: String){
    let ref = Database.database(url: "https://calendarappforios-default-rtdb.europe-west1.firebasedatabase.app").reference()
    ref.child("users").child(currentUserID()).child("events").child(eventID).removeValue { error, _ in
        if error != nil{
            UIViewController.currentViewController().showAlert(message: error!.localizedDescription)
        }
    }
    ref.child("events").child(eventID).child("group").child(currentUserID()).setValue(-1)
    eventRequests.remove(at: eventRequests.firstIndex(where: { event in
        return event.id == eventID
    })!)
}

func agreeToEvent(eventID: String){
    let ref = Database.database(url: "https://calendarappforios-default-rtdb.europe-west1.firebasedatabase.app").reference()
    ref.child("users").child(currentUserID()).child("events").child(eventID).setValue(true)
    ref.child("events").child(eventID).child("group").child(currentUserID()).setValue(1)
    events.append(eventRequests.remove(at: eventRequests.firstIndex(where: { event in
        return event.id == eventID
    })!))
    events.sort { lEvent, rEvent in
        return (lEvent.date < rEvent.date) || ((lEvent.date == rEvent.date) && (lEvent.startTime < rEvent.startTime)) || ((lEvent.date == rEvent.date) && (lEvent.startTime == rEvent.startTime) && (lEvent.endTime < rEvent.endTime))
    }
}

func isRequests() -> Bool{
    return eventRequests.count == 0 ? false : true
}
