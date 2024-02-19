class AdminController < ApplicationController
  http_basic_authenticate_with name: 'admin', password: 'admin', on: :show

  def show
    @transactions = Transaction.all
    @success_transactions = @transactions.success
  end
end
