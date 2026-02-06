class TransactionsController < ApplicationController
  before_action :set_transaction, only: %i[ show edit update destroy ]

  # GET /transactions or /transactions.json
  def index
    if current_user.id != nil
      @transactions = Transaction.where(user_id: current_user.id)
    else
      # if current user is not null, assign all transactions
      @transactions = Transaction.all
    end
  end


  # GET /transactions/1 or /transactions/1.json
  def show
  end

  # GET /transactions/new
  def new
    @transaction = Transaction.new
    # We add these lines so that the selected product’s data fields and user’s credit cards are available to the views at the front end
    if @product.nil?
      @product = Product.find(params[:product_id])
    end
    @credit_cards = current_user.credit_cards
  end


  # GET /transactions/1/edit
  def edit
  end

  # POST /transactions or /transactions.json
  def create
    @transaction = Transaction.new(transaction_params)
    # We create the transaction number using a random string of length 10
    @transaction.transaction_number = Array.new(10){[*"A".."Z", *"0".."9"].sample}.join
    @product = Product.find(params[:transaction][:product_id])
    # We link the transaction to the current user and their credit card
    @transaction.user = current_user # insert the correct call to an appropriate function here
    # We update the original product quantity
    @product.quantity = @product.quantity - @transaction.quantity
    @product.save

    respond_to do |format|
      if @transaction.save
        format.html { redirect_to @transaction, notice: "Transaction was successfully created." }
        format.json { render :show, status: :created, location: @transaction }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /transactions/1 or /transactions/1.json
  def update
    respond_to do |format|
      if @transaction.update(transaction_params)
        format.html { redirect_to @transaction, notice: "Transaction was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @transaction }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /transactions/1 or /transactions/1.json
  def destroy
    @transaction.destroy!

    respond_to do |format|
      format.html { redirect_to transactions_path, notice: "Transaction was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transaction
      @transaction = Transaction.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def transaction_params
      params.require(:transaction).permit(:quantity, :total_cost, :product_id, :creditcard_id, :transaction_number)
    end
end
