module HomeHelper

 def lab_dashboard(list)

  (list || []).each do |specimen|

    @specimens << { 'priority' => 'STAT', 'test' => specimen["test_type_name"],
                    "action" => calculate_viability(specimen["time_drawn"], 10),"location"=> "Unk",
                    'name' => specimen['patient_name'],"accession_number" => specimen['accession_number']}

  end

  return @specimens.sort_by { |hsh| [hsh["action"][1],hsh['test']] }
 end

 def lab_registration(specimens)

  priority = ["ST", "RT", "OP"]


  (specimens || []).each do |specimen|

   life_span = specimen["lifespan"].split(',').collect{|x| x.to_i}.sort
   test_priority = specimen['priority'].split(',')
   display_priority = (((test_priority.include?'STAT') ? 'st' : ((test_priority.include?'Routine') ? 'rt' : 'op'))).upcase
    @specimens << { 'priority' => display_priority, 'orderer' => specimen['ordered_by'],
                    'status' => specimen['status'], 'department' => specimen['department'],
                    "action" => calculate_viability(specimen["time_drawn"], life_span[0]),
                    'name' => specimen['patient_name']}

  end
  return @specimens.sort_by { |hsh| [hsh["action"][1],priority.index(hsh['priority']),hsh['test']] }
 end

 def nurse_dashboard(list)
  priority = ["ST", "RT", "OP"]
  action = {"Rejected" => "<span style='color:red;'>Draw sample</span>", "Received At Reception" => ["viability"],
            "Rejected" => "<span style='color:red;'>Redraw</span>", "Lost" => "<span style='color:red;'>Redraw</span>",
            "Tested" => "<span>Print</span>", "Received In Department" => ["viability"],
            "Drawn" => ["viability"],"Verification Pending" => "<span>Print</span>"}

  (list || []).each do |test|
   act = action[test['status']]
   life_span = test["lifespan"].split(',').collect{|x| x.to_i}.sort
   test_priority = test['priority'].split(',')
   display_priority = (((test_priority.include?'STAT') ? 'st' : ((test_priority.include?'Routine') ? 'rt' : 'op'))).upcase
    @specimens << { 'priority' => display_priority,'orderer' => test['ordered_by'],
                    'status' => test['status'], 'department' => test['department'],
                    "action" => (act.is_a?(Array) ? calculate_viability(test["time_drawn"], life_span[0]) : act), 'name' => test['patient_name']}

  end

  return @specimens.sort_by {|hash| priority.index(hash['priority']) }
 end

 def calculate_viability(time_spent, life_span)
  viability = (((life_span - ((Time.now - time_spent.to_time)/1.hour))/life_span)*100)
  return ["viability",(viability < 0 ? 0 : (viability > 100 ? 100 : viability))]
 end
end
