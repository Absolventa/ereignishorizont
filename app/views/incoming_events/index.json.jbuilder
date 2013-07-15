json.array!(@incoming_events) do |incoming_event|
  json.extract! incoming_event, :title
  json.url incoming_event_url(incoming_event, format: :json)
end
