# Base controller class for all evaluation controller.
class Evaluation::BaseController < ApplicationController
  before_filter :authorize_global
  accept_api_auth :index
end
