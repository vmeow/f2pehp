class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]

  # GET /items
  # GET /items.json
  def index
    
    sort_by = params[:sort_by] || session[:sort_by]
    search_term = params[:search] || session[:search]
    if params[:sort_by] != session[:sort_by] || params[:search] != session[:search]
      session[:sort_by] = sort_by
      session[:search] = search_term
      redirect_to items_path(:sort_by => sort_by, :search => search_term) and return
    end
    
    case sort_by
    when 'client_ssn'
      ordering = 'client_ssn'
    when 'client_name'
      ordering = 'client_name'
    end
    
    
    if search_term != nil
      if search_term.count("0-9") > 0
        search_term = search_term.tr('-', '')
        search_term = search_term.tr(' ', '')
      end
      @items = Item.where("client_name like ? OR client_ssn like ? OR case_id like ?", "%#{search_term}%", "%#{search_term}%", "%#{search_term}%")
      @old_items = Item.where("(client_name like ? OR client_ssn like ? OR case_id like ?) AND date_opened < ?", "%#{search_term}%", "%#{search_term}%", "%#{search_term}%", 90.days.ago)
    else
      @items = Item.order(ordering)
      @old_items = Item.where("date_opened < ?", 90.days.ago)
    end  
    
    @items_alert_message = ""
    if @old_items.length > 0
      @items_alert_message = "Case has been open for 90 days: "
      @old_items.each do |item|
        @items_alert_message += item[:client_ssn] + ", "
      end
    end
    
    
    
end

  # GET /items/1
  # GET /items/1.json
  def show
  end

  # GET /items/new
  def new
    @item = Item.new
  end

  # GET /items/1/edit
  def edit
    @item = Item.find params[:id]
  end

  # POST /items
  # POST /items.json
  def create
    @item = Item.create!(item_params)
    tempCaseIdBase = ("%04d" % @item[:date_opened].year) + ("%02d" % @item[:date_opened].month) + ("%02d" % @item[:date_opened].day)
    if Setting.get_all.key?(tempCaseIdBase)
      idNum = Setting[tempCaseIdBase] + 1
    else
      idNum = 0
    end
    Setting[tempCaseIdBase] = idNum

    tempCaseId = tempCaseIdBase + ("%03d" % idNum)
    @item.update_attributes(case_id: tempCaseId)
    flash[:notice] = 'Item was successfully created.' + @item[:date_opened].year.to_s
    redirect_to items_path
  end

  # PATCH/PUT /items/1
  # PATCH/PUT /items/1.json
  def update
    respond_to do |format|
      if @item.update(item_params)
        format.html { redirect_to items_path, notice: 'Item was successfully updated.' }
        format.json { render :show, status: :ok, location: @item }
      else
        format.html { render :edit }
       format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    @item.destroy
    respond_to do |format|
      format.html { redirect_to items_url, notice: 'Item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end

    def item_params
      params.require(:item).permit(:client_ssn, :client_name, :date_opened, :date_closed, :name_of_clinic, :grant_year, :income_issues_wages, :income_issues_interest_dividends_schedule_b, :income_issues_business_income_schedule_c, :income_issues_capital_gain_loss_schedule_d, :income_issues_ira_pension, :income_issues_social_security_benefits, :income_issues_alimony, :income_issues_rental_royalty_partnership_s_corp_schedule_e, :income_issues_farming_income_schedule_f, :income_issues_unemployment, :income_issues_gambling_winnings, :income_issues_cancellation_of_debt, :income_issues_settlement_proceeds, :income_issues_other_income_issues, :deduction_issues_alimony, :deduction_issues_education_expenses_including_student_loan_interest, :deduction_issues_moving_expenses, :deduction_issues_ira_deduction, :deduction_issues_medical_and_dental_expenses, :deduction_issues_state_and_local_taxes, :deduction_issues_home_mortgage_interest, :deduction_issues_other_interest_expenses, :deduction_issues_charitable_contributions, :deduction_issues_casualty_and_theft_losses, :deduction_issues_unreimbursed_employee_business_expenses, :deduction_issues_other_itemized_deductions, :deduction_issues_business_expenses_schedule_c, :credit_issues_child_and_dependent_care_credit, :credit_issues_education_credits, :credit_issues_child_tax_credit_additional_child_tax_credit, :credit_issues_earned_income_tax_credit, :credit_issues_first_time_homebuyer_credit, :credit_issues_premium_tax_credit, :credit_issues_other_credits, :status_issues_ssn_tin, :status_issues_itin, :status_issues_filing_status, :status_issues_personal_dependency_exemptions, :status_issues_injured_spouse, :status_issues_innocent_spouse, :status_issues_employment_related_identity_theft, :status_issues_refund_related_identity_theft, :status_issues_nonfiler, :status_issues_worker_classification, :tax_issues_self_employment_tax, :tax_issues_suspected_return_preparer_fraud, :tax_issues_estimated_tax_payments, :tax_issues_withholdings, :tax_issues_refund, :tax_issues_assessment_statute_of_limitations, :tax_issues_collection_statute_of_limitations, :tax_issues_refund_statute_of_limitations, :penalty_issues_trust_fund_recovery_penalty, :penalty_issues_other_civil_penalties, :penalty_issues_additional_tax_on_distributions_from_qualified_retirement_plans, :penalty_issues_individual_shared_responsibility_payment, :collection_issues_payments, :collection_issues_installment_payment_agreement_ipa, :collection_issues_offer_in_compromise_oic, :collection_issues_currently_not_collectible_cnc, :collection_issues_liens, :collection_issues_levies_including_federal_payment_levy_program)
    end
end
