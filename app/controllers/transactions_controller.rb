class TransactionsController < ApplicationController
  def new
    build_transaction
  end

  def create
    @transaction_form = TransactionCreateForm.new(create_params)

    if transaction = @transaction_form.call
      redirect_to transaction_path(id: transaction.id)
    else
      render :new
    end
  end

  def show
    @transaction = Transaction.find_by(id: params[:id])
  end

  private

  def create_params
    params.require(:transaction_create_form)
          .permit(:email, :address, :amount_base, :exchange_rate, :terms, :base, :target)
  end

  def build_transaction
    build_params = {
      base: 'UST',
      target: 'BTC',
      exchange_rate: CurrentRateService.new.call
    }

    @transaction_form = TransactionCreateForm.new(build_params)
  end
end
