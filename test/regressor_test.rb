require_relative "test_helper"

class RegressorTest < Minitest::Test
  def test_works
    x_train, y_train, x_test, _ = boston_data

    model = Xgb::Regressor.new
    model.fit(x_train, y_train)
    y_pred = model.predict(x_test)
    expected = [28.509018, 25.23551, 24.38023, 32.31889, 33.371517, 27.57522]
    assert_elements_in_delta expected, y_pred[0, 6]

    model.save_model(tempfile)

    model = Xgb::Regressor.new
    model.load_model(tempfile)
    assert_equal y_pred, model.predict(x_test)
  end

  def test_feature_importances
    x_train, y_train, _, _ = boston_data

    model = Xgb::Regressor.new
    model.fit(x_train, y_train)

    expected = [0.01210404, 0.00495621, 0.01828066, 0.0, 0.01790345, 0.68894494, 0.01395558, 0.01747261, 0.01420494, 0.03188109, 0.03816482, 0.00890863, 0.13322297]
    assert_elements_in_delta expected, model.feature_importances
  end
end
