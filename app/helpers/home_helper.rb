module HomeHelper

 def lab_dashboard(list)
  priority = ["STAT", "ROUT", "OR"]
  (list || []).each do |specimen|
   test_priority = specimen['priority'].split(',')
   display_priority = (((test_priority.include?'S') ? 'STAT' : ((test_priority.include?'R') ? 'ROUT' : 'OR'))).upcase
    @specimens << { 'priority' => 'STAT', 'test' => specimen["test_type_name"],
                    "action" => calculate_viability(specimen["time_drawn"], 10),"location"=> specimen["location"][0..2].upcase,
                    'name' => specimen['patient_name'].gsub("N/A ", ""),"accession_number" => specimen['accession_number']}

  end

  return @specimens.sort_by { |hsh| [hsh["action"][1],priority.index(hsh['priority']),hsh['test']] }
 end

 def lab_registration(specimens)

  priority = ["STAT", "ROUT", "OR"]


  (specimens || []).each do |specimen|

   life_span = specimen["lifespan"].split(',').collect{|x| x.to_i}.sort
   test_priority = specimen['priority'].split(',')
   display_priority = (((test_priority.include?'S') ? 'STAT' : ((test_priority.include?'R') ? 'ROUT' : 'OR'))).upcase
    @specimens << { 'priority' => display_priority, 'orderer' => specimen['ordered_by'],
                    'status' => specimen['status'], 'department' => specimen['department'],
                    "action" => calculate_viability(specimen["time_drawn"], life_span[0]),
                    'name' => specimen['patient_name'].gsub("N/A ", "")}

  end
  return @specimens.sort_by { |hsh| [hsh["action"][1],priority.index(hsh['priority']),hsh['test']] }
 end

 def nurse_dashboard(list)

  priority = ["STAT", "ROUT", "OR"]
  action = {"Ordered" => "<span style='color:red;'>Draw sample</span>", "Received At Reception" => ["viability"],
            "Rejected" => "<span style='color:red;'>Redraw</span>", "Lost" => "<span style='color:red;'>Redraw</span>",
            "Tested" => "<span>Print</span>", "Received In Department" => ["viability"],
            "Drawn" => ["viability"],"Verification Pending" => "<span>View</span>",
            "Verified" => "<span style='color:red;'>Print</span>"}

  actions = ["Verified","Tested","Verification Pending","Drawn","Received In Department","Received At Reception",
             "Ordered","Lost","Rejected"]
  (list || []).each do |test|
   act = action[test['status'].split(',').uniq[0]]
   life_span = test["lifespan"].split(',').collect{|x| x.to_i}.sort
   test_priority = test['priority'].split(',')

   display_priority = (((test_priority.include?'S') ? 'STAT' : ((test_priority.include?'R') ? 'ROUT' : 'OR'))).upcase
	 display_status = test['status'].split(',').uniq[0]

    @specimens << { 'priority' => display_priority,'orderer' => test['ordered_by'],
                    'status' => display_status, 'department' => test['department'],
                    "action" => (act.is_a?(Array) ? calculate_viability(test["time_drawn"], life_span[0]) : act), 'name' => test['patient_name'].gsub("N/A ", "")}

  end

  return @specimens.sort_by {|hash| [actions.index(hash['status']),(hash['action'].is_a?(Array) ? hash['action'][1] : 0),priority.index(hash['priority']) ] }
 end

 def calculate_viability(time_spent, life_span)
  viability = (((life_span - ((Time.now - time_spent.to_time)/1.hour))/life_span)*100) rescue 0
  return ["viability",(viability < 0 ? 0 : (viability > 100 ? 100 : viability))] 
 end
end
