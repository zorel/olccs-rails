class AddTypeToTribune < ActiveRecord::Migration
  def change
    add_column :tribunes, :type_slip, :integer, :default => Tribune::TYPE_SLIP_ENCODED

    #Tribune.all.each {|t|
    #  t.type_slip=Tribune::TYPE_SLIP_ENCODED
    #  t.save!
    #}
    #
    #%w(batavie see finss darkside).each {|s|
    #  t = Tribune.find_by_name(s)
    #  t.type_slip=Tribune::TYPE_SLIP_RAW
    #  t.save!
    #}

  end
end
