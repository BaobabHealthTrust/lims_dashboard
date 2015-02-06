module HomeHelper

 def lab_dashboard(list)

  (list || []).each do |specimen|
   unless !['Results Pending'].include?specimen['status']
    @specimens << { 'priority' => 'STAT', 'test' => specimen["test_name"],
                    "action" => ["viability", (((10 - ((Time.now - specimen["date_collected"].to_time)/1.hour))/10)*100)],
                    'name' => specimen['patient_name'],"accession_number" => specimen['accession_number']}
   end
  end

  return @specimens.sort_by { |hsh| [hsh['action'][1],hsh['test']] }
 end

 def lab_registration(specimens)

  priority = ["STAT", "IPD", "OPD"]


  (specimens || []).each do |specimen|
   unless !['Pending'].include?specimen['status']
    @specimens << { 'priority' => priority[rand(3)], 'orderer' => specimen['doctor'],
                    'status' => specimen['status'], 'test' => specimen['test_name'],
                    "action" => ["viability", (((10 - ((Time.now - specimen["date_collected"].to_time)/1.hour))/10)*100)],
                    'name' => specimen['patient_name']}
   end
  end
  return @specimens.sort_by { |hsh| [priority.index(hsh['priority']),hsh['test']] }
 end

 def nurse_dashboard(list)
  priority = ["STAT", "IPD", "OPD"]
  action = {"Not Collected" => "<span style='color:red;'>Draw sample</span>", "Pending" => ["viability", rand(100)],
            "Rejected" => "<span style='color:red;'>Redraw</span>", "Lost" => "<span style='color:red;'>Redraw</span>",
            "Tested" => "<span>Print</span>", "Verification Pending" => "<span>Print</span>"}

  (list || []).each do |test|
   act = action[test['status']]
   unless !['Pending', 'Rejected', 'Verification Pending' ].include?test['status']
    @specimens << { 'priority' => priority[rand(3)],'orderer' => test['doctor'],
                    'status' => test['status'], 'test' => test['test_name'],
                    "action" => (act.is_a?(Array) ? calculate_viability(test["date_collected"], 10) : act), 'name' => test['patient_name']}
   end
  end

  return @specimens.sort_by {|hash| priority.index(hash['priority']) }
 end

 def calculate_viability(time_spent, life_span)
  ["viability",(((life_span - ((Time.now - time_spent.to_time)/1.hour))/life_span)*100)]
 end
end
