require "csv"

class Dashboard

  def self.get_data(departments=[], wards=[])

    file_name = "/tmp/orders"

    result = []

    rows = {}

    if File.exists?("#{file_name}.csv")
      data = CSV.table("#{file_name}.csv")
      panels = {}

      (data).each do |d|

        next if !departments.blank? and !d[11].blank? and !departments.include?(d[11].downcase.strip)

        next if !wards.blank? and !d[3].blank? !wards.include?(d[3].downcase.strip)

        test_name = d[8]
        panels[d[4]] = [] if panels[d[4]].blank?

        if !d[10].blank? and !panels[d[4]].include?(d[14])

          test_name = d[14]

          panels[d[4]] << d[14]

        elsif  !d[10].blank? and panels[d[4]].include?(d[14])

          next

        end

        test_status = d[7].titleize

        case d[6]

          when "specimen-rejected"
            test_status = "<span class='red-color'>Rejected</span>"

          when "specimen-accepted"
            test_status = test_status.match(/Pending/i) ? "Ordered" : test_status

          when "specimen-not-collected"
            test_status = test_status.match(/Pending/i) ? "Ordered" : test_status
        end

        case test_status

          when "Completed"
            test_status = "<span class='red-color'>Verify</span>"

          when "Verified"
            test_status = "<span class='red-color'>Print</span>"

          when "Started"
            test_status = "<span>In-Progress</span>"

        end

        priority = d[15][0 .. 3].upcase rescue "N/A"

        lifespan = (d[16] || 8).to_i

        hrs_ago = ((Time.now - d[13].to_datetime)/1.hour).round(2)

        percent_viability = (100 - (hrs_ago/lifespan)*100.0).round(1) rescue 0
        percent_viability = 0 if percent_viability < 0
        percent_viability = 100 if percent_viability > 100

        result << {
            'patient_name' => ((d[1].length > 19) ? (d[1][0 .. 17] + "..") : d[1]),
            'npid' => d[2],
            'ward' => d[3],
            'accession_number' => d[4],
            'specimen_type_name' => d[5],
            'specimen_status' => d[6],
            'test_status' =>  test_status,
            'test_type_name' => test_name.sub(/Sterile Fluid Analysis/, "SF Analysis"),
            'clinician' =>  d[9],
            'panel_id' => d[10],
            'department' => d[11].downcase,
            'last_update_date' => d[12],
            'date_ordered' => d[13],
            'priority' => priority,
            'lifespan' => percent_viability
        }


      end
    end

    result
  end

  def self.get_stats(departments = [], wards = [])

    result = {
        'received' => 0,
        'ordered' => 0,
        'started' => 0,
        'pending' => 0,
        'completed' => 0,
        'verified' => 0,
        'rejected' => 0,
        'voided' => 0,
        'not-done' => 0
    }

    file_name = "/tmp/orders_aggregates"

    if File.exists?("#{file_name}.csv")

      data = CSV.table("#{file_name}.csv")

      data.each do |d|

        #filters
        next if !departments.blank? && !d[2].blank? && !departments.include?(d[2].downcase.strip)

        next if !wards.blank? && !d[3].blank? && !wards.include?(d[3].downcase.strip)

        case d[0]

          when "specimen-not-collected"
            if d[1].match(/Pending/i)
              result['ordered'] += d[4].to_i
            else
              result[d[1].downcase] += d[4].to_i
            end

          when "specimen-rejected"
            result['rejected'] += d[4].to_i

          else
            if d[1].match(/Pending/i)
              result['ordered'] += d[4].to_i
            else
              result[d[1].downcase] += d[4].to_i
            end

        end

      end

    end

    result

  end

end