module HomeHelper

 def lab_dashboard(list)
  specimen_list = []
=begin
  priority = ["STAT", "ROUT", "OR"]
  state = {"Testing" => 0,"Received In Department"=> 1,"Received At Reception" => 1}


  (list || []).each do |specimen|
   testing = specimen["test_status"].split(',').uniq.include?''
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
=end
  (list || []).each do |specimen|
    status = specimen['specimen_status'].match(/rejected/i) ? 'rejected' : specimen['test_status']
    life_span = specimen["lifespan"].split(',').collect{|x| x.to_i}.sort
    test_priority = specimen['priority'].split(',')
    display_priority = (((test_priority.include?'S') ? 'STAT' : ((test_priority.include?'R') ? 'ROUT' : 'OR'))).upcase
    viability = calculate_viability(specimen["date_ordered"], life_span[0])

    act = get_action(status.split(',').uniq[0])
    specimen_list << { 'test' => specimen["test_type_name"],
                       "action" =>  act,
                       "location"=> specimen["department"][0..2].upcase,
                       "accession_number" => specimen['accession_number'],
                       "last_update_date" => specimen['last_update_date'].to_datetime,
                       "date_ordered" => specimen['date_ordered'].to_datetime,
                       "status"=> (status == 'started') ? 'In Progress' : ((status == 'completed') ? '<i style="color:red">Verify</i>' : status.titleize),
                       'name' => specimen['patient_name'].gsub("N/A ", ""),
                       'priority' => display_priority,
                       'class' => record_classification(viability[1],display_priority, status),
                       'name_stub' => "***** ******"
    }

  end

  return specimen_list.sort_by { |hsh| [hsh["last_update_date"],  hsh["date_ordered"], hsh['accession_number'], hsh['status'], hsh['name']] }.reverse

 end

 def lab_registration(specimens)

  priority = ["STAT", "ROUT", "OR"]
  specimen_list = []

=begin

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
=end

   (specimens || []).each do |specimen|
     status = specimen['specimen_status'].match(/rejected/i) ? 'rejected' : specimen['test_status']

     life_span = specimen["lifespan"].split(',').collect{|x| x.to_i}.sort
     test_priority = specimen['priority'].split(',')
     display_priority = (((test_priority.include?'S') ? 'STAT' : ((test_priority.include?'R') ? 'ROUT' : 'OR'))).upcase
     viability = calculate_viability(specimen["date_ordered"], life_span[0])
     specimen_list << { 'priority' => display_priority,
                        'test' => specimen["test_type_name"],
                        'status' => status,
                        'department' => specimen["department"][0..2].upcase,
                        "action" => viability,
                        'name' => specimen['patient_name'].gsub("N/A ", ""),
                        'class' => record_classification(viability[1],display_priority, status)}

   end

  return specimen_list.sort_by { |hsh| [hsh["action"][1],priority.index(hsh['priority']),hsh['test']] }
 end

 def nurse_dashboard(list)

  priority = ["STAT", "ROUT", "OR"]
  specimen_list = []
  actions = ["Verified","Tested","Verification Pending","Drawn","Received In Department","Received At Reception",
             "Ordered","Lost","Test Rejected", "Sample Rejected", "Result Rejected"]

  (list || []).each do |test|
   act = get_action(test['status'].split(',').uniq[0])
   life_span = test["lifespan"].split(',').collect{|x| x.to_i}.sort
   test_priority = test['priority'].split(',')

   display_priority = (((test_priority.include?'S') ? 'STAT' : ((test_priority.include?'R') ? 'ROUT' : 'OR'))).upcase
	  display_status = test['status'].split(',').uniq[0]
   viability = calculate_viability(test["time_drawn"], life_span[0])
   orderer = test['ordered_by'].gsub!(/\(\d*\)/, '')
   orderer = "? ?" if orderer.blank?
   orderer = (orderer.upcase.include?'DR') ? orderer : (orderer.split(" ")[0][0].upcase + ". " + orderer.split(" ")[1])

   specimen_list << { 'priority' => display_priority,'orderer' => orderer,
                    'status' => display_status, 'department' => test['department'].split(', ').uniq,
                    "action" => (act.is_a?(Array) ? viability : act),'class' => record_classification(viability[1],display_priority, display_status),
                    'name' => test['patient_name'].gsub("N/A ", "")}

  end

  return specimen_list.sort_by {|hash| [actions.index(hash['status']),(hash['action'].is_a?(Array) ? hash['action'][1] : 0),priority.index(hash['priority']) ] }
 end

 def waiting_room(list)

  indexes = {"Pending" => 4, "Test in Progress" => 3,"Result pending" => 2,  "Rejected" => 1, "Result Available" => 0}
  text = {'Received In Department' => "Pending", 'Testing' => "Test in Progress", 'Tested' => "Result pending", 'Verified' => "Result Available",
          'Sample Rejected' => "Rejected", 'Test Rejected' => "Rejected", 'Result Rejected' => "Rejected"}
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
            "Result Rejected" => "<span style='color:red;'>Redraw</span>",
            "Sample Rejected" => "<span style='color:red;'>Redraw</span>",
            "Test Rejected" => "<span style='color:red;'>Re-Order Test</span>",
            "Result Rejected" => "<span style='color:red;'>Redraw</span>",
            "Lost" => "<span style='color:red;'>Redraw</span>",
            "Tested" => "<span>Print</span>", "Received In Department" => ["viability"],
            "Drawn" => ["viability"],"Verification Pending" => "<span>View</span>",
            "Verified" => "<span style='color:red;'>Print</span>"}
 return action[state]
 end

 def get_action_new(state)
   action = {"pending" => "<span style='color:red;'>Draw sample</span>",
             "started" => ["viability"],"Testing" => "<span>In Progress</span>",
             "specimen-rejected" => "<span style='color:red;'>Re-Order Test</span>",
             "completed" => "<span>Print</span>",
             "verified" => "<span style='color:red;'>Print</span>"}
   return action[state]
 end

 def record_classification(viability,priority, status)
  if priority.upcase == "STAT"
   return "urgent"
  elsif viability <= 30 && (["rejected","pending","started","not-received"].include?status.downcase)
   return "urgent"
  else
   return "normal"
  end
 end
end
