class AddRemoteSideIdToExpectedEvents < ActiveRecord::Migration
  def change
    add_reference :expected_events, :remote_side, index: true
  end
end
