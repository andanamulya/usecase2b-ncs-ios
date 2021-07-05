//
//  TechnicianResolutionReportViewModel.swift
//  SP_Usecase
//
//  Created by Lester Cabalona on 1/7/21.
//

import UIKit
import Alamofire

protocol TechnicianInspectResolutionReportViewModelDelegate: BaseProtocol {}
class TechnicianInspectResolutionReportViewModel: BaseViewModel {
    var data:AssignmentModel?
    weak var delegate: TechnicianInspectResolutionReportViewModelDelegate?
    lazy var formData:TechnicianFormModel = TechnicianFormModel.init()
    
    /// Retrieve the page itle for specific job status
    /// - Returns: title string
    func getPageTitle() -> String{
        if let userData = self.data {
            if userData.jobStatus == .inspect {
                return "Inspection Report"
            }else  if userData.jobStatus == .fix {
                return "Resolution Report"
            }
        }
        return ""
    }
    
    /// Retrieve the right navigation title for specific job status
    /// - Returns: title string
    func getRightNavigationTitle() -> String {
        if let userData = self.data, userData.jobStatus == .fix {
            return "Submit"
        }
        return "Next"
    }
    
    /// Check if current user login role is techinician
    /// - Returns: True value if job status is for inspection
    func checkJobStatusInspection() -> Bool {
        if let userData = self.data, userData.jobStatus == .inspect {
            return true
        }
        return false
    }
    
    /// Check if current user login role is techinician
    /// - Returns: True value if job status is for fixing
    func checkJobStatusToFix() -> Bool {
        if let userData = self.data, userData.jobStatus == .fix {
            return true
        }
        return false
    }
    
    /// Check if current user login role is techinician
    /// - Returns: True value if job status is for completed
    func checkJobStatusCompleted() -> Bool {
        if let userData = self.data, userData.jobStatus == .complete {
            return true
        }
        return false
    }
    func submitResolutionForm(){
        let validation = ValidationService()
        do {
            let _ = try validation.validateResolutionRemark(self.formData.remarks)
            //Do resolution submission
           if let _data = self.data{
               let parameter:Parameters = ["assignmentId":_data.assignmentId,"status":"complete","resolutionRemarks":self.formData.remarks];
               AssignmentServiceManager.submitAssignment(parameters: parameter) { object in
                   self.formData.clean()
                   if let delegate = self.delegate {
                       delegate.displaySuccess(message: nil)
                   }
               } _: { error in
                if let delegate = self.delegate {
                    delegate.displayError(errorString:NetworkManager.ResponseErrorType.Generic.rawValue)
                }
               }
           }
        }catch {
            if let error = error as? ValidationError {
                if let delegate = self.delegate {
                    delegate.displayError(errorString: error.errorDescription!)
                }
            }
        }
    }
    func submitInspectionForm(){
        //Submit Inspection Report with no issues. (remarks can be empty)
        /*
         {
             "assignmentId" : "1",
             "status" : "ToInspect",
             "inspectionRemarks" : "Need Fix",
             "resolutionRemarks": "Fixed"
         }
         **/
        if let _data = self.data{
            let parameter:Parameters = ["assignmentId":_data.assignmentId,"status":"complete","inspectionRemarks":self.formData.remarks];
            AssignmentServiceManager.submitAssignment(parameters: parameter) { object in
                self.formData.clean()
                if let delegate = self.delegate {
                    delegate.displaySuccess(message: nil)
                }
            } _: { error in
                if let delegate = self.delegate {
                    delegate.displayError(errorString:NetworkManager.ResponseErrorType.Generic.rawValue)
                }
            }
        }else{
            if let delegate = self.delegate {
                delegate.displayError(errorString:NetworkManager.ResponseErrorType.Generic.rawValue)
            }
        }
    }
    
    func processInspectionRemarValidation() -> Bool{
        let validation = ValidationService()
        do {
            let _ = try validation.validateInspectionRemark(self.formData.remarks)
            return true
        }catch {
            if let error = error as? ValidationError {
                if let delegate = self.delegate {
                    delegate.displayError(errorString: error.errorDescription!)
                }
            }
        }
        return false
    }
    
    func updateRemarkValue(_ value:String){
        self.formData.remarks = value
    }
    
}
