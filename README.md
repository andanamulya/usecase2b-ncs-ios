# Usecase2B
Use Case for Vendor Pre-Qualifications Stage

# Requirements

Company A is a business that needs to manage the reliability of energy and gas supply in Singapore. As part of its day to day operations, Company A’s technicianwould need to inspect the various Transmission Line equipment and if defects are identified, they would need to record it so Spare Parts can be reserved from warehouse.The Technician would then need to go to warehouse, collect the spare parts and perform the repair on his next visit.Currently the entire process is somewhat manual and is using pen & paper so there are a lot of inefficiencies.The Field Technician manager had identified the following Use Cases as a priority for the new system that would help automate thisprocess.

# Use Cases

1. As a Field Technician, I should be able to access the system through my mobile phone and see the list of Sites that I need to inspect for the day

2. As a Field Technician, once I selected the Site/Job, I would be able to see the Site description and I need to be able to see how I can travel to the location

3. As a Field Technician, after I completed Inspection, I should be able to update the status and input remarks of the Site through my mobile phone

4. As a Field Technician, I can indicate which spare parts isneeded to fix the issue at the Site that I just visited. Once spare parts are indicated,they would be reserved until it is collected.

5. As a Field Technician Manager, I would be able to see all the Sites/Jobs that are scheduled today across all the Technician through my dashboard. Ideally, I would be able to see the Job status as well (for eg: Sites that completed inspection and no issues are marked green, Sites that has issues are marked red, Sites that has yet to be inspected is gray, etc )

6. As a Field Technician Manager, I would need to know which spare parts that does not have enough quantity (the demand from Technician is higher than inventory) so I can raise a Purchase Request to Finance team.

# Technical Requirements

- *Frontend:Web / Mobile App* : You can either use responsive web design(Angular or React.Js), Native App (Swift or Kotlin) or cross platform stack (ReactNative or Flutter). The frontend should be able to communicate to the backend using secured HTTP protocol.
- *Backend*: use Golang or Java (version 1.8 and above, Spring framework)
- *Database*: you can use any DB of your own choice
- *Tests*: please ensure that you have included sufficient tests in your code
- *Commits*: please avoid only having 1 commit into the repository. We would like to see how the Engineer gradually built the software and the thought process applied
- *Documentations*:provide sufficient documentation so reader can understand your code structure and your design considerations
- *Deployment*: apart from code submission in github, please provide the URL where the software has been deployed. Our assessor would need to view the completed Application

# Submissions

Qualified Suppliers are to upload their codes, documentations and tests in SP’s repository in github.com. 
Please inform the SP contact point the github UserID of the team members that need the Github access. SP staff would enroll them into the repository.
