require 'test_helper'

class IncomingEventsControllerTest < ActionController::TestCase
  setup do
    @incoming_event = incoming_events(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:incoming_events)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create incoming_event" do
    assert_difference('IncomingEvent.count') do
      post :create, incoming_event: { event: @incoming_event.event }
    end

    assert_redirected_to incoming_event_path(assigns(:incoming_event))
  end

  test "should show incoming_event" do
    get :show, id: @incoming_event
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @incoming_event
    assert_response :success
  end

  test "should update incoming_event" do
    patch :update, id: @incoming_event, incoming_event: { event: @incoming_event.event }
    assert_redirected_to incoming_event_path(assigns(:incoming_event))
  end

  test "should destroy incoming_event" do
    assert_difference('IncomingEvent.count', -1) do
      delete :destroy, id: @incoming_event
    end

    assert_redirected_to incoming_events_path
  end
end
