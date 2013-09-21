require "spec_helper"

describe IncomingEventsController do
  describe "routing" do
    it "recognizes GET / and generates #index" do
      expect({ get: "/" }).to route_to controller: "incoming_events", action: "index"
    end

    it "recognizes GET / and generates #index" do
      expect({ post: "/" }).to route_to controller: "incoming_events", action: "create"
    end
  end
end
