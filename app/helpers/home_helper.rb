module HomeHelper

 def lab_dashboard(list)

  (list || []).each do |specimen|
   @specimens << { 'priority' => 'STAT', 'test' => specimen["test_name"],
                   "action" => ["viability",rand(100)], 'name' => specimen['patient_name'],
                   "accession_number" => specimen['accession_number']}
  end

  return @specimens.sort_by { |hsh| [hsh['action'][1],hsh['test']] }
 end

 def lab_registration(lab)
  teams = ["Team A", "Team B", "Team C", "Team D"]
  priority = ["STAT", "IPD", "OPD"]
  status = ["Received","Not Delivered"]
  tests = ["Protein Count", "Uric Acid", "Creatine Kinase", "Alkaline Phosphatase","Blood Urea Nitrogen",
           "Total Cholesterol", "HIV Monitoring Panel","Malaria","Full Blood Count", "Erythrocyte Sedimentation Rate (ESR)"]
  action = {"Tested" => "Print","Not Delivered" => ["viability", rand(100)],
            "Received" => ["viability", rand(100)],
            "Rejected" => "<span style='color:red;'>Redraw</span>",
            "Lost" => "<span style='color:red;'>Redraw</span>"}
  (1..(rand(20))).each do |i|
   state = status[rand(2)]
   @specimens << { 'priority' => priority[rand(3)], 'orderer' => teams[rand(4)],
                   'status' => state, 'test' => tests[rand(10)],
                   "action" => action[state], 'name' => "Patient #{i}"}
  end
  return @specimens.sort_by { |hsh| [hsh['action'][1],priority.index(hsh['priority']),hsh['test']] }
 end

 def nurse_dashboard(station)
  priority = ["STAT", "IPD", "OPD"]
  status = ["Not Collected","Rejected", "Lost","Collected", "Tested"]
  action = {"Not Collected" => "<span style='color:red;'>Draw sample</span>", "Collected" => ["viability", rand(100)],
            "Rejected" => "<span style='color:red;'>Redraw</span>", "Lost" => "<span style='color:red;'>Redraw</span>",
            "Tested" => "<span>Print</span>" }
  tests = ["Protein Count", "Uric Acid", "Creatine Kinase", "Alkaline Phosphatase","Blood Urea Nitrogen",
           "Total Cholesterol", "HIV Monitoring Panel","Malaria","Full Blood Count", "Erythrocyte Sedimentation Rate (ESR)"]

  (1..(rand(25))).each do |i|
   state = status[rand(4)]
   @specimens << { 'priority' => priority[rand(3)],
                   'status' => state, 'test' => tests[rand(10)],
                   "action" => action[state], 'name' => "Patient #{i}"}
  end
  return @specimens.sort_by {|hash| [status.index(hash['status']),priority.index(hash['priority']),hash['action'][1]] }
 end
end
