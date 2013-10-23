class AddRemoteSideIdToAlarmNotifications < ActiveRecord::Migration
  def change
    add_reference :alarm_notifications, :remote_side, index: true
  end
end
