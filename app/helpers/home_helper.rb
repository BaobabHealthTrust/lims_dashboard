module HomeHelper

 def lab_dashboard(list)
  specimen_list = []
  priority = ["STAT", "ROUT", "OR"]
  state = {"Testing" => 0,"Received In Department"=> 1,"Received At Reception" => 1}
  (list || []).each do |specimen|
   testing = specimen["status"].split(',').uniq.include?'Testing'
   act = get_action(specimen['status'].split(',').uniq[0])
   test_priority = specimen['priority'].split(',')
   life_span = specimen["lifespan"].split(',').collect{|x| x.to_i}.sort
   viability = calculate_viability(specimen["time_drawn"], life_span[0])
   display_priority = (((test_priority.include?'S') ? 'STAT' : ((test_priority.include?'R') ? 'ROUT' : 'OR'))).upcase
   specimen_list << { 'priority' => display_priority, 'test' => specimen["test_type_name"],
                    "action" => (testing ? act : viability),
                    "location"=> specimen["location"][0..2].upcase,"accession_number" => specimen['accession_number'],
                    "state"=> specimen['status'].split(',').uniq[0],'class' => record_classification(viability[1],display_priority,specimen['status'].split(',').uniq[0]),
                    'name' => specimen['patient_name'].gsub("N/A ", "")}

  end

  return specimen_list.sort_by { |hsh| [state[hsh["state"]],(hsh['action'].is_a?(Array) ? hsh['action'][1] : 0),priority.index(hsh['priority']),hsh['test']] }
 end

 def lab_registration(specimens)

  priority = ["STAT", "ROUT", "OR"]
  specimen_list = []

  (specimens || []).each do |specimen|

   life_span = specimen["lifespan"].split(',').collect{|x| x.to_i}.sort
   test_priority = specimen['priority'].split(',')
   display_priority = (((test_priority.include?'S') ? 'STAT' : ((test_priority.include?'R') ? 'ROUT' : 'OR'))).upcase
   viability = calculate_viability(specimen["time_drawn"], life_span[0])
   specimen_list << { 'priority' => display_priority, 'orderer' => specimen['ordered_by'],
                    'status' => specimen['status'], 'department' => specimen['department'].split(', ').uniq,
                    "action" => viability,'name' => specimen['patient_name'].gsub("N/A ", ""),
                    'class' => record_classification(viability[1],display_priority, specimen['status'])}

  end
  return specimen_list.sort_by { |hsh| [hsh["action"][1],priority.index(hsh['priority']),hsh['test']] }
 end

 def nurse_dashboard(list)

  priority = ["STAT", "ROUT", "OR"]
  specimen_list = []
  actions = ["Verified","Tested","Verification Pending","Drawn","Received In Department","Received At Reception",
             "Ordered","Lost","Rejected", "Test Rejected"]
  (list || []).each do |test|
   act = get_action(test['status'].split(',').uniq[0])
   life_span = test["lifespan"].split(',').collect{|x| x.to_i}.sort
   test_priority = test['priority'].split(',')

   display_priority = (((test_priority.include?'S') ? 'STAT' : ((test_priority.include?'R') ? 'ROUT' : 'OR'))).upcase
	  display_status = test['status'].split(',').uniq[0]
   viability = calculate_viability(test["time_drawn"], life_span[0])
   orderer = test['ordered_by'].gsub!( "(1)", '')
   orderer = (orderer.upcase.include?'DR') ? orderer : (orderer.split(" ")[0][0].upcase + ". " + orderer.split(" ")[1])

   specimen_list << { 'priority' => display_priority,'orderer' => orderer,
                    'status' => display_status, 'department' => test['department'].split(', ').uniq,
                    "action" => (act.is_a?(Array) ? viability : act),'class' => record_classification(viability[1],display_priority, display_status),
                    'name' => test['patient_name'].gsub("N/A ", "")}

  end

  return specimen_list.sort_by {|hash| [actions.index(hash['status']),(hash['action'].is_a?(Array) ? hash['action'][1] : 0),priority.index(hash['priority']) ] }
 end

 def waiting_room(list)

  indexes = {"Pending" => 3, "Test in Progress" => 2,"Result pending" => 1, "Result Available" => 0}
  text = {'Received In Department' => "Pending", 'Testing' => "Test in Progress", 'Tested' => "Result pending", 'Verified' => "Result Available"}
  patients = []
  (list || []).each do |record|
   patients << {"patient" => record['patient_name'], "total_tests" => record['all_tests'],
                "available_results" => record['all_tests_with_results'],
                "recent_activity" => text[record['recent_activity']]}

  end

  return patients.sort_by {|hash| indexes[hash['recent_activity']]}
 end

 def calculate_viability(time_spent, life_span)
  viability = (((life_span - ((Time.now - time_spent.to_time)/1.hour))/life_span)*100) rescue 0
  return ["viability",(viability < 0 ? 0 : (viability > 100 ? 100 : viability))] 
 end

 def get_action(state)
  action = {"Ordered" => "<span style='color:red;'>Draw sample</span>",
            "Received At Reception" => ["viability"],"Testing" => "<span>In Progress</span>",
            "Rejected" => "<span style='color:red;'>Redraw</span>",
            "Sample Rejected" => "<span style='color:red;'>Redraw</span>",
            "Test Rejected" => "<span style='color:red;'>Re-Order Test</span>",
            "Result Rejected" => "<span style='color:red;'>Redraw</span>",
            "Lost" => "<span style='color:red;'>Redraw</span>",
            "Tested" => "<span>Print</span>", "Received In Department" => ["viability"],
            "Drawn" => ["viability"],"Verification Pending" => "<span>View</span>",
            "Verified" => "<span style='color:red;'>Print</span>"}
 return action[state]
 end

 def record_classification(viability,priority, status)
  if priority.upcase == "STAT"
   return "urgent"
  elsif viability <= 30 && (["Drawn","Received At Reception","Received In Department","Testing"].include?status)
   return "urgent"
  else
   return "normal"
  end
 end
end
