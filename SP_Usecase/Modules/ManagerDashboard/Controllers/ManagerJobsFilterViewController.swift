//
//  ManagerJobsFilterViewController.swift
//  SP_Usecase
//
//  Created by Zhou Hao on 2/7/21.
//

import UIKit

protocol ManagerJobsFilterViewControllerDelegate: AnyObject {
    func onSelect(assignments: [String], status: [TechnicianActiveSitesStatus])
}

class ManagerJobsFilterViewController: BaseViewController {

    private var technicians = [AssignmentModel]()   // key is email, value is the assignment model
    private var selectedAssignment = [Int]()        // row number
    private var selectedStatus = [Int]()
    
    // passed from ManagerManageJobsViewController
    var assignmentsData:[AssignmentModel]! {
        didSet {
            var unique = [String: AssignmentModel]()
            assignmentsData.forEach { assignment in
                if (unique[assignment.asigneeEmail] == nil) {
                    unique[assignment.asigneeEmail] = assignment
                }
            }
            technicians = Array(unique.values.map{ $0 }).sorted { $0.asigneeName < $1.asigneeName }
        }
    }
    // FIXME: This is not very good solution since it's relying on the sequence. It must be called after setting the assignmentData. Will find a better solution later
    var emailSelected = [String]() {
        didSet {
            emailSelected.forEach { email in
                for (index,technician) in technicians.enumerated() {
                    if technician.asigneeEmail == email {
                        selectedAssignment.append(index)
                    }
                }
            }
        }
    }
    var statusSelected = [TechnicianActiveSitesStatus]() {
        didSet {
            statusSelected.forEach { status in
                var index = 0
                TechnicianActiveSitesStatus.allCases.forEach { item in
                    if item.rawValue == status.rawValue {
                        selectedStatus.append(index)
                    }
                    index += 1
                }
            }
        }
    }
    weak var delegate: ManagerJobsFilterViewControllerDelegate?

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()

    }
    
    @IBAction func onClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onClear(_ sender: Any) {
        selectedAssignment.removeAll()
        selectedStatus.removeAll()
        tableView.reloadData()
    }
    
    @IBAction func onConfirm(_ sender: Any) {
        let assignments = selectedAssignment.map { technicians[$0].asigneeEmail }
        let status = selectedStatus.map { TechnicianActiveSitesStatus.allCases[$0] }
        
        delegate?.onSelect(assignments: assignments, status: status)
        dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ManagerJobsFilterViewController: UITableViewDelegate, UITableViewDataSource {
    enum Section: Int {
        case technician = 1
        case status = 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == Section.technician.rawValue {
            return technicians.count
        } else {
            return TechnicianActiveSitesStatus.allCases.count - 1 // no need to show none
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == Section.technician.rawValue {
            let assignment = technicians[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "TechnicianCell", for: indexPath)
            cell.textLabel?.text = assignment.asigneeName
            cell.detailTextLabel?.text = assignment.asigneeEmail
            cell.accessoryType = selectedAssignment.firstIndex(of: indexPath.row) != nil ? .checkmark : .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StatusCell", for: indexPath)
            cell.textLabel?.text = TechnicianActiveSitesStatus.allCases[indexPath.row].rawValue
            cell.accessoryType = selectedStatus.firstIndex(of: indexPath.row) != nil ? .checkmark : .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == Section.technician.rawValue {
            return "Technicians"
        } else {
            return "Status"
        }
    }
    
    // after tableView reload the selected status is cleared. So I only use didSelectRowAt function to select/unselect
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == Section.technician.rawValue {
            if let index = selectedAssignment.firstIndex(of: indexPath.row) {
                selectedAssignment.remove(at: index)
            } else {
                selectedAssignment.append(indexPath.row)
            }
        } else {
            if let index = selectedStatus.firstIndex(of: indexPath.row) {
                selectedStatus.remove(at: index)
            } else {
                selectedStatus.append(indexPath.row)
            }
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
//    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        if indexPath.section == 0 {
//            if let index = selectedAssignment.firstIndex(of: indexPath.row) {
//                selectedAssignment.remove(at: index)
//            }
//        } else {
//            if let index = selectedStatus.firstIndex(of: indexPath.row) {
//                selectedStatus.remove(at: index)
//            }
//        }
//        tableView.reloadRows(at: [indexPath], with: .automatic)
//    }
}
