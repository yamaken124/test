csv_str = CSV.generate do |csv|
  cols = {
    '処理区分'     => ->(s){ '1' },
    '備考１' => ->(s){ '' },
    '備考２' => ->(s){ '' },
    '備考３' => ->(s){ '' },
    '備考４' => ->(s){ '' },
    '備考５' => ->(s){ '' },
  }

  # header
  csv << cols.keys

  # body
  @shipments.each do |shipment|
    csv << cols.map{|k, col| col.call(shipment) }
  end

end

NKF::nkf('--sjis -Lw', csv_str)