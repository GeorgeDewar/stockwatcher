require 'test_helper'

class WatchesControllerTest < ActionController::TestCase
  setup do
    sign_in users(:one)
    @watch = watches(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:watches)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create watch" do
    assert_difference('Watch.count') do
      post :create, watch: { stock_id: stocks(:one), threshold: 1 }
    end

    assert_redirected_to watches_path
  end

  test "should show watch" do
    get :show, id: @watch
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @watch
    assert_response :success
  end

  test "should update watch" do
    patch :update, id: @watch, watch: { stock_id: stocks(:one), threshold: 2 }
    assert_redirected_to watches_path
  end

  test "should destroy watch" do
    assert_difference('Watch.count', -1) do
      delete :destroy, id: @watch
    end

    assert_redirected_to watches_path
  end
end
